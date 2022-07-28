import ISA_Decls :: *;

interface CSR_MIE_IFC;
   (* always_ready *)
   method Action reset;

   (* always_ready *)
   method WordXL mv_read;

   (* always_ready *)
   method ActionValue #(WordXL) mav_write (MISA misa, WordXL wordxl);
endinterface

(* synthesize *)
module mkCSR_MIE (CSR_MIE_IFC);
  // MIE reset value: 0 (all interrupts disabled)
  let mie_reset_value = 0;
  Reg #(Bit #(12)) rg_mie <- mkReg (mie_reset_value);

  method Action reset;
    rg_mie <= mie_reset_value;
  endmethod

  method WordXL mv_read;
    return zeroExtend (rg_mie);
  endmethod

  method ActionValue #(WordXL) mav_write (MISA misa, WordXL word);
    let mie = fv_fixup_mie (misa, truncate (word));
    rg_mie <= mie;
    return zeroExtend (mie);
  endmethod
endmodule

// Fix up word to be written to mie according to specs for
// supported / WPRI/ WLRL/ WARL fields.
function Bit #(12) fv_fixup_mie (MISA misa, Bit #(12)  mie);
  Bit #(12) new_mie = mie;
  return new_mie;
endfunction
