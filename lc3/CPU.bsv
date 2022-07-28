import RegFile::*;
import GetPut::*;
import FIFOF::*;
import ClientServer::*;

import TV_Info::*;
import ISA_Decls::*;
import GetPut_Aux::*;
import CSR_RegFile::*;
import SoC_Map::*;

// Register File
interface RegisterFile;
  method Value read1(RName x1);
  method Value read2(RName x1);
  method Action write(RName x1, Value x2);
endinterface

module mkRegisterFile(RegisterFile);

  // The array needs to have conflict-free writing and reading.
  // The stalling mechanism will guarantee that we never try to
  // read and write from the same register in the same clock cycle.
  // The reason that this needs to be conflict free is to prevent
  // a sequential conflict between the write-back stage (writing
  // to the array) and the decode stage (reading from the array).
  // The stages already have to be ordered in one direction because
  // of the buffers are one-place FIFOS with simultaneous enq/deq,
  // so the deq side must happen first, to make room for the enq.
  // Adding the reverse requirement (read the array before writing)
  // causes a conflict, and some stages would never be able to fire
  // in the same cycle.  This is not acceptable behavior.

  RegFile#(RName, Value) rs();
  mkRegFileWCF#(R0, R7) the_rs(rs);

  method read1(addr); return (addr == R0 ? 0 : rs.sub(addr)); endmethod
  method read2(addr); return (addr == R0 ? 0 : rs.sub(addr)); endmethod
  method write(addr, val) = rs.upd(addr, val);
endmodule

// Simple Memory Model
interface MemIF;
  method Bit#(XLEN) get(Bit#(XLEN) x1);
  method Action put(Bit#(XLEN) x1, Bit#(XLEN) x2);
endinterface

module mkMem(MemIF);
  RegFile#(Bit#(8), Bit#(XLEN)) arr();
  mkRegFileFull the_arr(arr);

  method get(a) ; return arr.sub(truncate(a)); endmethod
  method put(a, v) = arr.upd(truncate(a), v);
endmodule

// The processor
interface CPU_IFC;
  // Reset
  interface Server #(Bool, Bool) server_reset;

  method MemIF imem();
  method MemIF dmem();
  method Action start();
  method Bool done();

  interface Get #(Trace_Data) trace_data_out;
endinterface

typedef enum {
  CPU_RESET1,
  CPU_RESET2,
  CPU_RUNNING
} CPU_State deriving (Eq, Bits, FShow);

(* synthesize *)
module mkCPU(CPU_IFC);
  // System address map and pc reset value
  SoC_Map_IFC soc_map <- mkSoC_Map;

  // Reset requests and responses
  FIFOF #(Bool) f_reset_reqs <- mkFIFOF;
  FIFOF #(Bool) f_reset_rsps <- mkFIFOF;

  Reg #(Bool) rg_run_on_reset <- mkReg (False);

  // Major CPU states
  Reg #(CPU_State) rg_state <- mkReg (CPU_RESET1);

  MemIF instrMem();
  mkMem the_instrMem(instrMem);

  MemIF dataMem();
  mkMem the_dataMem(dataMem);

  RegisterFile rf();
  mkRegisterFile the_rf(rf);

  // Control and Status Registers (CSR)
  CSR_RegFile_IFC csr_regfile <- mkCSR_RegFile;

  // Some commonly used CSR values
  let mcycle = csr_regfile.read_csr_mcycle;

  Reg#(InstrAddr) pc();
  mkReg#(0) the_pc(pc);

  // The CPU leaves reset in an idle state and does not start fetching
  // instructions until this register is set to True.
  Reg#(Bool) started();
  mkReg#(False) the_started(started);

  FIFOF #(Trace_Data) f_trace_data <- mkFIFOF;
  Reg #(WordXL) rg_prev_mip <- mkReg (0);
  function Bool mip_cmd_needed ();
    // If the MTIP, MSIP, or xEIP bits of MIP have changed, then send a MIP update
    WordXL new_mip = csr_regfile.csr_mip_read;
    Bool mip_has_changed = (new_mip != rg_prev_mip);
    return mip_has_changed;
  endfunction: mip_cmd_needed

  // Current verbosity
  Bit #(4) cur_verbosity = 0;

  // BEGIN Functions
  // ===========================================================================
  function Action fa_start_ifetch (WordXL next_pc);
    action
	    stage1.enq (next_pc);
    endaction
  endfunction

  // Actions to restart from Debug Mode (e.g., GDB 'continue' after a breakpoint)
  function Action fa_restart (WordXL resume_pc);
    action
      fa_start_ifetch (resume_pc);
      rg_state <= CPU_RUNNING;
      rg_start_CPI_cycles <= mcycle;
      rg_start_CPI_instrs <= minstret;
    endaction
  endfunction

  // Aliases for looking up a register's value in the register file
  function rval1(r); return rf.read1(r); endfunction
  function rval2(r); return rf.read2(r); endfunction

  // Convert an XLEN-bit value into the abstract representation
  function Instr toInstr(Bit#(XLEN) bits);
    return (unpack (truncate (bits)));
  endfunction
  // ===========================================================================
  // END Functions

  rule rl_reset_start (rg_state == CPU_RESET1);
    let run_on_reset <- pop (f_reset_reqs);
    rg_run_on_reset <= run_on_reset;

    $display ("================================================================");
    $display ("CPU: Florence v0.0.1");
    $display ("================================================================");

    rg_state <= CPU_RESET2;

    if (cur_verbosity != 0) $display ("%0d: %m.rl_reset_start", mcycle);

    // If tandem verif
    let trace_data = mkTrace_RESET;
    f_trace_data.enq (trace_data);
    rg_prev_mip <= 0;
  endrule: rl_reset_start

  rule rl_reset_complete (rg_state == CPU_RESET2);
    WordXL dpc = truncate (soc_map.m_pc_reset_value);
    f_reset_rsps.enq (rg_run_on_reset);

    if (rg_run_on_reset) begin
      $display ("%0d: %m.rl_reset_complete: restart at pc = 0x%0h", mcycle, dpc);
      fa_restart (dpc);
    end else begin
      rg_state <= cpu_debug_mode;
      $display ("%0d: %m.rl_reset_complete: entering DEBUG_MODE", mcycle);
    end
  endrule: rl_reset_complete

  rule decode_add (started &&&
                   toInstr(instrMem.get(pc)) matches tagged Add {rd: .rd, ra: .ra, rb: .rb});
    rf.write(rd, rval1(ra) + rval2(rb));
    pc <= pc + 1;

    let trace_data = mkTrace_RET(pc);
    f_trace_data.enq(trace_data);
  endrule

  rule decode_loadc (started &&&
                     toInstr(instrMem.get(pc)) matches tagged LoadC {rd: .rd, v: .v});
    rf.write(rd, zeroExtend(v));
    pc <= pc + 1;
  endrule

  rule decode_store (started &&&
                     toInstr(instrMem.get(pc)) matches tagged Store {v: .v, addr: .addr});
    dataMem.put(rval1(addr), rval2(v));
    pc <= pc + 1;
  endrule

  rule decode_halt (started &&&
                    toInstr(instrMem.get(pc)) matches tagged Halt);
    started <= False;
  endrule

  // Exported interfaces
  // ===========================================================================
  interface imem = instrMem;
  interface dmem = dataMem;

  method Action start();
    started <= True;
  endmethod

  method done = !started;

  interface Get trace_data_out = toGet(f_trace_data);
  interface Server server_reset = toGPServer (f_reset_reqs, f_reset_rsps);
  // ===========================================================================

endmodule: mkCPU
