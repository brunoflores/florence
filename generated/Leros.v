module Alu(
  input         clock,
  input         reset,
  input  [2:0]  io_op,
  input  [31:0] io_din,
  input         io_ena,
  output [31:0] io_accu
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] a; // @[Alu.scala 20:24]
  wire [31:0] _res_T_1 = a + io_din; // @[Alu.scala 32:16]
  wire [31:0] _res_T_3 = a - io_din; // @[Alu.scala 35:16]
  wire [31:0] _res_T_4 = a & io_din; // @[Alu.scala 38:16]
  wire [31:0] _res_T_5 = a | io_din; // @[Alu.scala 41:16]
  wire [31:0] _res_T_6 = a ^ io_din; // @[Alu.scala 44:16]
  wire [31:0] _GEN_0 = 3'h6 == io_op ? io_din : a; // @[Alu.scala 27:14 50:11]
  wire [31:0] _GEN_1 = 3'h7 == io_op ? {{1'd0}, a[31:1]} : _GEN_0; // @[Alu.scala 27:14 47:11]
  wire [31:0] _GEN_2 = 3'h5 == io_op ? _res_T_6 : _GEN_1; // @[Alu.scala 27:14 44:11]
  wire [31:0] _GEN_3 = 3'h4 == io_op ? _res_T_5 : _GEN_2; // @[Alu.scala 27:14 41:11]
  wire [31:0] _GEN_4 = 3'h3 == io_op ? _res_T_4 : _GEN_3; // @[Alu.scala 27:14 38:11]
  wire [31:0] _GEN_5 = 3'h2 == io_op ? _res_T_3 : _GEN_4; // @[Alu.scala 27:14 35:11]
  assign io_accu = a; // @[Alu.scala 58:11]
  always @(posedge clock) begin
    if (reset) begin // @[Alu.scala 20:24]
      a <= 32'h0; // @[Alu.scala 20:24]
    end else if (io_ena) begin // @[Alu.scala 54:16]
      if (!(3'h0 == io_op)) begin // @[Alu.scala 27:14]
        if (3'h1 == io_op) begin // @[Alu.scala 27:14]
          a <= _res_T_1; // @[Alu.scala 32:11]
        end else begin
          a <= _GEN_5;
        end
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
  a = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module InstrMem(
  input         clock,
  input         reset,
  input  [9:0]  io_addr,
  output [15:0] io_instr
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [9:0] memReg; // @[Leros.scala 29:23]
  wire [15:0] _GEN_1 = 3'h1 == memReg[2:0] ? 16'h903 : 16'h0; // @[Leros.scala 31:{12,12}]
  wire [15:0] _GEN_2 = 3'h2 == memReg[2:0] ? 16'hd02 : _GEN_1; // @[Leros.scala 31:{12,12}]
  wire [15:0] _GEN_3 = 3'h3 == memReg[2:0] ? 16'h21ab : _GEN_2; // @[Leros.scala 31:{12,12}]
  assign io_instr = 3'h4 == memReg[2:0] ? 16'h2400 : _GEN_3; // @[Leros.scala 31:{12,12}]
  always @(posedge clock) begin
    if (reset) begin // @[Leros.scala 29:23]
      memReg <= 10'h0; // @[Leros.scala 29:23]
    end else begin
      memReg <= io_addr; // @[Leros.scala 30:10]
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
  memReg = _RAND_0[9:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Decode(
  input  [7:0] io_din,
  output       io_dout_ena,
  output [2:0] io_dout_op,
  output       io_dout_isRegOpd,
  output       io_dout_isStore,
  output       io_dout_isStoreInd,
  output       io_dout_isLoadInd,
  output       io_dout_isLoadAddr,
  output       io_dout_enahi,
  output       io_dout_enah2i,
  output       io_dout_enah3i,
  output       io_dout_nosext,
  output       io_dout_exit
);
  wire [3:0] field = io_din[7:4]; // @[Decode.scala 65:21]
  wire  _T = field == 4'h8; // @[Decode.scala 66:14]
  wire  _GEN_1 = field == 4'h9 | _T; // @[Decode.scala 67:{29,40}]
  wire  _GEN_2 = field == 4'ha | _GEN_1; // @[Decode.scala 68:{30,41}]
  wire  _GEN_3 = field == 4'hb | _GEN_2; // @[Decode.scala 69:{29,40}]
  wire  isBranch = field == 4'hc | _GEN_3; // @[Decode.scala 70:{29,40}]
  wire [7:0] _instr_T = io_din & 8'hf0; // @[Decode.scala 72:36]
  wire [7:0] instr = isBranch ? _instr_T : io_din; // @[Decode.scala 72:18]
  wire  _GEN_7 = 8'h71 == instr ? 1'h0 : 8'hff == instr; // @[Decode.scala 40:12 73:17]
  wire  _GEN_8 = 8'h70 == instr | 8'h71 == instr; // @[Decode.scala 73:17 178:20]
  wire  _GEN_9 = 8'h70 == instr ? 1'h0 : _GEN_7; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_11 = 8'h61 == instr ? 3'h6 : 3'h0; // @[Decode.scala 174:12 29:10 73:17]
  wire  _GEN_12 = 8'h61 == instr ? 1'h0 : _GEN_8; // @[Decode.scala 73:17 32:18]
  wire  _GEN_13 = 8'h61 == instr ? 1'h0 : _GEN_9; // @[Decode.scala 40:12 73:17]
  wire  _GEN_14 = 8'h60 == instr | 8'h61 == instr; // @[Decode.scala 73:17 167:19]
  wire [2:0] _GEN_15 = 8'h60 == instr ? 3'h6 : _GEN_11; // @[Decode.scala 168:12 73:17]
  wire  _GEN_16 = 8'h60 == instr ? 1'h0 : _GEN_12; // @[Decode.scala 73:17 32:18]
  wire  _GEN_17 = 8'h60 == instr ? 1'h0 : _GEN_13; // @[Decode.scala 40:12 73:17]
  wire  _GEN_19 = 8'h50 == instr ? 1'h0 : _GEN_14; // @[Decode.scala 33:17 73:17]
  wire [2:0] _GEN_20 = 8'h50 == instr ? 3'h0 : _GEN_15; // @[Decode.scala 29:10 73:17]
  wire  _GEN_21 = 8'h50 == instr ? 1'h0 : _GEN_16; // @[Decode.scala 73:17 32:18]
  wire  _GEN_22 = 8'h50 == instr ? 1'h0 : _GEN_17; // @[Decode.scala 40:12 73:17]
  wire  _GEN_24 = 8'h30 == instr ? 1'h0 : 8'h50 == instr; // @[Decode.scala 73:17 34:18]
  wire  _GEN_25 = 8'h30 == instr ? 1'h0 : _GEN_19; // @[Decode.scala 33:17 73:17]
  wire [2:0] _GEN_26 = 8'h30 == instr ? 3'h0 : _GEN_20; // @[Decode.scala 29:10 73:17]
  wire  _GEN_27 = 8'h30 == instr ? 1'h0 : _GEN_21; // @[Decode.scala 73:17 32:18]
  wire  _GEN_28 = 8'h30 == instr ? 1'h0 : _GEN_22; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_29 = 8'h2b == instr ? 3'h6 : _GEN_26; // @[Decode.scala 155:12 73:17]
  wire  _GEN_31 = 8'h2b == instr | _GEN_25; // @[Decode.scala 157:13 73:17]
  wire  _GEN_32 = 8'h2b == instr ? 1'h0 : 8'h30 == instr; // @[Decode.scala 31:15 73:17]
  wire  _GEN_33 = 8'h2b == instr ? 1'h0 : _GEN_24; // @[Decode.scala 73:17 34:18]
  wire  _GEN_34 = 8'h2b == instr ? 1'h0 : _GEN_25; // @[Decode.scala 33:17 73:17]
  wire  _GEN_35 = 8'h2b == instr ? 1'h0 : _GEN_27; // @[Decode.scala 73:17 32:18]
  wire  _GEN_36 = 8'h2b == instr ? 1'h0 : _GEN_28; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_37 = 8'h2a == instr ? 3'h6 : _GEN_29; // @[Decode.scala 149:12 73:17]
  wire  _GEN_39 = 8'h2a == instr | _GEN_31; // @[Decode.scala 151:13 73:17]
  wire  _GEN_41 = 8'h2a == instr ? 1'h0 : 8'h2b == instr; // @[Decode.scala 38:14 73:17]
  wire  _GEN_42 = 8'h2a == instr ? 1'h0 : _GEN_32; // @[Decode.scala 31:15 73:17]
  wire  _GEN_43 = 8'h2a == instr ? 1'h0 : _GEN_33; // @[Decode.scala 73:17 34:18]
  wire  _GEN_44 = 8'h2a == instr ? 1'h0 : _GEN_34; // @[Decode.scala 33:17 73:17]
  wire  _GEN_45 = 8'h2a == instr ? 1'h0 : _GEN_35; // @[Decode.scala 73:17 32:18]
  wire  _GEN_46 = 8'h2a == instr ? 1'h0 : _GEN_36; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_47 = 8'h29 == instr ? 3'h6 : _GEN_37; // @[Decode.scala 142:12 73:17]
  wire  _GEN_48 = 8'h29 == instr | _GEN_39; // @[Decode.scala 143:13 73:17]
  wire  _GEN_51 = 8'h29 == instr ? 1'h0 : 8'h2a == instr; // @[Decode.scala 37:14 73:17]
  wire  _GEN_52 = 8'h29 == instr ? 1'h0 : _GEN_41; // @[Decode.scala 38:14 73:17]
  wire  _GEN_53 = 8'h29 == instr ? 1'h0 : _GEN_42; // @[Decode.scala 31:15 73:17]
  wire  _GEN_54 = 8'h29 == instr ? 1'h0 : _GEN_43; // @[Decode.scala 73:17 34:18]
  wire  _GEN_55 = 8'h29 == instr ? 1'h0 : _GEN_44; // @[Decode.scala 33:17 73:17]
  wire  _GEN_56 = 8'h29 == instr ? 1'h0 : _GEN_45; // @[Decode.scala 73:17 32:18]
  wire  _GEN_57 = 8'h29 == instr ? 1'h0 : _GEN_46; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_58 = 8'h27 == instr ? 3'h5 : _GEN_47; // @[Decode.scala 136:12 73:17]
  wire  _GEN_59 = 8'h27 == instr | _GEN_48; // @[Decode.scala 137:13 73:17]
  wire  _GEN_62 = 8'h27 == instr ? 1'h0 : 8'h29 == instr; // @[Decode.scala 36:13 73:17]
  wire  _GEN_63 = 8'h27 == instr ? 1'h0 : _GEN_51; // @[Decode.scala 37:14 73:17]
  wire  _GEN_64 = 8'h27 == instr ? 1'h0 : _GEN_52; // @[Decode.scala 38:14 73:17]
  wire  _GEN_65 = 8'h27 == instr ? 1'h0 : _GEN_53; // @[Decode.scala 31:15 73:17]
  wire  _GEN_66 = 8'h27 == instr ? 1'h0 : _GEN_54; // @[Decode.scala 73:17 34:18]
  wire  _GEN_67 = 8'h27 == instr ? 1'h0 : _GEN_55; // @[Decode.scala 33:17 73:17]
  wire  _GEN_68 = 8'h27 == instr ? 1'h0 : _GEN_56; // @[Decode.scala 73:17 32:18]
  wire  _GEN_69 = 8'h27 == instr ? 1'h0 : _GEN_57; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_70 = 8'h26 == instr ? 3'h5 : _GEN_58; // @[Decode.scala 131:12 73:17]
  wire  _GEN_71 = 8'h26 == instr | _GEN_59; // @[Decode.scala 132:13 73:17]
  wire  _GEN_74 = 8'h26 == instr ? 1'h0 : 8'h27 == instr; // @[Decode.scala 39:14 73:17]
  wire  _GEN_75 = 8'h26 == instr ? 1'h0 : _GEN_62; // @[Decode.scala 36:13 73:17]
  wire  _GEN_76 = 8'h26 == instr ? 1'h0 : _GEN_63; // @[Decode.scala 37:14 73:17]
  wire  _GEN_77 = 8'h26 == instr ? 1'h0 : _GEN_64; // @[Decode.scala 38:14 73:17]
  wire  _GEN_78 = 8'h26 == instr ? 1'h0 : _GEN_65; // @[Decode.scala 31:15 73:17]
  wire  _GEN_79 = 8'h26 == instr ? 1'h0 : _GEN_66; // @[Decode.scala 73:17 34:18]
  wire  _GEN_80 = 8'h26 == instr ? 1'h0 : _GEN_67; // @[Decode.scala 33:17 73:17]
  wire  _GEN_81 = 8'h26 == instr ? 1'h0 : _GEN_68; // @[Decode.scala 73:17 32:18]
  wire  _GEN_82 = 8'h26 == instr ? 1'h0 : _GEN_69; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_83 = 8'h25 == instr ? 3'h4 : _GEN_70; // @[Decode.scala 125:12 73:17]
  wire  _GEN_84 = 8'h25 == instr | _GEN_71; // @[Decode.scala 126:13 73:17]
  wire  _GEN_86 = 8'h25 == instr | _GEN_74; // @[Decode.scala 128:16 73:17]
  wire  _GEN_87 = 8'h25 == instr ? 1'h0 : 8'h26 == instr; // @[Decode.scala 30:16 73:17]
  wire  _GEN_88 = 8'h25 == instr ? 1'h0 : _GEN_75; // @[Decode.scala 36:13 73:17]
  wire  _GEN_89 = 8'h25 == instr ? 1'h0 : _GEN_76; // @[Decode.scala 37:14 73:17]
  wire  _GEN_90 = 8'h25 == instr ? 1'h0 : _GEN_77; // @[Decode.scala 38:14 73:17]
  wire  _GEN_91 = 8'h25 == instr ? 1'h0 : _GEN_78; // @[Decode.scala 31:15 73:17]
  wire  _GEN_92 = 8'h25 == instr ? 1'h0 : _GEN_79; // @[Decode.scala 73:17 34:18]
  wire  _GEN_93 = 8'h25 == instr ? 1'h0 : _GEN_80; // @[Decode.scala 33:17 73:17]
  wire  _GEN_94 = 8'h25 == instr ? 1'h0 : _GEN_81; // @[Decode.scala 73:17 32:18]
  wire  _GEN_95 = 8'h25 == instr ? 1'h0 : _GEN_82; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_96 = 8'h24 == instr ? 3'h4 : _GEN_83; // @[Decode.scala 120:12 73:17]
  wire  _GEN_97 = 8'h24 == instr | _GEN_84; // @[Decode.scala 121:13 73:17]
  wire  _GEN_98 = 8'h24 == instr | _GEN_87; // @[Decode.scala 73:17 122:18]
  wire  _GEN_100 = 8'h24 == instr ? 1'h0 : _GEN_86; // @[Decode.scala 39:14 73:17]
  wire  _GEN_101 = 8'h24 == instr ? 1'h0 : _GEN_88; // @[Decode.scala 36:13 73:17]
  wire  _GEN_102 = 8'h24 == instr ? 1'h0 : _GEN_89; // @[Decode.scala 37:14 73:17]
  wire  _GEN_103 = 8'h24 == instr ? 1'h0 : _GEN_90; // @[Decode.scala 38:14 73:17]
  wire  _GEN_104 = 8'h24 == instr ? 1'h0 : _GEN_91; // @[Decode.scala 31:15 73:17]
  wire  _GEN_105 = 8'h24 == instr ? 1'h0 : _GEN_92; // @[Decode.scala 73:17 34:18]
  wire  _GEN_106 = 8'h24 == instr ? 1'h0 : _GEN_93; // @[Decode.scala 33:17 73:17]
  wire  _GEN_107 = 8'h24 == instr ? 1'h0 : _GEN_94; // @[Decode.scala 73:17 32:18]
  wire  _GEN_108 = 8'h24 == instr ? 1'h0 : _GEN_95; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_109 = 8'h23 == instr ? 3'h3 : _GEN_96; // @[Decode.scala 114:12 73:17]
  wire  _GEN_110 = 8'h23 == instr | _GEN_97; // @[Decode.scala 115:13 73:17]
  wire  _GEN_112 = 8'h23 == instr | _GEN_100; // @[Decode.scala 117:16 73:17]
  wire  _GEN_113 = 8'h23 == instr ? 1'h0 : _GEN_98; // @[Decode.scala 30:16 73:17]
  wire  _GEN_114 = 8'h23 == instr ? 1'h0 : _GEN_101; // @[Decode.scala 36:13 73:17]
  wire  _GEN_115 = 8'h23 == instr ? 1'h0 : _GEN_102; // @[Decode.scala 37:14 73:17]
  wire  _GEN_116 = 8'h23 == instr ? 1'h0 : _GEN_103; // @[Decode.scala 38:14 73:17]
  wire  _GEN_117 = 8'h23 == instr ? 1'h0 : _GEN_104; // @[Decode.scala 31:15 73:17]
  wire  _GEN_118 = 8'h23 == instr ? 1'h0 : _GEN_105; // @[Decode.scala 73:17 34:18]
  wire  _GEN_119 = 8'h23 == instr ? 1'h0 : _GEN_106; // @[Decode.scala 33:17 73:17]
  wire  _GEN_120 = 8'h23 == instr ? 1'h0 : _GEN_107; // @[Decode.scala 73:17 32:18]
  wire  _GEN_121 = 8'h23 == instr ? 1'h0 : _GEN_108; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_122 = 8'h22 == instr ? 3'h3 : _GEN_109; // @[Decode.scala 109:12 73:17]
  wire  _GEN_123 = 8'h22 == instr | _GEN_110; // @[Decode.scala 110:13 73:17]
  wire  _GEN_124 = 8'h22 == instr | _GEN_113; // @[Decode.scala 73:17 111:18]
  wire  _GEN_126 = 8'h22 == instr ? 1'h0 : _GEN_112; // @[Decode.scala 39:14 73:17]
  wire  _GEN_127 = 8'h22 == instr ? 1'h0 : _GEN_114; // @[Decode.scala 36:13 73:17]
  wire  _GEN_128 = 8'h22 == instr ? 1'h0 : _GEN_115; // @[Decode.scala 37:14 73:17]
  wire  _GEN_129 = 8'h22 == instr ? 1'h0 : _GEN_116; // @[Decode.scala 38:14 73:17]
  wire  _GEN_130 = 8'h22 == instr ? 1'h0 : _GEN_117; // @[Decode.scala 31:15 73:17]
  wire  _GEN_131 = 8'h22 == instr ? 1'h0 : _GEN_118; // @[Decode.scala 73:17 34:18]
  wire  _GEN_132 = 8'h22 == instr ? 1'h0 : _GEN_119; // @[Decode.scala 33:17 73:17]
  wire  _GEN_133 = 8'h22 == instr ? 1'h0 : _GEN_120; // @[Decode.scala 73:17 32:18]
  wire  _GEN_134 = 8'h22 == instr ? 1'h0 : _GEN_121; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_135 = 8'h21 == instr ? 3'h6 : _GEN_122; // @[Decode.scala 104:12 73:17]
  wire  _GEN_136 = 8'h21 == instr | _GEN_123; // @[Decode.scala 105:13 73:17]
  wire  _GEN_138 = 8'h21 == instr ? 1'h0 : _GEN_124; // @[Decode.scala 30:16 73:17]
  wire  _GEN_139 = 8'h21 == instr ? 1'h0 : _GEN_126; // @[Decode.scala 39:14 73:17]
  wire  _GEN_140 = 8'h21 == instr ? 1'h0 : _GEN_127; // @[Decode.scala 36:13 73:17]
  wire  _GEN_141 = 8'h21 == instr ? 1'h0 : _GEN_128; // @[Decode.scala 37:14 73:17]
  wire  _GEN_142 = 8'h21 == instr ? 1'h0 : _GEN_129; // @[Decode.scala 38:14 73:17]
  wire  _GEN_143 = 8'h21 == instr ? 1'h0 : _GEN_130; // @[Decode.scala 31:15 73:17]
  wire  _GEN_144 = 8'h21 == instr ? 1'h0 : _GEN_131; // @[Decode.scala 73:17 34:18]
  wire  _GEN_145 = 8'h21 == instr ? 1'h0 : _GEN_132; // @[Decode.scala 33:17 73:17]
  wire  _GEN_146 = 8'h21 == instr ? 1'h0 : _GEN_133; // @[Decode.scala 73:17 32:18]
  wire  _GEN_147 = 8'h21 == instr ? 1'h0 : _GEN_134; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_148 = 8'h20 == instr ? 3'h6 : _GEN_135; // @[Decode.scala 73:17 99:12]
  wire  _GEN_149 = 8'h20 == instr | _GEN_136; // @[Decode.scala 100:13 73:17]
  wire  _GEN_150 = 8'h20 == instr | _GEN_138; // @[Decode.scala 73:17 101:18]
  wire  _GEN_152 = 8'h20 == instr ? 1'h0 : _GEN_139; // @[Decode.scala 39:14 73:17]
  wire  _GEN_153 = 8'h20 == instr ? 1'h0 : _GEN_140; // @[Decode.scala 36:13 73:17]
  wire  _GEN_154 = 8'h20 == instr ? 1'h0 : _GEN_141; // @[Decode.scala 37:14 73:17]
  wire  _GEN_155 = 8'h20 == instr ? 1'h0 : _GEN_142; // @[Decode.scala 38:14 73:17]
  wire  _GEN_156 = 8'h20 == instr ? 1'h0 : _GEN_143; // @[Decode.scala 31:15 73:17]
  wire  _GEN_157 = 8'h20 == instr ? 1'h0 : _GEN_144; // @[Decode.scala 73:17 34:18]
  wire  _GEN_158 = 8'h20 == instr ? 1'h0 : _GEN_145; // @[Decode.scala 33:17 73:17]
  wire  _GEN_159 = 8'h20 == instr ? 1'h0 : _GEN_146; // @[Decode.scala 73:17 32:18]
  wire  _GEN_160 = 8'h20 == instr ? 1'h0 : _GEN_147; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_161 = 8'h10 == instr ? 3'h7 : _GEN_148; // @[Decode.scala 73:17 95:12]
  wire  _GEN_162 = 8'h10 == instr | _GEN_149; // @[Decode.scala 73:17 96:13]
  wire  _GEN_163 = 8'h10 == instr ? 1'h0 : _GEN_150; // @[Decode.scala 30:16 73:17]
  wire  _GEN_165 = 8'h10 == instr ? 1'h0 : _GEN_152; // @[Decode.scala 39:14 73:17]
  wire  _GEN_166 = 8'h10 == instr ? 1'h0 : _GEN_153; // @[Decode.scala 36:13 73:17]
  wire  _GEN_167 = 8'h10 == instr ? 1'h0 : _GEN_154; // @[Decode.scala 37:14 73:17]
  wire  _GEN_168 = 8'h10 == instr ? 1'h0 : _GEN_155; // @[Decode.scala 38:14 73:17]
  wire  _GEN_169 = 8'h10 == instr ? 1'h0 : _GEN_156; // @[Decode.scala 31:15 73:17]
  wire  _GEN_170 = 8'h10 == instr ? 1'h0 : _GEN_157; // @[Decode.scala 73:17 34:18]
  wire  _GEN_171 = 8'h10 == instr ? 1'h0 : _GEN_158; // @[Decode.scala 33:17 73:17]
  wire  _GEN_172 = 8'h10 == instr ? 1'h0 : _GEN_159; // @[Decode.scala 73:17 32:18]
  wire  _GEN_173 = 8'h10 == instr ? 1'h0 : _GEN_160; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_174 = 8'hd == instr ? 3'h2 : _GEN_161; // @[Decode.scala 73:17 90:12]
  wire  _GEN_175 = 8'hd == instr | _GEN_162; // @[Decode.scala 73:17 91:13]
  wire  _GEN_176 = 8'hd == instr | _GEN_163; // @[Decode.scala 73:17 92:18]
  wire  _GEN_178 = 8'hd == instr ? 1'h0 : _GEN_165; // @[Decode.scala 39:14 73:17]
  wire  _GEN_179 = 8'hd == instr ? 1'h0 : _GEN_166; // @[Decode.scala 36:13 73:17]
  wire  _GEN_180 = 8'hd == instr ? 1'h0 : _GEN_167; // @[Decode.scala 37:14 73:17]
  wire  _GEN_181 = 8'hd == instr ? 1'h0 : _GEN_168; // @[Decode.scala 38:14 73:17]
  wire  _GEN_182 = 8'hd == instr ? 1'h0 : _GEN_169; // @[Decode.scala 31:15 73:17]
  wire  _GEN_183 = 8'hd == instr ? 1'h0 : _GEN_170; // @[Decode.scala 73:17 34:18]
  wire  _GEN_184 = 8'hd == instr ? 1'h0 : _GEN_171; // @[Decode.scala 33:17 73:17]
  wire  _GEN_185 = 8'hd == instr ? 1'h0 : _GEN_172; // @[Decode.scala 73:17 32:18]
  wire  _GEN_186 = 8'hd == instr ? 1'h0 : _GEN_173; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_187 = 8'hc == instr ? 3'h2 : _GEN_174; // @[Decode.scala 73:17 85:12]
  wire  _GEN_188 = 8'hc == instr | _GEN_175; // @[Decode.scala 73:17 86:13]
  wire  _GEN_189 = 8'hc == instr | _GEN_176; // @[Decode.scala 73:17 87:18]
  wire  _GEN_191 = 8'hc == instr ? 1'h0 : _GEN_178; // @[Decode.scala 39:14 73:17]
  wire  _GEN_192 = 8'hc == instr ? 1'h0 : _GEN_179; // @[Decode.scala 36:13 73:17]
  wire  _GEN_193 = 8'hc == instr ? 1'h0 : _GEN_180; // @[Decode.scala 37:14 73:17]
  wire  _GEN_194 = 8'hc == instr ? 1'h0 : _GEN_181; // @[Decode.scala 38:14 73:17]
  wire  _GEN_195 = 8'hc == instr ? 1'h0 : _GEN_182; // @[Decode.scala 31:15 73:17]
  wire  _GEN_196 = 8'hc == instr ? 1'h0 : _GEN_183; // @[Decode.scala 73:17 34:18]
  wire  _GEN_197 = 8'hc == instr ? 1'h0 : _GEN_184; // @[Decode.scala 33:17 73:17]
  wire  _GEN_198 = 8'hc == instr ? 1'h0 : _GEN_185; // @[Decode.scala 73:17 32:18]
  wire  _GEN_199 = 8'hc == instr ? 1'h0 : _GEN_186; // @[Decode.scala 40:12 73:17]
  wire [2:0] _GEN_200 = 8'h9 == instr ? 3'h1 : _GEN_187; // @[Decode.scala 73:17 80:12]
  wire  _GEN_201 = 8'h9 == instr | _GEN_188; // @[Decode.scala 73:17 81:13]
  wire  _GEN_202 = 8'h9 == instr | _GEN_189; // @[Decode.scala 73:17 82:18]
  wire  _GEN_204 = 8'h9 == instr ? 1'h0 : _GEN_191; // @[Decode.scala 39:14 73:17]
  wire  _GEN_205 = 8'h9 == instr ? 1'h0 : _GEN_192; // @[Decode.scala 36:13 73:17]
  wire  _GEN_206 = 8'h9 == instr ? 1'h0 : _GEN_193; // @[Decode.scala 37:14 73:17]
  wire  _GEN_207 = 8'h9 == instr ? 1'h0 : _GEN_194; // @[Decode.scala 38:14 73:17]
  wire  _GEN_208 = 8'h9 == instr ? 1'h0 : _GEN_195; // @[Decode.scala 31:15 73:17]
  wire  _GEN_209 = 8'h9 == instr ? 1'h0 : _GEN_196; // @[Decode.scala 73:17 34:18]
  wire  _GEN_210 = 8'h9 == instr ? 1'h0 : _GEN_197; // @[Decode.scala 33:17 73:17]
  wire  _GEN_211 = 8'h9 == instr ? 1'h0 : _GEN_198; // @[Decode.scala 73:17 32:18]
  wire  _GEN_212 = 8'h9 == instr ? 1'h0 : _GEN_199; // @[Decode.scala 40:12 73:17]
  assign io_dout_ena = 8'h8 == instr | _GEN_201; // @[Decode.scala 73:17 76:13]
  assign io_dout_op = 8'h8 == instr ? 3'h1 : _GEN_200; // @[Decode.scala 73:17 75:12]
  assign io_dout_isRegOpd = 8'h8 == instr | _GEN_202; // @[Decode.scala 73:17 77:18]
  assign io_dout_isStore = 8'h8 == instr ? 1'h0 : _GEN_208; // @[Decode.scala 31:15 73:17]
  assign io_dout_isStoreInd = 8'h8 == instr ? 1'h0 : _GEN_211; // @[Decode.scala 73:17 32:18]
  assign io_dout_isLoadInd = 8'h8 == instr ? 1'h0 : _GEN_210; // @[Decode.scala 33:17 73:17]
  assign io_dout_isLoadAddr = 8'h8 == instr ? 1'h0 : _GEN_209; // @[Decode.scala 73:17 34:18]
  assign io_dout_enahi = 8'h8 == instr ? 1'h0 : _GEN_205; // @[Decode.scala 36:13 73:17]
  assign io_dout_enah2i = 8'h8 == instr ? 1'h0 : _GEN_206; // @[Decode.scala 37:14 73:17]
  assign io_dout_enah3i = 8'h8 == instr ? 1'h0 : _GEN_207; // @[Decode.scala 38:14 73:17]
  assign io_dout_nosext = 8'h8 == instr ? 1'h0 : _GEN_204; // @[Decode.scala 39:14 73:17]
  assign io_dout_exit = 8'h8 == instr ? 1'h0 : _GEN_212; // @[Decode.scala 40:12 73:17]
endmodule
module Leros(
  input         clock,
  input         reset,
  output [31:0] io_dout,
  output [31:0] io_dbg_acc,
  output [9:0]  io_dbg_pc,
  output [15:0] io_dbg_instr,
  output        io_dbg_exit
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
`endif // RANDOMIZE_REG_INIT
  wire  alu_clock; // @[Leros.scala 52:19]
  wire  alu_reset; // @[Leros.scala 52:19]
  wire [2:0] alu_io_op; // @[Leros.scala 52:19]
  wire [31:0] alu_io_din; // @[Leros.scala 52:19]
  wire  alu_io_ena; // @[Leros.scala 52:19]
  wire [31:0] alu_io_accu; // @[Leros.scala 52:19]
  wire  mem_clock; // @[Leros.scala 70:19]
  wire  mem_reset; // @[Leros.scala 70:19]
  wire [9:0] mem_io_addr; // @[Leros.scala 70:19]
  wire [15:0] mem_io_instr; // @[Leros.scala 70:19]
  reg [31:0] registerMem [0:255]; // @[Leros.scala 77:32]
  wire  registerMem_registerRead_en; // @[Leros.scala 77:32]
  wire [7:0] registerMem_registerRead_addr; // @[Leros.scala 77:32]
  wire [31:0] registerMem_registerRead_data; // @[Leros.scala 77:32]
  wire [31:0] registerMem_MPORT_data; // @[Leros.scala 77:32]
  wire [7:0] registerMem_MPORT_addr; // @[Leros.scala 77:32]
  wire  registerMem_MPORT_mask; // @[Leros.scala 77:32]
  wire  registerMem_MPORT_en; // @[Leros.scala 77:32]
  reg  registerMem_registerRead_en_pipe_0;
  reg [7:0] registerMem_registerRead_addr_pipe_0;
  reg [31:0] dataMem [0:1023]; // @[Leros.scala 82:28]
  wire  dataMem_dataRead_en; // @[Leros.scala 82:28]
  wire [9:0] dataMem_dataRead_addr; // @[Leros.scala 82:28]
  wire [31:0] dataMem_dataRead_data; // @[Leros.scala 82:28]
  wire [31:0] dataMem_MPORT_1_data; // @[Leros.scala 82:28]
  wire [9:0] dataMem_MPORT_1_addr; // @[Leros.scala 82:28]
  wire  dataMem_MPORT_1_mask; // @[Leros.scala 82:28]
  wire  dataMem_MPORT_1_en; // @[Leros.scala 82:28]
  reg  dataMem_dataRead_en_pipe_0;
  reg [9:0] dataMem_dataRead_addr_pipe_0;
  wire [7:0] dec_io_din; // @[Leros.scala 87:19]
  wire  dec_io_dout_ena; // @[Leros.scala 87:19]
  wire [2:0] dec_io_dout_op; // @[Leros.scala 87:19]
  wire  dec_io_dout_isRegOpd; // @[Leros.scala 87:19]
  wire  dec_io_dout_isStore; // @[Leros.scala 87:19]
  wire  dec_io_dout_isStoreInd; // @[Leros.scala 87:19]
  wire  dec_io_dout_isLoadInd; // @[Leros.scala 87:19]
  wire  dec_io_dout_isLoadAddr; // @[Leros.scala 87:19]
  wire  dec_io_dout_enahi; // @[Leros.scala 87:19]
  wire  dec_io_dout_enah2i; // @[Leros.scala 87:19]
  wire  dec_io_dout_enah3i; // @[Leros.scala 87:19]
  wire  dec_io_dout_nosext; // @[Leros.scala 87:19]
  wire  dec_io_dout_exit; // @[Leros.scala 87:19]
  reg [9:0] pcReg; // @[Leros.scala 57:22]
  reg [9:0] addrReg; // @[Leros.scala 58:24]
  reg  stateReg; // @[Leros.scala 60:25]
  wire  _T_2 = ~stateReg; // @[Leros.scala 62:20]
  wire  _GEN_0 = stateReg ? 1'h0 : stateReg; // @[Leros.scala 62:20 64:24 60:25]
  wire  _GEN_1 = ~stateReg | _GEN_0; // @[Leros.scala 62:20 63:26]
  wire [9:0] pcNext = pcReg + 10'h1; // @[Leros.scala 67:34]
  reg  decReg_ena; // @[Leros.scala 74:23]
  reg [2:0] decReg_op; // @[Leros.scala 74:23]
  reg  decReg_isRegOpd; // @[Leros.scala 74:23]
  reg  decReg_isStore; // @[Leros.scala 74:23]
  reg  decReg_isStoreInd; // @[Leros.scala 74:23]
  reg  decReg_isLoadInd; // @[Leros.scala 74:23]
  reg  decReg_isLoadAddr; // @[Leros.scala 74:23]
  reg  decReg_exit; // @[Leros.scala 74:23]
  reg [31:0] opdReg; // @[Leros.scala 75:23]
  wire [15:0] _registerRead_T = mem_io_instr; // @[Leros.scala 78:44]
  wire [31:0] _dataRead_T_2 = decReg_isLoadAddr & stateReg ? alu_io_accu : {{22'd0}, addrReg}; // @[Leros.scala 84:21]
  wire [7:0] _op16sex_T_1 = mem_io_instr[7:0]; // @[Leros.scala 95:26]
  wire [31:0] _operand_T_2 = {24'h0,mem_io_instr[7:0]}; // @[Leros.scala 99:43]
  wire [23:0] _operand_T_3 = {{16{_op16sex_T_1[7]}},_op16sex_T_1}; // @[Leros.scala 101:25]
  wire [31:0] _operand_T_6 = {_operand_T_3,alu_io_accu[7:0]}; // @[Leros.scala 101:47]
  wire [15:0] _operand_T_7 = {{8{_op16sex_T_1[7]}},_op16sex_T_1}; // @[Leros.scala 103:25]
  wire [31:0] _operand_T_10 = {_operand_T_7,alu_io_accu[15:0]}; // @[Leros.scala 103:48]
  wire [31:0] _operand_T_14 = {mem_io_instr[7:0],alu_io_accu[23:0]}; // @[Leros.scala 105:45]
  wire [31:0] _GEN_8 = dec_io_dout_enah3i ? $signed(_operand_T_14) : $signed({{24{_op16sex_T_1[7]}},_op16sex_T_1}); // @[Leros.scala 104:29 105:13 107:13]
  wire [31:0] _GEN_9 = dec_io_dout_enah2i ? $signed(_operand_T_10) : $signed(_GEN_8); // @[Leros.scala 102:29 103:13]
  wire [31:0] _GEN_10 = dec_io_dout_enahi ? $signed(_operand_T_6) : $signed(_GEN_9); // @[Leros.scala 100:28 101:13]
  wire [31:0] _alu_io_din_T = decReg_isRegOpd ? registerMem_registerRead_data : opdReg; // @[Leros.scala 118:8]
  wire [31:0] _opdReg_T = dec_io_dout_nosext ? $signed(_operand_T_2) : $signed(_GEN_10); // @[Leros.scala 124:25]
  wire [31:0] _GEN_17 = decReg_isLoadAddr ? alu_io_accu : {{22'd0}, addrReg}; // @[Leros.scala 132:31 133:17 58:24]
  wire  _GEN_26 = stateReg & decReg_isStore; // @[Leros.scala 121:20 77:32]
  wire [31:0] _GEN_29 = stateReg ? _GEN_17 : {{22'd0}, addrReg}; // @[Leros.scala 121:20 58:24]
  wire  _GEN_32 = stateReg & decReg_isStoreInd; // @[Leros.scala 121:20 82:28]
  wire [31:0] _GEN_55 = _T_2 ? {{22'd0}, addrReg} : _GEN_29; // @[Leros.scala 121:20 58:24]
  reg  exit; // @[Leros.scala 147:21]
  reg  exit_REG; // @[Leros.scala 148:18]
  reg [31:0] io_dbg_acc_REG; // @[Leros.scala 153:34]
  reg [31:0] io_dbg_acc_REG_1; // @[Leros.scala 153:26]
  reg [9:0] io_dbg_pc_REG; // @[Leros.scala 154:33]
  reg [9:0] io_dbg_pc_REG_1; // @[Leros.scala 154:25]
  reg [15:0] io_dbg_instr_REG; // @[Leros.scala 155:36]
  reg [15:0] io_dbg_instr_REG_1; // @[Leros.scala 155:28]
  reg  io_dbg_exit_REG; // @[Leros.scala 156:35]
  reg  io_dbg_exit_REG_1; // @[Leros.scala 156:27]
  wire [31:0] _GEN_61 = reset ? 32'h0 : _GEN_55; // @[Leros.scala 58:{24,24}]
  Alu alu ( // @[Leros.scala 52:19]
    .clock(alu_clock),
    .reset(alu_reset),
    .io_op(alu_io_op),
    .io_din(alu_io_din),
    .io_ena(alu_io_ena),
    .io_accu(alu_io_accu)
  );
  InstrMem mem ( // @[Leros.scala 70:19]
    .clock(mem_clock),
    .reset(mem_reset),
    .io_addr(mem_io_addr),
    .io_instr(mem_io_instr)
  );
  Decode dec ( // @[Leros.scala 87:19]
    .io_din(dec_io_din),
    .io_dout_ena(dec_io_dout_ena),
    .io_dout_op(dec_io_dout_op),
    .io_dout_isRegOpd(dec_io_dout_isRegOpd),
    .io_dout_isStore(dec_io_dout_isStore),
    .io_dout_isStoreInd(dec_io_dout_isStoreInd),
    .io_dout_isLoadInd(dec_io_dout_isLoadInd),
    .io_dout_isLoadAddr(dec_io_dout_isLoadAddr),
    .io_dout_enahi(dec_io_dout_enahi),
    .io_dout_enah2i(dec_io_dout_enah2i),
    .io_dout_enah3i(dec_io_dout_enah3i),
    .io_dout_nosext(dec_io_dout_nosext),
    .io_dout_exit(dec_io_dout_exit)
  );
  assign registerMem_registerRead_en = registerMem_registerRead_en_pipe_0;
  assign registerMem_registerRead_addr = registerMem_registerRead_addr_pipe_0;
  assign registerMem_registerRead_data = registerMem[registerMem_registerRead_addr]; // @[Leros.scala 77:32]
  assign registerMem_MPORT_data = alu_io_accu;
  assign registerMem_MPORT_addr = opdReg[7:0];
  assign registerMem_MPORT_mask = 1'h1;
  assign registerMem_MPORT_en = _T_2 ? 1'h0 : _GEN_26;
  assign dataMem_dataRead_en = dataMem_dataRead_en_pipe_0;
  assign dataMem_dataRead_addr = dataMem_dataRead_addr_pipe_0;
  assign dataMem_dataRead_data = dataMem[dataMem_dataRead_addr]; // @[Leros.scala 82:28]
  assign dataMem_MPORT_1_data = alu_io_accu;
  assign dataMem_MPORT_1_addr = addrReg;
  assign dataMem_MPORT_1_mask = 1'h1;
  assign dataMem_MPORT_1_en = _T_2 ? 1'h0 : _GEN_32;
  assign io_dout = 32'h2a; // @[Leros.scala 150:11]
  assign io_dbg_acc = io_dbg_acc_REG_1; // @[Leros.scala 153:16]
  assign io_dbg_pc = io_dbg_pc_REG_1; // @[Leros.scala 154:15]
  assign io_dbg_instr = io_dbg_instr_REG_1; // @[Leros.scala 155:18]
  assign io_dbg_exit = io_dbg_exit_REG_1; // @[Leros.scala 156:17]
  assign alu_clock = clock;
  assign alu_reset = reset;
  assign alu_io_op = decReg_op; // @[Leros.scala 113:13]
  assign alu_io_din = decReg_isLoadInd ? dataMem_dataRead_data : _alu_io_din_T; // @[Leros.scala 115:20]
  assign alu_io_ena = decReg_ena & stateReg; // @[Leros.scala 114:28]
  assign mem_clock = clock;
  assign mem_reset = reset;
  assign mem_io_addr = pcReg + 10'h1; // @[Leros.scala 67:34]
  assign dec_io_din = mem_io_instr[15:8]; // @[Leros.scala 88:22]
  always @(posedge clock) begin
    if (registerMem_MPORT_en & registerMem_MPORT_mask) begin
      registerMem[registerMem_MPORT_addr] <= registerMem_MPORT_data; // @[Leros.scala 77:32]
    end
    registerMem_registerRead_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      registerMem_registerRead_addr_pipe_0 <= _registerRead_T[7:0];
    end
    if (dataMem_MPORT_1_en & dataMem_MPORT_1_mask) begin
      dataMem[dataMem_MPORT_1_addr] <= dataMem_MPORT_1_data; // @[Leros.scala 82:28]
    end
    dataMem_dataRead_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      dataMem_dataRead_addr_pipe_0 <= _dataRead_T_2[9:0];
    end
    if (reset) begin // @[Leros.scala 57:22]
      pcReg <= 10'h0; // @[Leros.scala 57:22]
    end else if (!(_T_2)) begin // @[Leros.scala 121:20]
      if (stateReg) begin // @[Leros.scala 121:20]
        pcReg <= pcNext; // @[Leros.scala 128:13]
      end
    end
    addrReg <= _GEN_61[9:0]; // @[Leros.scala 58:{24,24}]
    if (reset) begin // @[Leros.scala 60:25]
      stateReg <= 1'h0; // @[Leros.scala 60:25]
    end else begin
      stateReg <= _GEN_1;
    end
    if (reset) begin // @[Leros.scala 74:23]
      decReg_ena <= 1'h0; // @[Leros.scala 74:23]
    end else if (_T_2) begin // @[Leros.scala 121:20]
      decReg_ena <= dec_io_dout_ena; // @[Leros.scala 123:14]
    end
    if (reset) begin // @[Leros.scala 74:23]
      decReg_op <= 3'h0; // @[Leros.scala 74:23]
    end else if (_T_2) begin // @[Leros.scala 121:20]
      decReg_op <= dec_io_dout_op; // @[Leros.scala 123:14]
    end
    if (reset) begin // @[Leros.scala 74:23]
      decReg_isRegOpd <= 1'h0; // @[Leros.scala 74:23]
    end else if (_T_2) begin // @[Leros.scala 121:20]
      decReg_isRegOpd <= dec_io_dout_isRegOpd; // @[Leros.scala 123:14]
    end
    if (reset) begin // @[Leros.scala 74:23]
      decReg_isStore <= 1'h0; // @[Leros.scala 74:23]
    end else if (_T_2) begin // @[Leros.scala 121:20]
      decReg_isStore <= dec_io_dout_isStore; // @[Leros.scala 123:14]
    end
    if (reset) begin // @[Leros.scala 74:23]
      decReg_isStoreInd <= 1'h0; // @[Leros.scala 74:23]
    end else if (_T_2) begin // @[Leros.scala 121:20]
      decReg_isStoreInd <= dec_io_dout_isStoreInd; // @[Leros.scala 123:14]
    end
    if (reset) begin // @[Leros.scala 74:23]
      decReg_isLoadInd <= 1'h0; // @[Leros.scala 74:23]
    end else if (_T_2) begin // @[Leros.scala 121:20]
      decReg_isLoadInd <= dec_io_dout_isLoadInd; // @[Leros.scala 123:14]
    end
    if (reset) begin // @[Leros.scala 74:23]
      decReg_isLoadAddr <= 1'h0; // @[Leros.scala 74:23]
    end else if (_T_2) begin // @[Leros.scala 121:20]
      decReg_isLoadAddr <= dec_io_dout_isLoadAddr; // @[Leros.scala 123:14]
    end
    if (reset) begin // @[Leros.scala 74:23]
      decReg_exit <= 1'h0; // @[Leros.scala 74:23]
    end else if (_T_2) begin // @[Leros.scala 121:20]
      decReg_exit <= dec_io_dout_exit; // @[Leros.scala 123:14]
    end
    if (reset) begin // @[Leros.scala 75:23]
      opdReg <= 32'h0; // @[Leros.scala 75:23]
    end else if (_T_2) begin // @[Leros.scala 121:20]
      opdReg <= _opdReg_T; // @[Leros.scala 124:14]
    end
    if (reset) begin // @[Leros.scala 147:21]
      exit <= 1'h0; // @[Leros.scala 147:21]
    end else begin
      exit <= exit_REG; // @[Leros.scala 148:8]
    end
    exit_REG <= decReg_exit; // @[Leros.scala 148:18]
    io_dbg_acc_REG <= alu_io_accu; // @[Leros.scala 153:34]
    io_dbg_acc_REG_1 <= io_dbg_acc_REG; // @[Leros.scala 153:26]
    io_dbg_pc_REG <= pcReg; // @[Leros.scala 154:33]
    io_dbg_pc_REG_1 <= io_dbg_pc_REG; // @[Leros.scala 154:25]
    io_dbg_instr_REG <= mem_io_instr; // @[Leros.scala 155:36]
    io_dbg_instr_REG_1 <= io_dbg_instr_REG; // @[Leros.scala 155:28]
    io_dbg_exit_REG <= exit; // @[Leros.scala 156:35]
    io_dbg_exit_REG_1 <= io_dbg_exit_REG; // @[Leros.scala 156:27]
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
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    registerMem[initvar] = _RAND_0[31:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 1024; initvar = initvar+1)
    dataMem[initvar] = _RAND_3[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  registerMem_registerRead_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  registerMem_registerRead_addr_pipe_0 = _RAND_2[7:0];
  _RAND_4 = {1{`RANDOM}};
  dataMem_dataRead_en_pipe_0 = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  dataMem_dataRead_addr_pipe_0 = _RAND_5[9:0];
  _RAND_6 = {1{`RANDOM}};
  pcReg = _RAND_6[9:0];
  _RAND_7 = {1{`RANDOM}};
  addrReg = _RAND_7[9:0];
  _RAND_8 = {1{`RANDOM}};
  stateReg = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  decReg_ena = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  decReg_op = _RAND_10[2:0];
  _RAND_11 = {1{`RANDOM}};
  decReg_isRegOpd = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  decReg_isStore = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  decReg_isStoreInd = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  decReg_isLoadInd = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  decReg_isLoadAddr = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  decReg_exit = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  opdReg = _RAND_17[31:0];
  _RAND_18 = {1{`RANDOM}};
  exit = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  exit_REG = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  io_dbg_acc_REG = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  io_dbg_acc_REG_1 = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  io_dbg_pc_REG = _RAND_22[9:0];
  _RAND_23 = {1{`RANDOM}};
  io_dbg_pc_REG_1 = _RAND_23[9:0];
  _RAND_24 = {1{`RANDOM}};
  io_dbg_instr_REG = _RAND_24[15:0];
  _RAND_25 = {1{`RANDOM}};
  io_dbg_instr_REG_1 = _RAND_25[15:0];
  _RAND_26 = {1{`RANDOM}};
  io_dbg_exit_REG = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  io_dbg_exit_REG_1 = _RAND_27[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
