// A simulation model of external DRAM memory.
// Uses a register file to model memory.

import RegFile::*;

import ISA_Decls::*;

interface MemIF #(numeric type  depth);
  method Bit#(XLEN) get(Bit#(depth) x1);
  method Action put(Bit#(depth) x1, Bit#(XLEN) x2);
endinterface

module mkMem (MemIF #(depth));
  RegFile#(Bit#(depth), Bit#(XLEN)) arr <- mkRegFileFull;

  method get(a) ; return arr.sub(a); endmethod
  method put(a, v) = arr.upd(a, v);
endmodule
