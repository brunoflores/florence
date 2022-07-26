import GetPut::*;
import ClientServer::*;
import FIFOF::*;

import TV_Encode :: *;
import TV_Info::*;
import CPU::*;
import GetPut_Aux::*;

interface Core_IFC;
   // Debugging: set core's verbosity
   method Action set_verbosity (Bit #(4) verbosity, Bit #(64) logdelay);

   // Soft reset
   // 'Bool' is initial 'running' state
   interface Server #(Bool, Bool) cpu_reset_server;

   // CPU IMem to Fabric master interface
   // interface AXI4_Master_IFC #(Wd_Id, Wd_Addr, Wd_Data, Wd_User) cpu_imem_master;

   // CPU DMem to Fabric master interface
   // interface AXI4_Master_IFC #(Wd_Id, Wd_Addr, Wd_Data, Wd_User) cpu_dmem_master;

   // Optional Tandem Verifier interface output tuples (n,vb),
   // where 'vb' is a vector of bytes
   // with relevant bytes in locations [0]..[n-1]
   interface Get #(Info_CPU_to_Verifier) tv_verifier_info_get;
endinterface

(* synthesize *)
module mkCore(Core_IFC);
   // The CPU
   CPU_IFC cpu <- mkCPU;

   // Reset requests from SoC and responses to SoC
   // 'Bool' is 'running' state
   FIFOF #(Bool) f_reset_reqs <- mkFIFOF;
   FIFOF #(Bool) f_reset_rsps <- mkFIFOF;

   TV_Encode_IFC tv_encode <- mkTV_Encode;

   rule rl_cpu_reset_from_soc_start;
      let running <- pop (f_reset_reqs);
      cpu.server_reset.request.put (running);
      $display ("%0d: Core.rl_cpu_reset_from_soc_start", cur_cycle);
   endrule
endmodule: mkCore
