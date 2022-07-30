// This module is a slave on the interconnect Fabric.
//
// On the back side of the Mem_Controller is a ``raw'' memory
// interface, a simple, wide, R/W interface,
// which is connected to real memory in hardware (BRAM, DRAM, ...)
// and to a model thereof in simulation.
//
// The raw mem interface data width is typically one or two cache lines.
// Note: raw mem write requests are 'fire and forget'; there is no ack

export
  Bits_per_Raw_Mem_Addr,
  Raw_Mem_Addr,

  Bits_per_Raw_Mem_Word,
  Raw_Mem_Word;

import ISA_Decls::*;

// Raw mem data width:    256 (bits/ 32 x Byte/ 8 x Word32/ 4 x Word64)
// Raw mem address width: 64  (arbitrarily chosen generously large)

typedef XLEN Bits_per_Raw_Mem_Word;
typedef Bit #(XLEN) Raw_Mem_Word;
typedef XLEN Bits_per_Raw_Mem_Addr;
typedef Bit #(XLEN) Raw_Mem_Addr;
// typedef 256 Bits_per_Raw_Mem_Word;
// typedef Bit #(Bits_per_Raw_Mem_Word) Raw_Mem_Word;
// typedef 64 Bits_per_Raw_Mem_Addr;
// typedef Bit #(Bits_per_Raw_Mem_Addr) Raw_Mem_Addr;
