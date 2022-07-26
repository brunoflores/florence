// module mkTV_Encode is a transforming FIFO
// converting Trace_Data into encoded byte vectors

import GetPut::*;
import FIFOF::*;
import Vector::*;

import TV_Info::*;
import ISA_Decls::*;
import GetPut_Aux::*;

// ======================================================
// Encodings
Bit #(8) te_op_addl_state = 1;
Bit #(8) te_op_16b_instr = 2;

Bit #(8) te_op_addl_state_pc = 1;
// ======================================================

interface TV_Encode_IFC;
   method Action reset;

   // This module receives Trace_Data structs from the CPU and Debug Module
   interface Put #(Trace_Data) trace_data_in;

   // This module produces tuples (n,vb),
   // where 'vb' is a vector of bytes
   // with relevant bytes in locations [0]..[n-1]
   interface Get #(Tuple2 #(Bit #(XLEN), TV_Vec_Bytes)) tv_vb_out;
endinterface

(* synthesize *)
module mkTV_Encode (TV_Encode_IFC);
   Integer verbosity = 0; // For debugging
   Reg #(Bool) rg_reset_done <- mkReg (True);

   // Keep track of last PC for more efficient encoding of incremented PCs
   Reg #(WordXL) rg_last_pc <- mkReg (0);

   FIFOF #(Trace_Data) f_trace_data <- mkFIFOF;
   FIFOF #(Tuple2 #(Bit #(XLEN), TV_Vec_Bytes)) f_vb <- mkFIFOF;

   rule rl_log_trace_RET (rg_reset_done && (f_trace_data.first.op == TRACE_RET));
      let td <- pop (f_trace_data);

      // Encode components of td into byte vecs
      match { .n0, .vb0 } = encode_pc (td.pc);
      match { .nN, .vbN } = encode_instr (td.instr);
      // match { .n0, .vb0 } = encode_byte (te_op_begin_group);
      // match { .n1, .vb1 } = encode_pc (td.pc);
      // match { .n2, .vb2 } = encode_instr (td.instr);
      // match { .n3, .vb3 } = encode_priv (td.rd);
      // match { .n4, .vb4 } = encode_reg (fv_csr_regnum (csr_addr_mstatus), td.word1);
      // match { .nN, .vbN } = encode_byte (te_op_end_group);

      // Concatenate components into a single byte vec
      match { .nn0, .x0 } = vsubst (  0,  ?,  n0, vb0);
      match { .nnN, .xN } = vsubst (nn0, x0,  nN, vbN);
      // match { .nn0, .x0 } = vsubst (  0,  ?,  n0, vb0);
      // match { .nn1, .x1 } = vsubst (nn0, x0,  n1, vb1);
      // match { .nn2, .x2 } = vsubst (nn1, x1,  n2, vb2);
      // match { .nn3, .x3 } = vsubst (nn2, x2,  n3, vb3);
      // match { .nn4, .x4 } = vsubst (nn3, x3,  n4, vb4);
      // match { .nnN, .xN } = vsubst (nn4, x4,  nN, vbN);

      f_vb.enq (tuple2 (nnN, xN));
   endrule

   // INTERFACE
   method Action reset (); endmethod
   interface Put trace_data_in = toPut (f_trace_data);
   interface Get tv_vb_out = toGet (f_vb);
endmodule

function Tuple2 #(Bit #(XLEN), Vector #(TV_VB_SIZE, Byte)) encode_pc (WordXL word);
   Vector #(TV_VB_SIZE, Byte) vb = newVector;
   Bit #(XLEN) n = 4;
   vb [0] = te_op_addl_state;
   vb [1] = te_op_addl_state_pc;
   vb [2] = word [7:0];
   vb [3] = word [15:8];
   return tuple2 (n, vb);
endfunction

function Tuple2 #(Bit #(XLEN), Vector #(TV_VB_SIZE, Byte)) encode_instr (Bit #(XLEN) instr);
   Vector #(TV_VB_SIZE, Byte) vb = newVector;
   Bit #(XLEN) n = 3;
   vb [0] = te_op_16b_instr;
   vb [1] = instr [7:0];
   vb [2] = instr [15:8];
   return tuple2 (n, vb);
endfunction

// vsubst substitutes vb1[j1:j1+j2-1] with vb2[0:j2-1]
function Tuple2 #(Bit #(XLEN),
         Vector #(TV_VB_SIZE, Byte))
   vsubst (Bit #(XLEN) j1,
           Vector #(TV_VB_SIZE, Byte) vb1,
           Bit #(XLEN) j2,
           Vector #(m, Byte) vb2);

   function Byte f (Integer j);
      Byte x = vb1 [j];
      Bit #(XLEN) jj = fromInteger (j);
      if ((j1 <= jj) && (jj < j1 + j2))
        x = vb2 [jj - j1];
      return x;
   endfunction

   let v = genWith (f);
   let n = j1 + j2;

   return tuple2 (n, v);
endfunction
