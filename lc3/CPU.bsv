import RegFile::*;
import GetPut::*;
import FIFOF::*;
import ClientServer::*;

import TV_Info::*;
import ISA_Decls::*;
import GetPut_Aux::*;
import GPR_RegFile::*;
import CSR_RegFile::*;
import SoC_Map::*;
import CPU_Stage1::*;
import MemModel::*;

// The processor
interface CPU_IFC;
  // Reset
  interface Server #(Bool, Bool) server_reset;

  method MemIF #(8) imem();
  method MemIF #(8) dmem();

  // Tandem
  interface Get #(Trace_Data) trace_data_out;
endinterface

typedef enum {
  CPU_RESET1,
  CPU_RESET2,
  CPU_RUNNING
} CPU_State
deriving (Eq, Bits, FShow);

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

  // Memory models
  MemIF #(8) instrMem <- mkMem;
  MemIF #(8) dataMem <- mkMem;

  GPR_RegFile_IFC rf <- mkGPR_RegFile;

  // Control and Status Registers (CSR)
  CSR_RegFile_IFC csr_regfile <- mkCSR_RegFile;

  // Some commonly used CSR values
  let mcycle = csr_regfile.read_csr_mcycle;

  Reg #(Word) pc <- mkReg (0);

  // The CPU leaves reset in an idle state and does not start fetching
  // instructions until this register is set to True.
  // Reg#(Bool) started <- mkReg (False);

  FIFOF #(Trace_Data) f_trace_data <- mkFIFOF;
  Reg #(Word) rg_prev_mip <- mkReg (0);
  function Bool mip_cmd_needed ();
    // If the MTIP, MSIP, or xEIP bits of MIP have changed, then send a MIP update
    Word new_mip = csr_regfile.csr_mip_read;
    Bool mip_has_changed = (new_mip != rg_prev_mip);
    return mip_has_changed;
  endfunction

  // Current verbosity
  Bit #(4) cur_verbosity = 0;

  // BEGIN Functions
  // ===========================================================================
  function Action fa_start_ifetch (Word next_pc);
    action
	    stage1.enq (next_pc);
    endaction
  endfunction

  // Actions to restart from Debug Mode (e.g., GDB 'continue' after a breakpoint)
  function Action fa_restart (Word resume_pc);
    action
      fa_start_ifetch (resume_pc);
      rg_state <= CPU_RUNNING;
      rg_start_CPI_cycles <= mcycle;
      rg_start_CPI_instrs <= minstret;
    endaction
  endfunction

  // Aliases for looking up a register's value in the register file
  // function rval1(r); return rf.read_rs1(r); endfunction
  // function rval2(r); return rf.read_rs2(r); endfunction

  // Convert an XLEN-bit value into the abstract representation
  // function Instr toInstr(Bit #(XLEN) bits);
  //   return (unpack (truncate (bits)));
  // endfunction
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
  endrule

  rule rl_reset_complete (rg_state == CPU_RESET2);
    Word dpc = truncate (soc_map.m_pc_reset_value);
    f_reset_rsps.enq (rg_run_on_reset);

    if (rg_run_on_reset) begin
      $display ("%0d: %m.rl_reset_complete: restart at pc = 0x%0h", mcycle, dpc);
      fa_restart (dpc);
    end else begin
      rg_state <= cpu_debug_mode;
      $display ("%0d: %m.rl_reset_complete: entering DEBUG_MODE", mcycle);
    end
  endrule

  // rule decode_add (started &&&
  //                  toInstr(instrMem.get(pc)) matches tagged Add {rd: .rd, ra: .ra, rb: .rb});
  //   rf.write(rd, rval1(ra) + rval2(rb));
  //   pc <= pc + 1;

  //   let trace_data = mkTrace_RET(pc);
  //   f_trace_data.enq(trace_data);
  // endrule

  // rule decode_loadc (started &&&
  //                    toInstr(instrMem.get(pc)) matches tagged LoadC {rd: .rd, v: .v});
  //   rf.write(rd, zeroExtend(v));
  //   pc <= pc + 1;
  // endrule

  // rule decode_store (started &&&
  //                    toInstr(instrMem.get(pc)) matches tagged Store {v: .v, addr: .addr});
  //   dataMem.put(rval1(addr), rval2(v));
  //   pc <= pc + 1;
  // endrule

  // rule decode_halt (started &&&
  //                   toInstr(instrMem.get(pc)) matches tagged Halt);
  //   started <= False;
  // endrule

  // Exported interfaces
  // ===========================================================================
  interface imem = instrMem;
  interface dmem = dataMem;

  // method Action start();
  //   started <= True;
  // endmethod

  // method done = !started;

  interface Get trace_data_out = toGet(f_trace_data);
  interface Server server_reset = toGPServer (f_reset_reqs, f_reset_rsps);
  // ===========================================================================

endmodule
