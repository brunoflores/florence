import GetPut::*;
import FIFOF::*;
import ClientServer::*;
import RegFile::*;

import ISA_Decls::*;
import GetPut_Aux::*;

interface GPR_RegFile_IFC;
  // Reset
  interface Server #(Token, Token) server_reset;

  // GPR read
  (* always_ready *)
  method Word read_rs1 (RegName rs1);
  (* always_ready *)
  method Word read_rs2 (RegName rs2);

  // GPR write
  (* always_ready *)
  method Action write_rd (RegName rd, Word rd_val);
endinterface

// Major states of mkGPR_RegFile module
typedef enum { RF_RESET_START, RF_RESETTING, RF_RUNNING } RF_State
deriving (Eq, Bits, FShow);

(* synthesize *)
module mkGPR_RegFile(GPR_RegFile_IFC);
  Reg #(RF_State) rg_state <- mkReg (RF_RESET_START);

  // Reset
  FIFOF #(Token) f_reset_rsps <- mkFIFOF;

  // General Purpose Registers
  RegFile #(RegName, Word) regfile <- mkRegFileFull;

  // Reset.
  // This loop initializes all GPRs to 0.
  Reg #(RegName) rg_j <- mkRegU; // Tandem: Reset loop index

  rule rl_reset_start (rg_state == RF_RESET_START);
    rg_state <= RF_RESETTING;
    rg_j <= 1;
  endrule

  rule rl_reset_loop (rg_state == RF_RESETTING);
    regfile.upd (rg_j, 0);
    rg_j <= rg_j + 1;
    if (rg_j == 7) rg_state <= RF_RUNNING;
  endrule

  // Reset
  interface Server server_reset;
    interface Put request;
      method Action put (Token token);
        rg_state <= RF_RESET_START;

        // This response is placed here, and not in rl_reset_loop, because
        // reset_loop can happen on power-up, where no response is expected.
        f_reset_rsps.enq (?);
      endmethod
    endinterface

    interface Get response;
      method ActionValue #(Token) get if (rg_state == RF_RUNNING);
        let token <- pop (f_reset_rsps);
        return token;
      endmethod
    endinterface
  endinterface

   // GPR read
   method Word read_rs1 (RegName rs1);
     return ((rs1 == 0) ? 0 : regfile.sub (rs1));
   endmethod

   method Word read_rs2 (RegName rs2);
     return ((rs2 == 0) ? 0 : regfile.sub (rs2));
   endmethod

   // GPR write
   method Action write_rd (RegName rd, Word rd_val);
     if (rd != 0) regfile.upd (rd, rd_val);
   endmethod
endmodule
