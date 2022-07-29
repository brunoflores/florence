import ClientServer::*;

import CPU_Globals::*;
import ISA_Decls::*;
import GPR_RegFile::*;

export CPU_Stage1_IFC (..), mkCPU_Stage1;

interface CPU_Stage1_IFC;
  // Reset
  interface Server #(Token, Token) server_reset;

  // Output
  (* always_ready *)
  method Output_Stage1 out;

  (* always_ready *)
  method Action deq;

  // Input
  (* always_ready *)
  method Action enq (Addr next_pc);

  (* always_ready *)
  method Action set_full (Bool full);
endinterface

module mkCPU_Stage1
  #(Bit #(4) verbosity,
    GPR_RegFile_IFC gpr_regfile)
   (CPU_Stage1_IFC);
endmodule
