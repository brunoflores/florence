// ArithIO expresses the interactions of modules that do
// any kind of two-input, one-output arithmetic.
interface ArithIO #(type ty);
   method Action start (ty x, ty y);
   method ty result;
endinterface

module mkGCD (ArithIO#(Bit#(size_t)));
   Reg#(Bit#(size_t)) x();
   mkRegU reg_1(x);

   Reg#(Bit#(size_t)) y();
   mkRegU reg_2(y);

   rule flip (x > y && y != 0);
      x <= y;
      y <= x;
   endrule

   rule sub (x <= y && y != 0);
      y <= y - x;
   endrule

   method Action start(Bit#(size_t) num1, Bit#(size_t) num2) if (y == 0);
      x <= num1;
      y <= num2;
   endmethod

   method Bit#(size_t) result() if (y == 0);
      result = x;
   endmethod
endmodule
