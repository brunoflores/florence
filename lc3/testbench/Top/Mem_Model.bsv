// A simulation model of external DRAM memory.
// Uses a register file to model memory.

import RegFile::*;

import ISA_Decls::*;

interface Mem_Model_IFC #(numeric type  depth);
  // Read/write interface
  interface MemoryServer #(Bits_per_Raw_Mem_Addr, Bits_per_Raw_Mem_Word) mem_server;
endinterface

module mkMem_Model (Mem_Model_IFC);
endmodule
