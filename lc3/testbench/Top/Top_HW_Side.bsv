// mkTop_HW_Side is the top-level system for simulation.
// mkMem_Model is a memory model.

import Connectable::*;

import SoC_Top::*;
import Mem_Model::*;
import Cur_Cycle::*;

// Top-level module.
// Instantiates the SoC.
// Instantiates a memory model.
(* synthesize *)
module mkTop_HW_Side (Empty);
  SoC_Top_IFC soc_top <- mkSoC_Top;
  Mem_Model_IFC  mem_model <- mkMem_Model;

  // Connect SoC to raw memory
  let imemCnx <- mkConnection (soc_top.imem_to_raw_mem, mem_model.mem_server);
  // let dmemCnx <- mkConnection (soc_top.dmem_to_raw_mem, mem_model.mem_server);

  Reg #(Bool) rg_banner_printed <- mkReg (False);

  // Display a banner
  rule rl_step0 (!rg_banner_printed);
    $display ("================================================================");
    $display ("Bluespec RISC-V standalone system simulation v1.2");
    $display ("Copyright (c) 2017-2019 Bluespec, Inc. All Rights Reserved.");
    $display ("================================================================");

    rg_banner_printed <= True;

    // Set CPU verbosity and logdelay (simulation only)
    Bool v1 <- $test$plusargs ("v1");
    Bool v2 <- $test$plusargs ("v2");
    Bit #(4) verbosity = ((v2 ? 2 : (v1 ? 1 : 0)));
    Bit #(64) logdelay  = 0; // # of instructions after which to set verbosity
    soc_top.set_verbosity (verbosity, logdelay);

    // ----------------
    // Load tohost addr from symbol-table file
    // Bool watch_tohost <- $test$plusargs ("tohost");
    // let tha <- c_get_symbol_val ("tohost");
    // Bit #(32) tohost_addr = truncate (tha);
    // $display ("INFO: watch_tohost = %0d, tohost_addr = 0x%0h",
	  //           pack (watch_tohost), tohost_addr);
    // soc_top.set_watch_tohost (watch_tohost, tohost_addr);

    // ----------------
    // Start timing the simulation
    // Bit #(32) cycle_num <- cur_cycle;
    // c_start_timing (zeroExtend (cycle_num));

    // ----------------
    // Open file for Tandem Verification trace output
    // let success <- c_trace_file_open ('h_AA);
    // if (success == 0) begin
    //   $display ("ERROR: Top_HW_Side.rl_step0: error opening trace file.");
    //   $display ("    Aborting.");
    //   $finish (1);
    // end else begin
    //   $display ("Top_HW_Side.rl_step0: opened trace file.");
    // end
  endrule: rl_step0

  // Terminate on any non-zero status
  rule rl_terminate (soc_top.status != 0);
     // $display ("%0d: %m:.rl_terminate: soc_top status is 0x%0h (= 0d%0d)",
	   //           cur_cycle, soc_top.status, soc_top.status);

     // End timing the simulation
     // Bit #(32) cycle_num <- cur_cycle;
     // c_end_timing (zeroExtend (cycle_num));
     $finish (0);
  endrule

endmodule
