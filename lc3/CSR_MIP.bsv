import ISA_Decls::*;

interface CSR_MIP_IFC;
   (* always_ready *)
   method Action reset;

   (* always_ready *)
   method WordXL mv_read;

   (* always_ready *)
   method ActionValue #(WordXL) mav_write (MISA misa, WordXL wordxl);
endinterface

(* synthesize *)
module mkCSR_MIP (CSR_MIP_IFC);
  method Action reset;
  endmethod

  method WordXL mv_read;
    Bit #(12) new_mip = 0;
    return zeroExtend (new_mip);
  endmethod

  method ActionValue #(WordXL) mav_write (MISA misa,  WordXL wordxl);
    Bit #(12) new_mip = 0;
    return zeroExtend (new_mip);
  endmethod
endmodule
