// This package is the SoC "top-level".
//
// Note: there will be further layer(s) above this for
//  simulation top-level, FPGA top-level, etc.

export SoC_Top_IFC (..), mkSoC_Top;

import Memory::*;
import GetPut::*;

import Mem_Controller::*;
import TV_Info::*;
import SoC_Map::*;
import Core::*;
import ISA_Decls::*;

// The outermost interface of the SoC
interface SoC_Top_IFC;
  // Set core's verbosity
  method Action set_verbosity (Bit #(4) verbosity, Bit #(64) logdelay);

  // To tandem verifier
  interface Get #(Info_CPU_to_Verifier) tv_verifier_info_get;

  // External real memory
  interface
    MemoryClient #(XLEN, XLEN)
    imem_to_raw_mem;
  interface
    MemoryClient #(XLEN, XLEN)
    dmem_to_raw_mem;

  // UART0 to external console
  interface Get #(Bit #(8)) get_to_console;
  interface Put #(Bit #(8)) put_from_console;
endinterface

typedef enum {
  SOC_START,
  SOC_RESETTING,
  SOC_IDLE
} SoC_State
deriving (Bits, Eq, FShow);

(* synthesize *)
module mkSoC_Top (SoC_Top_IFC);
   Integer verbosity = 0; // Normally 0; non-zero for debugging
   Reg #(SoC_State) rg_state <- mkReg (SOC_START);

   // SoC address map specifying base and limit for memories, IPs, etc.
   SoC_Map_IFC soc_map <- mkSoC_Map;

   Core_IFC core <- mkCore;

   method Action set_verbosity (Bit #(4) to, Bit #(64) logdelay);
     core.set_verbosity (to, logdelay);
   endmethod

   // To tandem verifier
   interface tv_verifier_info_get = core.tv_verifier_info_get;

   // External real memory
   interface imem_to_raw_mem = core.cpu_imem_master;
   interface dmem_to_raw_mem = core.cpu_dmem_master;
endmodule
