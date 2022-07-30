typedef struct {} Output_Stage1 deriving (Bits);

instance FShow #(Output_Stage1);
  function Fmt fshow (Output_Stage1 x);
    Fmt fmt = $format ("Output_Stage1");
    return fmt;
  endfunction
endinstance
