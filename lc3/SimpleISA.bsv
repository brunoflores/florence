import RegFile::*;
// import "BDPI" function Bit#(32) fib (Bit#(32) n);

typedef enum
  {R0 , R1 , R2 , R3 , R4 , R5 , R6 , R7} RName
deriving (Bits, Eq);

typedef 16 XLEN;

typedef Bit#(XLEN) InstrAddr;
typedef Bit#(XLEN) Value;
typedef Bit#(7) Const;

typedef RName Src;
typedef RName Dest;
typedef RName Cond;
typedef RName Addr;
typedef RName Val;

// The data type for the instruction set
typedef union tagged {
  struct {Dest rd; Src   ra;   Src rb;} Add;
  struct {Cond cd; Addr  addr;        } Jz;
  struct {Dest rd; Addr  addr;        } Load;
  struct {Val  v;  Addr  addr;        } Store;
  struct {Dest rd; Const v;}            LoadC;
  void                                  Halt;
} Instr deriving (Bits);

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
interface CPU;
  method MemIF imem();
  method MemIF dmem();
  method Action start();
  method Bool done();
endinterface

module mkCPU(CPU);
  MemIF instrMem();
  mkMem the_instrMem(instrMem);

  MemIF dataMem();
  mkMem the_dataMem(dataMem);

  RegisterFile rf();
  mkRegisterFile the_rf(rf);

  Reg#(InstrAddr) pc();
  mkReg#(0) the_pc(pc);

  // The CPU leaves reset in an idle state and does not start fetching
  // instructions until this register is set to True.
  Reg#(Bool) started();
  mkReg#(False) the_started(started);

  // Aliases for looking up a register's value in the register file
  function rval1(r); return rf.read1(r); endfunction
  function rval2(r); return rf.read2(r); endfunction

  // Take a XLEN-bit value and convert it into the abstract representation
  function Instr toInstr(Bit#(XLEN) bits);
    return (unpack(truncate(bits)));
  endfunction

  rule decode_add (started &&&
                   toInstr(instrMem.get(pc)) matches
                     tagged Add {rd: .rd, ra: .ra, rb: .rb});
    rf.write(rd, rval1(ra) + rval2(rb));
    pc <= pc + 1;
  endrule

  rule decode_loadc (started &&&
                     toInstr(instrMem.get(pc)) matches
                       tagged LoadC {rd: .rd, v: .v});
    rf.write(rd, zeroExtend(v));
    pc <= pc + 1;
  endrule

  rule decode_store (started &&&
                     toInstr(instrMem.get(pc)) matches
                       tagged Store {v: .v, addr: .addr});
    dataMem.put(rval1(addr), rval2(v));
    pc <= pc + 1;
  endrule

  rule decode_halt (started &&&
                    toInstr(instrMem.get(pc)) matches
                      tagged Halt);
    started <= False;
  endrule

  // Exported interfaces
  interface imem = instrMem;
  interface dmem = dataMem;

  method Action start();
    started <= True;
  endmethod

  method done = !started;

endmodule

//

typedef Bit#(XLEN) MemAddr;

typedef union tagged {
  MemAddr WriteIMem;
  MemAddr WriteDMem;
  void Start;
  void Running;
} TestStage deriving (Eq, Bits);

(* synthesize *)
module mkCPUTest(Empty);
  CPU cpu();
  mkCPU the_cpu(cpu);

  Reg#(TestStage) state();
  mkReg#(WriteIMem(0)) the_state(state);

  MemAddr maxInstr = 3;
  function Instr nextInstr(MemAddr n);
   case (n)
     0 : return (tagged LoadC {rd: R4, v: 42});
     1 : return (tagged LoadC {rd: R0, v: 0});
     2 : return (tagged Store {v: R4, addr: R0});
     3 : return (tagged Halt);
   endcase
   // case (n)
   //    0 :  return (tagged LoadC {rd:R0, v:10});
   //    1 :  return (tagged LoadC {rd:R1, v:15});
   //    2 :  return (tagged LoadC {rd:R2, v:20});
   //    3 :  return (tagged Add {rd:R3, ra:R0, rb:R1});
   //    4 :  return (tagged Add {rd:R4, ra:R3, rb:R2});
   //    5 :  return (tagged Store {v:R4, addr:R1});
   //    6 :  return (tagged LoadC {rd:R5, v: 9});
   //    7 :  return (tagged Jz {cd:R0, addr:R5});
   //    8 :  return (tagged Add {rd:R4, ra:R4, rb:R4});
   //    9 :  return (tagged Store {v:R4, addr:R0});
   //   10 :  return (tagged Halt);
   // endcase
  endfunction

  rule writing_InstrMem (state matches (tagged WriteIMem .n));
     cpu.imem.put(n, zeroExtend(pack(nextInstr(n))));
     state <= (n == maxInstr ? Start : WriteIMem (n + 1));
  endrule

  rule starting_CPU (state matches Start);
     cpu.start;
     state <= Running;
  endrule

  rule done (state matches Running &&& cpu.done);
     $display("DMem location %d has value %d at time %d",
	      0, cpu.dmem.get(0), $stime);
     $finish(0);
  endrule

endmodule
