import RegFile::*;

typedef enum
  {R0 , R1 , R2 , R3 , R4 , R5 , R6 , R7} RName
deriving (Bits, Eq);

typedef Bit#(16) InstrAddr;
typedef Bit#(16) Value;
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
  method Bit#(16) get(Bit#(16) x1);
  method Action put(Bit#(16) x1, Bit#(16) x2);
endinterface

module mkMem(MemIF);
  RegFile#(Bit#(8), Bit#(16)) arr();
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

module mkCPU (CPU);
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

  // Take a 16-bit value and convert it into the abstract representation
  function Instr toInstr(Bit#(16) i16);
    return (unpack(truncate(i16)));
  endfunction

  rule decode_add (started &&&
                   toInstr(instrMem.get(pc)) matches
                     tagged Add {rd: .rd, ra: .ra, rb: .rb});
    rf.write(rd, rval1(ra) + rval2(rb));
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
