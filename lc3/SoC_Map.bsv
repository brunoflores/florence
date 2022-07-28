import Fabric_Defs::*;

export SoC_Map_IFC (..), mkSoC_Map;

interface SoC_Map_IFC;
  (* always_ready *)
  method Bit #(32) m_pc_reset_value;

  (* always_ready *)
  method Fabric_Addr m_boot_rom_addr_base;
endinterface

(* synthesize *)
module mkSoC_Map (SoC_Map_IFC);

  // Boot ROM
  Fabric_Addr boot_rom_addr_base = 'h_0000_1000;
  Fabric_Addr boot_rom_addr_size = 'h_0000_1000; // 4K
  Fabric_Addr boot_rom_addr_lim  = boot_rom_addr_base + boot_rom_addr_size;
  function Bool fn_is_boot_rom_addr (Fabric_Addr addr);
    return ((boot_rom_addr_base <= addr) && (addr < boot_rom_addr_lim));
  endfunction

  Bit #(32) pc_reset_value = boot_rom_addr_base;

  method Bit #(32) m_pc_reset_value = pc_reset_value;
  method Fabric_Addr m_boot_rom_addr_base = boot_rom_addr_base;
endmodule
