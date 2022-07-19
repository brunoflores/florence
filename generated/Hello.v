module Tx(
  input        clock,
  input        reset,
  output       io_txd,
  output       io_channel_ready,
  input        io_channel_valid,
  input  [7:0] io_channel_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [10:0] shiftReg; // @[Uart.scala 16:25]
  reg [19:0] cntReg; // @[Uart.scala 17:23]
  reg [3:0] bitsReg; // @[Uart.scala 18:24]
  wire  _io_channel_ready_T = cntReg == 20'h0; // @[Uart.scala 20:31]
  wire [9:0] shift = shiftReg[10:1]; // @[Uart.scala 26:28]
  wire [10:0] _shiftReg_T_1 = {1'h1,shift}; // @[Cat.scala 31:58]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[Uart.scala 28:26]
  wire [10:0] _shiftReg_T_3 = {2'h3,io_channel_bits,1'h0}; // @[Cat.scala 31:58]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[Uart.scala 39:22]
  assign io_txd = shiftReg[0]; // @[Uart.scala 21:21]
  assign io_channel_ready = cntReg == 20'h0 & bitsReg == 4'h0; // @[Uart.scala 20:40]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 16:25]
      shiftReg <= 11'h7ff; // @[Uart.scala 16:25]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 23:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 25:27]
        shiftReg <= _shiftReg_T_1; // @[Uart.scala 27:16]
      end else if (io_channel_valid) begin // @[Uart.scala 30:30]
        shiftReg <= _shiftReg_T_3; // @[Uart.scala 32:18]
      end else begin
        shiftReg <= 11'h7ff; // @[Uart.scala 35:18]
      end
    end
    if (reset) begin // @[Uart.scala 17:23]
      cntReg <= 20'h0; // @[Uart.scala 17:23]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 23:24]
      cntReg <= 20'h4e1; // @[Uart.scala 24:12]
    end else begin
      cntReg <= _cntReg_T_1; // @[Uart.scala 39:12]
    end
    if (reset) begin // @[Uart.scala 18:24]
      bitsReg <= 4'h0; // @[Uart.scala 18:24]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 23:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 25:27]
        bitsReg <= _bitsReg_T_1; // @[Uart.scala 28:15]
      end else if (io_channel_valid) begin // @[Uart.scala 30:30]
        bitsReg <= 4'hb; // @[Uart.scala 33:17]
      end
    end
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
  shiftReg = _RAND_0[10:0];
  _RAND_1 = {1{`RANDOM}};
  cntReg = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  bitsReg = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Buffer(
  input        clock,
  input        reset,
  output       io_in_ready,
  input        io_in_valid,
  input  [7:0] io_in_bits,
  input        io_out_ready,
  output       io_out_valid,
  output [7:0] io_out_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  stateReg; // @[Uart.scala 90:25]
  reg [7:0] dataReg; // @[Uart.scala 91:24]
  wire  _io_in_ready_T = ~stateReg; // @[Uart.scala 93:27]
  wire  _GEN_1 = io_in_valid | stateReg; // @[Uart.scala 97:23 99:16 90:25]
  assign io_in_ready = ~stateReg; // @[Uart.scala 93:27]
  assign io_out_valid = stateReg; // @[Uart.scala 94:28]
  assign io_out_bits = dataReg; // @[Uart.scala 107:15]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 90:25]
      stateReg <= 1'h0; // @[Uart.scala 90:25]
    end else if (_io_in_ready_T) begin // @[Uart.scala 96:28]
      stateReg <= _GEN_1;
    end else if (io_out_ready) begin // @[Uart.scala 102:24]
      stateReg <= 1'h0; // @[Uart.scala 103:16]
    end
    if (reset) begin // @[Uart.scala 91:24]
      dataReg <= 8'h0; // @[Uart.scala 91:24]
    end else if (_io_in_ready_T) begin // @[Uart.scala 96:28]
      if (io_in_valid) begin // @[Uart.scala 97:23]
        dataReg <= io_in_bits; // @[Uart.scala 98:15]
      end
    end
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
  stateReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  dataReg = _RAND_1[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BufferedTx(
  input        clock,
  input        reset,
  output       io_in_ready,
  input        io_in_valid,
  input  [7:0] io_in_bits,
  output       io_txd
);
  wire  tx_clock; // @[Uart.scala 117:18]
  wire  tx_reset; // @[Uart.scala 117:18]
  wire  tx_io_txd; // @[Uart.scala 117:18]
  wire  tx_io_channel_ready; // @[Uart.scala 117:18]
  wire  tx_io_channel_valid; // @[Uart.scala 117:18]
  wire [7:0] tx_io_channel_bits; // @[Uart.scala 117:18]
  wire  buf__clock; // @[Uart.scala 118:19]
  wire  buf__reset; // @[Uart.scala 118:19]
  wire  buf__io_in_ready; // @[Uart.scala 118:19]
  wire  buf__io_in_valid; // @[Uart.scala 118:19]
  wire [7:0] buf__io_in_bits; // @[Uart.scala 118:19]
  wire  buf__io_out_ready; // @[Uart.scala 118:19]
  wire  buf__io_out_valid; // @[Uart.scala 118:19]
  wire [7:0] buf__io_out_bits; // @[Uart.scala 118:19]
  Tx tx ( // @[Uart.scala 117:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Buffer buf_ ( // @[Uart.scala 118:19]
    .clock(buf__clock),
    .reset(buf__reset),
    .io_in_ready(buf__io_in_ready),
    .io_in_valid(buf__io_in_valid),
    .io_in_bits(buf__io_in_bits),
    .io_out_ready(buf__io_out_ready),
    .io_out_valid(buf__io_out_valid),
    .io_out_bits(buf__io_out_bits)
  );
  assign io_in_ready = buf__io_in_ready; // @[Uart.scala 120:13]
  assign io_txd = tx_io_txd; // @[Uart.scala 122:10]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf__io_out_valid; // @[Uart.scala 121:17]
  assign tx_io_channel_bits = buf__io_out_bits; // @[Uart.scala 121:17]
  assign buf__clock = clock;
  assign buf__reset = reset;
  assign buf__io_in_valid = io_in_valid; // @[Uart.scala 120:13]
  assign buf__io_in_bits = io_in_bits; // @[Uart.scala 120:13]
  assign buf__io_out_ready = tx_io_channel_ready; // @[Uart.scala 121:17]
endmodule
module Hello(
  input   clock,
  input   reset,
  output  io_led1,
  output  io_led2,
  output  io_txd
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT
  wire  tx_clock; // @[Hello.scala 13:18]
  wire  tx_reset; // @[Hello.scala 13:18]
  wire  tx_io_in_ready; // @[Hello.scala 13:18]
  wire  tx_io_in_valid; // @[Hello.scala 13:18]
  wire [7:0] tx_io_in_bits; // @[Hello.scala 13:18]
  wire  tx_io_txd; // @[Hello.scala 13:18]
  reg [31:0] cntReg; // @[Hello.scala 16:23]
  reg  blkReg1; // @[Hello.scala 17:24]
  reg  blkReg2; // @[Hello.scala 18:24]
  reg [7:0] txCntReg; // @[Hello.scala 24:25]
  reg [7:0] txLenReg; // @[Hello.scala 25:25]
  reg  startTxReg; // @[Hello.scala 26:27]
  reg  runningTxReg; // @[Hello.scala 27:29]
  wire [31:0] _cntReg_T_1 = cntReg + 32'h1; // @[Hello.scala 29:20]
  wire  _GEN_2 = cntReg == 32'hb71b00 ? blkReg1 : blkReg2; // @[Hello.scala 30:28 34:13 18:24]
  wire  _GEN_3 = cntReg == 32'hb71b00 | startTxReg; // @[Hello.scala 30:28 36:16 26:27]
  wire  _GEN_5 = startTxReg | runningTxReg; // @[Hello.scala 39:31 41:18 27:29]
  wire [6:0] _GEN_8 = txCntReg[0] ? 7'h4e : 7'h4f; // @[Hello.scala 46:{19,19}]
  wire [6:0] _GEN_10 = 2'h1 == txCntReg[1:0] ? 7'h46 : 7'h4f; // @[Hello.scala 49:{19,19}]
  wire [6:0] _GEN_11 = 2'h2 == txCntReg[1:0] ? 7'h46 : _GEN_10; // @[Hello.scala 49:{19,19}]
  wire [1:0] _GEN_12 = blkReg1 ? 2'h2 : 2'h3; // @[Hello.scala 44:25 45:14 48:14]
  wire [6:0] _GEN_13 = blkReg1 ? _GEN_8 : _GEN_11; // @[Hello.scala 44:25 46:19 49:19]
  wire  _T_3 = txCntReg != txLenReg; // @[Hello.scala 51:35]
  wire [7:0] _txCntReg_T_1 = txCntReg + 8'h1; // @[Hello.scala 52:26]
  wire  _GEN_16 = _T_3 & _GEN_5; // @[Hello.scala 55:33 58:20]
  BufferedTx tx ( // @[Hello.scala 13:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_in_ready(tx_io_in_ready),
    .io_in_valid(tx_io_in_valid),
    .io_in_bits(tx_io_in_bits),
    .io_txd(tx_io_txd)
  );
  assign io_led1 = blkReg1; // @[Hello.scala 65:11]
  assign io_led2 = blkReg2; // @[Hello.scala 66:11]
  assign io_txd = tx_io_txd; // @[Hello.scala 14:10]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_in_valid = runningTxReg & _T_3; // @[Hello.scala 54:33 62:20]
  assign tx_io_in_bits = {{1'd0}, _GEN_13};
  always @(posedge clock) begin
    if (reset) begin // @[Hello.scala 16:23]
      cntReg <= 32'h0; // @[Hello.scala 16:23]
    end else if (cntReg == 32'hb71b00) begin // @[Hello.scala 30:28]
      cntReg <= 32'h0; // @[Hello.scala 31:12]
    end else begin
      cntReg <= _cntReg_T_1; // @[Hello.scala 29:10]
    end
    if (reset) begin // @[Hello.scala 17:24]
      blkReg1 <= 1'h0; // @[Hello.scala 17:24]
    end else if (cntReg == 32'hb71b00) begin // @[Hello.scala 30:28]
      blkReg1 <= ~blkReg1; // @[Hello.scala 33:13]
    end
    blkReg2 <= reset | _GEN_2; // @[Hello.scala 18:{24,24}]
    if (reset) begin // @[Hello.scala 24:25]
      txCntReg <= 8'h0; // @[Hello.scala 24:25]
    end else if (tx_io_in_ready & txCntReg != txLenReg) begin // @[Hello.scala 51:49]
      txCntReg <= _txCntReg_T_1; // @[Hello.scala 52:14]
    end else if (startTxReg) begin // @[Hello.scala 39:31]
      txCntReg <= 8'h0; // @[Hello.scala 42:14]
    end
    if (reset) begin // @[Hello.scala 25:25]
      txLenReg <= 8'h0; // @[Hello.scala 25:25]
    end else begin
      txLenReg <= {{6'd0}, _GEN_12};
    end
    if (reset) begin // @[Hello.scala 26:27]
      startTxReg <= 1'h0; // @[Hello.scala 26:27]
    end else if (startTxReg) begin // @[Hello.scala 39:31]
      startTxReg <= 1'h0; // @[Hello.scala 40:16]
    end else begin
      startTxReg <= _GEN_3;
    end
    if (reset) begin // @[Hello.scala 27:29]
      runningTxReg <= 1'h0; // @[Hello.scala 27:29]
    end else if (runningTxReg) begin // @[Hello.scala 54:33]
      runningTxReg <= _GEN_16;
    end else begin
      runningTxReg <= _GEN_5;
    end
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
  _RAND_3 = {1{`RANDOM}};
  txCntReg = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  txLenReg = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  startTxReg = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  runningTxReg = _RAND_6[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
