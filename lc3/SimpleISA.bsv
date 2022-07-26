import TV_Info::*;
import ISA_Decls::*;
import CPU::*;
import Core::*;

import "BDPI"
function Bit#(32) fib (Bit#(32) n);

import "BDPI"
function ActionValue #(Bit #(32)) c_trace_file_open (Bit #(8) dummy);

typedef Bit#(XLEN) MemAddr;

typedef union tagged {
  MemAddr WriteIMem;
  MemAddr WriteDMem;
  void Start;
  void Running;
} TestStage deriving (Eq, Bits);

(* synthesize *)
module mkCPUTest(Empty);
  CPU_IFC cpu();
  mkCPU the_cpu(cpu);

  Reg#(TestStage) state();
  mkReg#(WriteIMem(0)) the_state(state);

  MemAddr maxInstr = 3;
  function Instr nextInstr(MemAddr n);
   case (n)
     0 : return (tagged LoadC {rd: R4, v: 42});
     1 : return (tagged LoadC {rd: R0, v: 0});
     2 : return (tagged Store {v: R4, addr: R0});
     3 : return (tagged Halt);
   endcase
   // case (n)
   //    0 :  return (tagged LoadC {rd:R0, v:10});
   //    1 :  return (tagged LoadC {rd:R1, v:15});
   //    2 :  return (tagged LoadC {rd:R2, v:20});
   //    3 :  return (tagged Add {rd:R3, ra:R0, rb:R1});
   //    4 :  return (tagged Add {rd:R4, ra:R3, rb:R2});
   //    5 :  return (tagged Store {v:R4, addr:R1});
   //    6 :  return (tagged LoadC {rd:R5, v: 9});
   //    7 :  return (tagged Jz {cd:R0, addr:R5});
   //    8 :  return (tagged Add {rd:R4, ra:R4, rb:R4});
   //    9 :  return (tagged Store {v:R4, addr:R0});
   //   10 :  return (tagged Halt);
   // endcase
  endfunction

  rule writing_InstrMem (state matches (tagged WriteIMem .n));
     cpu.imem.put(n, zeroExtend(pack(nextInstr(n))));
     state <= (n == maxInstr ? Start : WriteIMem (n + 1));
  endrule

  rule starting_CPU (state matches Start);
     let success <- c_trace_file_open('h_AA);
     if (success == 0) begin
       $display("Error opening trace file");
       $finish(1);
     end else $display("Opened trace file");

     cpu.start;
     state <= Running;
  endrule

  rule done (state matches Running &&& cpu.done);
     $display("DMem location %d has value %d at time %d",
	      0, cpu.dmem.get(0), $stime);
     $display(fib(100));
     $finish(0);
  endrule

endmodule
