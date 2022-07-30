// mkTop_HW_Side is the top-level system for simulation.
// mkMem_Model is a memory model.

import Connectable::*;

import SoC_Top::*;
import Mem_Model::*;

// Top-level module.
// Instantiates the SoC.
// Instantiates a memory model.
(* synthesize *)
module mkTop_HW_Side (Empty);
  SoC_Top_IFC    soc_top   <- mkSoC_Top;
  Mem_Model_IFC  mem_model <- mkMem_Model;

  // Connect SoC to raw memory
  let imemCnx <- mkConnection (soc_top.imem_to_raw_mem, mem_model.mem_server);
  let dmemCnx <- mkConnection (soc_top.dmem_to_raw_mem, mem_model.mem_server);
endmodule
