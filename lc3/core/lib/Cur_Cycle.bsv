// A convenience function to return the current cycle number during BSV simulations

ActionValue #(Bit #(32)) cur_cycle = actionvalue
  Bit #(32) t <- $stime;
  return t / 10;
endactionvalue;
