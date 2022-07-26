// Definition of Tandem Verifier packets.

import Vector::*;

import ISA_Decls::*;

typedef enum {
  TRACE_RESET,
  TRACE_RET
} Trace_Op
deriving (Bits, Eq, FShow);

typedef struct {
  Trace_Op op;
  Bit#(XLEN) pc;
  Bit#(XLEN) instr;
} Trace_Data
deriving (Bits);

function Trace_Data mkTrace_RET(Bit#(XLEN) pc);
  Trace_Data td = ?;
  td.op = TRACE_RET;
  td.pc = pc;
  return td;
endfunction

// Trace_Data is encoded in module mkTV_Encode into vectors of bytes,
// which are eventually streamed out to an on-line tandem verifier/
// analyzer (or to a file for off-line tandem-verification/analysis).
//
// Various 'transactions' produce a Trace_Data struct.
// Each struct is encoded into a vector of bytes; the number
// of bytes depends on the kind of transaction and various encoding
// choices.

typedef 72 TV_VB_SIZE; // Max bytes needed for each transaction
typedef Vector #(TV_VB_SIZE, Byte) TV_Vec_Bytes;

typedef struct {
   Bit #(32) num_bytes;
   TV_Vec_Bytes vec_bytes;
} Info_CPU_to_Verifier deriving (Bits, FShow);
