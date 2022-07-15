module Hello(
  input   clock,
  input   reset,
  output  io_led1,
  output  io_led2
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] cntReg; // @[Hello.scala 20:23]
  reg  blkReg1; // @[Hello.scala 21:24]
  reg  blkReg2; // @[Hello.scala 22:24]
  wire [31:0] _cntReg_T_1 = cntReg + 32'h1; // @[Hello.scala 24:20]
  wire  _GEN_2 = cntReg == 32'hb71b00 ? blkReg1 : blkReg2; // @[Hello.scala 25:28 28:13 22:24]
  assign io_led1 = blkReg1; // @[Hello.scala 30:11]
  assign io_led2 = blkReg2; // @[Hello.scala 31:11]
  always @(posedge clock) begin
    if (reset) begin // @[Hello.scala 20:23]
      cntReg <= 32'h0; // @[Hello.scala 20:23]
    end else if (cntReg == 32'hb71b00) begin // @[Hello.scala 25:28]
      cntReg <= 32'h0; // @[Hello.scala 26:12]
    end else begin
      cntReg <= _cntReg_T_1; // @[Hello.scala 24:10]
    end
    if (reset) begin // @[Hello.scala 21:24]
      blkReg1 <= 1'h0; // @[Hello.scala 21:24]
    end else if (cntReg == 32'hb71b00) begin // @[Hello.scala 25:28]
      blkReg1 <= ~blkReg1; // @[Hello.scala 27:13]
    end
    blkReg2 <= reset | _GEN_2; // @[Hello.scala 22:{24,24}]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  cntReg = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  blkReg1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  blkReg2 = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
