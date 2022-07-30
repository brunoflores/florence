import FIFOF::*;
import GetPut::*;
import Memory::*;
import ClientServer::*;

import ISA_Decls::*;
import GetPut_Aux::*;

interface Near_Mem_IFC;
  // Reset
  interface Server #(Token, Token) server_reset;

  // IMem
  // CPU side
  interface IMem_IFC imem;
  // Fabric side
  interface MemoryClient #(XLEN, XLEN) imem_master;

  // DMem
  // CPU side
  interface DMem_IFC dmem;
  // Fabric side
  interface MemoryClient #(XLEN, XLEN) dmem_master;
endinterface

// Opcodes
typedef enum {
  CACHE_LD,
	CACHE_ST
} CacheOp
deriving (Bits, Eq, FShow);

interface IMem_IFC;
endinterface

interface DMem_IFC;
endinterface

// Module state
typedef enum {
  STATE_RESET,
  STATE_RESETTING,
  STATE_READY
} State
deriving (Bits, Eq, FShow);

(* synthesize *)
module mkNear_Mem (Near_Mem_IFC);
  Reg #(State) rg_state <- mkReg (STATE_READY);

  // Reset response queue
  FIFOF #(Token) f_reset_rsps <- mkFIFOF;

  // Reset
  interface Server server_reset;
    interface Put request;
      method Action put (Token t) if (rg_state == STATE_READY);
        rg_state <= STATE_RESET;
      endmethod
    endinterface

    interface Get response;
      method ActionValue #(Token) get ();
        let rsp <- pop (f_reset_rsps);
        return rsp;
      endmethod
    endinterface
  endinterface
endmodule
