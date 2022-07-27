import ISA_Decls :: *;

interface CSR_MIE_IFC;
   (* always_ready *)
   method Action reset;

   (* always_ready *)
   method WordXL mv_read;

   // Fixup wordxl and write, and return actual value written
   (* always_ready *)
   method ActionValue #(WordXL) mav_write (MISA misa, WordXL wordxl);
endinterface

(* synthesize *)
module mkCSR_MIE (CSR_MIE_IFC);
endmodule
