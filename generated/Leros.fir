circuit Leros :
  module Alu :
    input clock : Clock
    input reset : Reset
    output io : { flip op : UInt<3>, flip din : UInt<32>, flip ena : UInt<1>, accu : UInt<32>}

    reg a : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0")) @[Alu.scala 20:24]
    wire res : UInt
    res <= a
    node _T = eq(UInt<3>("h0"), io.op) @[Alu.scala 27:14]
    when _T : @[Alu.scala 27:14]
      res <= a @[Alu.scala 29:11]
    else :
      node _T_1 = eq(UInt<3>("h1"), io.op) @[Alu.scala 27:14]
      when _T_1 : @[Alu.scala 27:14]
        node _res_T = add(a, io.din) @[Alu.scala 32:16]
        node _res_T_1 = tail(_res_T, 1) @[Alu.scala 32:16]
        res <= _res_T_1 @[Alu.scala 32:11]
      else :
        node _T_2 = eq(UInt<3>("h2"), io.op) @[Alu.scala 27:14]
        when _T_2 : @[Alu.scala 27:14]
          node _res_T_2 = sub(a, io.din) @[Alu.scala 35:16]
          node _res_T_3 = tail(_res_T_2, 1) @[Alu.scala 35:16]
          res <= _res_T_3 @[Alu.scala 35:11]
        else :
          node _T_3 = eq(UInt<3>("h3"), io.op) @[Alu.scala 27:14]
          when _T_3 : @[Alu.scala 27:14]
            node _res_T_4 = and(a, io.din) @[Alu.scala 38:16]
            res <= _res_T_4 @[Alu.scala 38:11]
          else :
            node _T_4 = eq(UInt<3>("h4"), io.op) @[Alu.scala 27:14]
            when _T_4 : @[Alu.scala 27:14]
              node _res_T_5 = or(a, io.din) @[Alu.scala 41:16]
              res <= _res_T_5 @[Alu.scala 41:11]
            else :
              node _T_5 = eq(UInt<3>("h5"), io.op) @[Alu.scala 27:14]
              when _T_5 : @[Alu.scala 27:14]
                node _res_T_6 = xor(a, io.din) @[Alu.scala 44:16]
                res <= _res_T_6 @[Alu.scala 44:11]
              else :
                node _T_6 = eq(UInt<3>("h7"), io.op) @[Alu.scala 27:14]
                when _T_6 : @[Alu.scala 27:14]
                  node _res_T_7 = shr(a, 1) @[Alu.scala 47:16]
                  res <= _res_T_7 @[Alu.scala 47:11]
                else :
                  node _T_7 = eq(UInt<3>("h6"), io.op) @[Alu.scala 27:14]
                  when _T_7 : @[Alu.scala 27:14]
                    res <= io.din @[Alu.scala 50:11]
    when io.ena : @[Alu.scala 54:16]
      a <= res @[Alu.scala 55:13]
    io.accu <= a @[Alu.scala 58:11]

  module InstrMem :
    input clock : Clock
    input reset : Reset
    output io : { flip addr : UInt<10>, instr : UInt<16>}

    wire progMem : UInt<16>[5] @[Leros.scala 28:24]
    progMem[0] <= UInt<16>("h0") @[Leros.scala 28:24]
    progMem[1] <= UInt<16>("h903") @[Leros.scala 28:24]
    progMem[2] <= UInt<16>("hd02") @[Leros.scala 28:24]
    progMem[3] <= UInt<16>("h21ab") @[Leros.scala 28:24]
    progMem[4] <= UInt<16>("h2400") @[Leros.scala 28:24]
    reg memReg : UInt<10>, clock with :
      reset => (reset, UInt<10>("h0")) @[Leros.scala 29:23]
    memReg <= io.addr @[Leros.scala 30:10]
    node _io_instr_T = bits(memReg, 2, 0)
    io.instr <= progMem[_io_instr_T] @[Leros.scala 31:12]

  module Decode :
    input clock : Clock
    input reset : Reset
    output io : { flip din : UInt<8>, dout : { ena : UInt<1>, op : UInt, isRegOpd : UInt<1>, isStore : UInt<1>, isStoreInd : UInt<1>, isLoadInd : UInt<1>, isLoadAddr : UInt<1>, imm : UInt<1>, enahi : UInt<1>, enah2i : UInt<1>, enah3i : UInt<1>, nosext : UInt<1>, exit : UInt<1>}}

    wire d : { ena : UInt<1>, op : UInt, isRegOpd : UInt<1>, isStore : UInt<1>, isStoreInd : UInt<1>, isLoadInd : UInt<1>, isLoadAddr : UInt<1>, imm : UInt<1>, enahi : UInt<1>, enah2i : UInt<1>, enah3i : UInt<1>, nosext : UInt<1>, exit : UInt<1>} @[Decode.scala 27:17]
    d.ena <= UInt<1>("h0") @[Decode.scala 28:11]
    d.op <= UInt<3>("h0") @[Decode.scala 29:10]
    d.isRegOpd <= UInt<1>("h0") @[Decode.scala 30:16]
    d.isStore <= UInt<1>("h0") @[Decode.scala 31:15]
    d.isStoreInd <= UInt<1>("h0") @[Decode.scala 32:18]
    d.isLoadInd <= UInt<1>("h0") @[Decode.scala 33:17]
    d.isLoadAddr <= UInt<1>("h0") @[Decode.scala 34:18]
    d.imm <= UInt<1>("h0") @[Decode.scala 35:11]
    d.enahi <= UInt<1>("h0") @[Decode.scala 36:13]
    d.enah2i <= UInt<1>("h0") @[Decode.scala 37:14]
    d.enah3i <= UInt<1>("h0") @[Decode.scala 38:14]
    d.nosext <= UInt<1>("h0") @[Decode.scala 39:14]
    d.exit <= UInt<1>("h0") @[Decode.scala 40:12]
    wire isBranch : UInt<1>
    isBranch <= UInt<1>("h0")
    node field = bits(io.din, 7, 4) @[Decode.scala 65:21]
    node _T = eq(field, UInt<4>("h8")) @[Decode.scala 66:14]
    when _T : @[Decode.scala 66:28]
      isBranch <= UInt<1>("h1") @[Decode.scala 66:39]
    node _T_1 = eq(field, UInt<4>("h9")) @[Decode.scala 67:14]
    when _T_1 : @[Decode.scala 67:29]
      isBranch <= UInt<1>("h1") @[Decode.scala 67:40]
    node _T_2 = eq(field, UInt<4>("ha")) @[Decode.scala 68:14]
    when _T_2 : @[Decode.scala 68:30]
      isBranch <= UInt<1>("h1") @[Decode.scala 68:41]
    node _T_3 = eq(field, UInt<4>("hb")) @[Decode.scala 69:14]
    when _T_3 : @[Decode.scala 69:29]
      isBranch <= UInt<1>("h1") @[Decode.scala 69:40]
    node _T_4 = eq(field, UInt<4>("hc")) @[Decode.scala 70:14]
    when _T_4 : @[Decode.scala 70:29]
      isBranch <= UInt<1>("h1") @[Decode.scala 70:40]
    node _instr_T = and(io.din, UInt<8>("hf0")) @[Decode.scala 72:36]
    node instr = mux(isBranch, _instr_T, io.din) @[Decode.scala 72:18]
    node _T_5 = eq(UInt<4>("h8"), instr) @[Decode.scala 73:17]
    when _T_5 : @[Decode.scala 73:17]
      d.op <= UInt<3>("h1") @[Decode.scala 75:12]
      d.ena <= UInt<1>("h1") @[Decode.scala 76:13]
      d.isRegOpd <= UInt<1>("h1") @[Decode.scala 77:18]
    else :
      node _T_6 = eq(UInt<4>("h9"), instr) @[Decode.scala 73:17]
      when _T_6 : @[Decode.scala 73:17]
        d.op <= UInt<3>("h1") @[Decode.scala 80:12]
        d.ena <= UInt<1>("h1") @[Decode.scala 81:13]
        d.isRegOpd <= UInt<1>("h1") @[Decode.scala 82:18]
      else :
        node _T_7 = eq(UInt<4>("hc"), instr) @[Decode.scala 73:17]
        when _T_7 : @[Decode.scala 73:17]
          d.op <= UInt<3>("h2") @[Decode.scala 85:12]
          d.ena <= UInt<1>("h1") @[Decode.scala 86:13]
          d.isRegOpd <= UInt<1>("h1") @[Decode.scala 87:18]
        else :
          node _T_8 = eq(UInt<4>("hd"), instr) @[Decode.scala 73:17]
          when _T_8 : @[Decode.scala 73:17]
            d.op <= UInt<3>("h2") @[Decode.scala 90:12]
            d.ena <= UInt<1>("h1") @[Decode.scala 91:13]
            d.isRegOpd <= UInt<1>("h1") @[Decode.scala 92:18]
          else :
            node _T_9 = eq(UInt<5>("h10"), instr) @[Decode.scala 73:17]
            when _T_9 : @[Decode.scala 73:17]
              d.op <= UInt<3>("h7") @[Decode.scala 95:12]
              d.ena <= UInt<1>("h1") @[Decode.scala 96:13]
            else :
              node _T_10 = eq(UInt<6>("h20"), instr) @[Decode.scala 73:17]
              when _T_10 : @[Decode.scala 73:17]
                d.op <= UInt<3>("h6") @[Decode.scala 99:12]
                d.ena <= UInt<1>("h1") @[Decode.scala 100:13]
                d.isRegOpd <= UInt<1>("h1") @[Decode.scala 101:18]
              else :
                node _T_11 = eq(UInt<6>("h21"), instr) @[Decode.scala 73:17]
                when _T_11 : @[Decode.scala 73:17]
                  d.op <= UInt<3>("h6") @[Decode.scala 104:12]
                  d.ena <= UInt<1>("h1") @[Decode.scala 105:13]
                  d.imm <= UInt<1>("h1") @[Decode.scala 106:13]
                else :
                  node _T_12 = eq(UInt<6>("h22"), instr) @[Decode.scala 73:17]
                  when _T_12 : @[Decode.scala 73:17]
                    d.op <= UInt<3>("h3") @[Decode.scala 109:12]
                    d.ena <= UInt<1>("h1") @[Decode.scala 110:13]
                    d.isRegOpd <= UInt<1>("h1") @[Decode.scala 111:18]
                  else :
                    node _T_13 = eq(UInt<6>("h23"), instr) @[Decode.scala 73:17]
                    when _T_13 : @[Decode.scala 73:17]
                      d.op <= UInt<3>("h3") @[Decode.scala 114:12]
                      d.ena <= UInt<1>("h1") @[Decode.scala 115:13]
                      d.imm <= UInt<1>("h1") @[Decode.scala 116:13]
                      d.nosext <= UInt<1>("h1") @[Decode.scala 117:16]
                    else :
                      node _T_14 = eq(UInt<6>("h24"), instr) @[Decode.scala 73:17]
                      when _T_14 : @[Decode.scala 73:17]
                        d.op <= UInt<3>("h4") @[Decode.scala 120:12]
                        d.ena <= UInt<1>("h1") @[Decode.scala 121:13]
                        d.isRegOpd <= UInt<1>("h1") @[Decode.scala 122:18]
                      else :
                        node _T_15 = eq(UInt<6>("h25"), instr) @[Decode.scala 73:17]
                        when _T_15 : @[Decode.scala 73:17]
                          d.op <= UInt<3>("h4") @[Decode.scala 125:12]
                          d.ena <= UInt<1>("h1") @[Decode.scala 126:13]
                          d.imm <= UInt<1>("h1") @[Decode.scala 127:13]
                          d.nosext <= UInt<1>("h1") @[Decode.scala 128:16]
                        else :
                          node _T_16 = eq(UInt<6>("h26"), instr) @[Decode.scala 73:17]
                          when _T_16 : @[Decode.scala 73:17]
                            d.op <= UInt<3>("h5") @[Decode.scala 131:12]
                            d.ena <= UInt<1>("h1") @[Decode.scala 132:13]
                            d.isRegOpd <= UInt<1>("h1") @[Decode.scala 133:18]
                          else :
                            node _T_17 = eq(UInt<6>("h27"), instr) @[Decode.scala 73:17]
                            when _T_17 : @[Decode.scala 73:17]
                              d.op <= UInt<3>("h5") @[Decode.scala 136:12]
                              d.ena <= UInt<1>("h1") @[Decode.scala 137:13]
                              d.imm <= UInt<1>("h1") @[Decode.scala 138:13]
                              d.nosext <= UInt<1>("h1") @[Decode.scala 139:16]
                            else :
                              node _T_18 = eq(UInt<6>("h29"), instr) @[Decode.scala 73:17]
                              when _T_18 : @[Decode.scala 73:17]
                                d.op <= UInt<3>("h6") @[Decode.scala 142:12]
                                d.ena <= UInt<1>("h1") @[Decode.scala 143:13]
                                d.imm <= UInt<1>("h1") @[Decode.scala 144:13]
                                d.enahi <= UInt<1>("h1") @[Decode.scala 145:15]
                              else :
                                node _T_19 = eq(UInt<6>("h2a"), instr) @[Decode.scala 73:17]
                                when _T_19 : @[Decode.scala 73:17]
                                  d.op <= UInt<3>("h6") @[Decode.scala 149:12]
                                  d.imm <= UInt<1>("h1") @[Decode.scala 150:13]
                                  d.ena <= UInt<1>("h1") @[Decode.scala 151:13]
                                  d.enah2i <= UInt<1>("h1") @[Decode.scala 152:16]
                                else :
                                  node _T_20 = eq(UInt<6>("h2b"), instr) @[Decode.scala 73:17]
                                  when _T_20 : @[Decode.scala 73:17]
                                    d.op <= UInt<3>("h6") @[Decode.scala 155:12]
                                    d.imm <= UInt<1>("h1") @[Decode.scala 156:13]
                                    d.ena <= UInt<1>("h1") @[Decode.scala 157:13]
                                    d.enah3i <= UInt<1>("h1") @[Decode.scala 158:16]
                                  else :
                                    node _T_21 = eq(UInt<6>("h30"), instr) @[Decode.scala 73:17]
                                    when _T_21 : @[Decode.scala 73:17]
                                      d.isStore <= UInt<1>("h1") @[Decode.scala 161:17]
                                    else :
                                      node _T_22 = eq(UInt<7>("h50"), instr) @[Decode.scala 73:17]
                                      when _T_22 : @[Decode.scala 73:17]
                                        d.isLoadAddr <= UInt<1>("h1") @[Decode.scala 164:20]
                                      else :
                                        node _T_23 = eq(UInt<7>("h60"), instr) @[Decode.scala 73:17]
                                        when _T_23 : @[Decode.scala 73:17]
                                          d.isLoadInd <= UInt<1>("h1") @[Decode.scala 167:19]
                                          d.op <= UInt<3>("h6") @[Decode.scala 168:12]
                                          d.ena <= UInt<1>("h1") @[Decode.scala 169:13]
                                        else :
                                          node _T_24 = eq(UInt<7>("h61"), instr) @[Decode.scala 73:17]
                                          when _T_24 : @[Decode.scala 73:17]
                                            d.isLoadInd <= UInt<1>("h1") @[Decode.scala 173:19]
                                            d.op <= UInt<3>("h6") @[Decode.scala 174:12]
                                            d.ena <= UInt<1>("h1") @[Decode.scala 175:13]
                                          else :
                                            node _T_25 = eq(UInt<7>("h70"), instr) @[Decode.scala 73:17]
                                            when _T_25 : @[Decode.scala 73:17]
                                              d.isStoreInd <= UInt<1>("h1") @[Decode.scala 178:20]
                                            else :
                                              node _T_26 = eq(UInt<7>("h71"), instr) @[Decode.scala 73:17]
                                              when _T_26 : @[Decode.scala 73:17]
                                                d.isStoreInd <= UInt<1>("h1") @[Decode.scala 182:20]
                                              else :
                                                node _T_27 = eq(UInt<8>("hff"), instr) @[Decode.scala 73:17]
                                                when _T_27 : @[Decode.scala 73:17]
                                                  d.exit <= UInt<1>("h1") @[Decode.scala 185:14]
    io.dout <= d @[Decode.scala 188:11]

  module Leros :
    input clock : Clock
    input reset : UInt<1>
    output io : { dout : UInt<32>, dbg : { acc : UInt, pc : UInt, instr : UInt, exit : UInt<1>}}

    inst alu of Alu @[Leros.scala 52:19]
    alu.clock <= clock
    alu.reset <= reset
    reg pcReg : UInt<10>, clock with :
      reset => (reset, UInt<10>("h0")) @[Leros.scala 57:22]
    reg addrReg : UInt<10>, clock with :
      reset => (reset, UInt<10>("h0")) @[Leros.scala 58:24]
    reg stateReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Leros.scala 60:25]
    node _T = asUInt(UInt<1>("h0")) @[Leros.scala 62:20]
    node _T_1 = asUInt(stateReg) @[Leros.scala 62:20]
    node _T_2 = eq(_T, _T_1) @[Leros.scala 62:20]
    when _T_2 : @[Leros.scala 62:20]
      stateReg <= UInt<1>("h1") @[Leros.scala 63:26]
    else :
      node _T_3 = asUInt(UInt<1>("h1")) @[Leros.scala 62:20]
      node _T_4 = asUInt(stateReg) @[Leros.scala 62:20]
      node _T_5 = eq(_T_3, _T_4) @[Leros.scala 62:20]
      when _T_5 : @[Leros.scala 62:20]
        stateReg <= UInt<1>("h0") @[Leros.scala 64:24]
    node _pcNext_T = add(pcReg, UInt<1>("h1")) @[Leros.scala 67:34]
    node _pcNext_T_1 = tail(_pcNext_T, 1) @[Leros.scala 67:34]
    wire pcNext : UInt
    pcNext <= _pcNext_T_1
    inst mem of InstrMem @[Leros.scala 70:19]
    mem.clock <= clock
    mem.reset <= reset
    mem.io.addr <= pcNext @[Leros.scala 71:15]
    wire decReg_v : { ena : UInt<1>, op : UInt, isRegOpd : UInt<1>, isStore : UInt<1>, isStoreInd : UInt<1>, isLoadInd : UInt<1>, isLoadAddr : UInt<1>, imm : UInt<1>, enahi : UInt<1>, enah2i : UInt<1>, enah3i : UInt<1>, nosext : UInt<1>, exit : UInt<1>} @[Decode.scala 27:17]
    decReg_v.ena <= UInt<1>("h0") @[Decode.scala 28:11]
    decReg_v.op <= UInt<3>("h0") @[Decode.scala 29:10]
    decReg_v.isRegOpd <= UInt<1>("h0") @[Decode.scala 30:16]
    decReg_v.isStore <= UInt<1>("h0") @[Decode.scala 31:15]
    decReg_v.isStoreInd <= UInt<1>("h0") @[Decode.scala 32:18]
    decReg_v.isLoadInd <= UInt<1>("h0") @[Decode.scala 33:17]
    decReg_v.isLoadAddr <= UInt<1>("h0") @[Decode.scala 34:18]
    decReg_v.imm <= UInt<1>("h0") @[Decode.scala 35:11]
    decReg_v.enahi <= UInt<1>("h0") @[Decode.scala 36:13]
    decReg_v.enah2i <= UInt<1>("h0") @[Decode.scala 37:14]
    decReg_v.enah3i <= UInt<1>("h0") @[Decode.scala 38:14]
    decReg_v.nosext <= UInt<1>("h0") @[Decode.scala 39:14]
    decReg_v.exit <= UInt<1>("h0") @[Decode.scala 40:12]
    reg decReg : { ena : UInt<1>, op : UInt, isRegOpd : UInt<1>, isStore : UInt<1>, isStoreInd : UInt<1>, isLoadInd : UInt<1>, isLoadAddr : UInt<1>, imm : UInt<1>, enahi : UInt<1>, enah2i : UInt<1>, enah3i : UInt<1>, nosext : UInt<1>, exit : UInt<1>}, clock with :
      reset => (reset, decReg_v) @[Leros.scala 74:23]
    reg opdReg : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0")) @[Leros.scala 75:23]
    smem registerMem : UInt<32> [256] @[Leros.scala 77:32]
    node _registerRead_T = bits(mem.io.instr, 15, 0) @[Leros.scala 78:44]
    wire _registerRead_WIRE : UInt @[Leros.scala 78:38]
    _registerRead_WIRE is invalid @[Leros.scala 78:38]
    when UInt<1>("h1") : @[Leros.scala 78:38]
      _registerRead_WIRE <= _registerRead_T @[Leros.scala 78:38]
      node _registerRead_T_1 = or(_registerRead_WIRE, UInt<8>("h0")) @[Leros.scala 78:38]
      node _registerRead_T_2 = bits(_registerRead_T_1, 7, 0) @[Leros.scala 78:38]
      read mport registerRead = registerMem[_registerRead_T_2], clock @[Leros.scala 78:38]
    smem dataMem : UInt<32> [1024] @[Leros.scala 82:28]
    node _dataRead_T = eq(stateReg, UInt<1>("h1")) @[Leros.scala 84:52]
    node _dataRead_T_1 = and(decReg.isLoadAddr, _dataRead_T) @[Leros.scala 84:40]
    node _dataRead_T_2 = mux(_dataRead_T_1, alu.io.accu, addrReg) @[Leros.scala 84:21]
    wire _dataRead_WIRE : UInt @[Leros.scala 84:17]
    _dataRead_WIRE is invalid @[Leros.scala 84:17]
    when UInt<1>("h1") : @[Leros.scala 84:17]
      _dataRead_WIRE <= _dataRead_T_2 @[Leros.scala 84:17]
      node _dataRead_T_3 = or(_dataRead_WIRE, UInt<10>("h0")) @[Leros.scala 84:17]
      node _dataRead_T_4 = bits(_dataRead_T_3, 9, 0) @[Leros.scala 84:17]
      read mport dataRead = dataMem[_dataRead_T_4], clock @[Leros.scala 84:17]
    inst dec of Decode @[Leros.scala 87:19]
    dec.clock <= clock
    dec.reset <= reset
    node _dec_io_din_T = bits(mem.io.instr, 15, 8) @[Leros.scala 88:22]
    dec.io.din <= _dec_io_din_T @[Leros.scala 88:14]
    wire operand : SInt<32> @[Leros.scala 93:21]
    wire op16sex : SInt<16> @[Leros.scala 94:21]
    node _op16sex_T = bits(mem.io.instr, 7, 0) @[Leros.scala 95:19]
    node _op16sex_T_1 = asSInt(_op16sex_T) @[Leros.scala 95:26]
    op16sex <= _op16sex_T_1 @[Leros.scala 95:11]
    wire op24sex : SInt<24> @[Leros.scala 96:21]
    node _op24sex_T = bits(mem.io.instr, 7, 0) @[Leros.scala 97:19]
    node _op24sex_T_1 = asSInt(_op24sex_T) @[Leros.scala 97:26]
    op24sex <= _op24sex_T_1 @[Leros.scala 97:11]
    when dec.io.dout.nosext : @[Leros.scala 98:23]
      node _operand_T = bits(mem.io.instr, 7, 0) @[Leros.scala 99:35]
      node _operand_T_1 = cat(UInt<24>("h0"), _operand_T) @[Leros.scala 99:27]
      node _operand_T_2 = asSInt(_operand_T_1) @[Leros.scala 99:43]
      operand <= _operand_T_2 @[Leros.scala 99:13]
    else :
      when dec.io.dout.enahi : @[Leros.scala 100:28]
        node _operand_T_3 = asUInt(op24sex) @[Leros.scala 101:25]
        node _operand_T_4 = bits(alu.io.accu, 7, 0) @[Leros.scala 101:39]
        node _operand_T_5 = cat(_operand_T_3, _operand_T_4) @[Leros.scala 101:32]
        node _operand_T_6 = asSInt(_operand_T_5) @[Leros.scala 101:47]
        operand <= _operand_T_6 @[Leros.scala 101:13]
      else :
        when dec.io.dout.enah2i : @[Leros.scala 102:29]
          node _operand_T_7 = asUInt(op16sex) @[Leros.scala 103:25]
          node _operand_T_8 = bits(alu.io.accu, 15, 0) @[Leros.scala 103:39]
          node _operand_T_9 = cat(_operand_T_7, _operand_T_8) @[Leros.scala 103:32]
          node _operand_T_10 = asSInt(_operand_T_9) @[Leros.scala 103:48]
          operand <= _operand_T_10 @[Leros.scala 103:13]
        else :
          when dec.io.dout.enah3i : @[Leros.scala 104:29]
            node _operand_T_11 = bits(mem.io.instr, 7, 0) @[Leros.scala 105:22]
            node _operand_T_12 = bits(alu.io.accu, 23, 0) @[Leros.scala 105:36]
            node _operand_T_13 = cat(_operand_T_11, _operand_T_12) @[Leros.scala 105:29]
            node _operand_T_14 = asSInt(_operand_T_13) @[Leros.scala 105:45]
            operand <= _operand_T_14 @[Leros.scala 105:13]
          else :
            node _operand_T_15 = bits(mem.io.instr, 7, 0) @[Leros.scala 107:21]
            node _operand_T_16 = asSInt(_operand_T_15) @[Leros.scala 107:28]
            operand <= _operand_T_16 @[Leros.scala 107:13]
    alu.io.op <= decReg.op @[Leros.scala 113:13]
    node _alu_io_ena_T = eq(stateReg, UInt<1>("h1")) @[Leros.scala 114:40]
    node _alu_io_ena_T_1 = and(decReg.ena, _alu_io_ena_T) @[Leros.scala 114:28]
    alu.io.ena <= _alu_io_ena_T_1 @[Leros.scala 114:14]
    node _alu_io_din_T = mux(decReg.isRegOpd, registerRead, opdReg) @[Leros.scala 118:8]
    node _alu_io_din_T_1 = mux(decReg.isLoadInd, dataRead, _alu_io_din_T) @[Leros.scala 115:20]
    alu.io.din <= _alu_io_din_T_1 @[Leros.scala 115:14]
    node _T_6 = asUInt(UInt<1>("h0")) @[Leros.scala 121:20]
    node _T_7 = asUInt(stateReg) @[Leros.scala 121:20]
    node _T_8 = eq(_T_6, _T_7) @[Leros.scala 121:20]
    when _T_8 : @[Leros.scala 121:20]
      decReg <= dec.io.dout @[Leros.scala 123:14]
      node _opdReg_T = asUInt(operand) @[Leros.scala 124:25]
      opdReg <= _opdReg_T @[Leros.scala 124:14]
    else :
      node _T_9 = asUInt(UInt<1>("h1")) @[Leros.scala 121:20]
      node _T_10 = asUInt(stateReg) @[Leros.scala 121:20]
      node _T_11 = eq(_T_9, _T_10) @[Leros.scala 121:20]
      when _T_11 : @[Leros.scala 121:20]
        pcReg <= pcNext @[Leros.scala 128:13]
        when decReg.isStore : @[Leros.scala 129:28]
          node _T_12 = bits(opdReg, 15, 0) @[Leros.scala 130:33]
          node _T_13 = bits(_T_12, 7, 0)
          write mport MPORT = registerMem[_T_13], clock
          MPORT <= alu.io.accu
        when decReg.isLoadAddr : @[Leros.scala 132:31]
          addrReg <= alu.io.accu @[Leros.scala 133:17]
        when decReg.isLoadInd : @[Leros.scala 135:30]
          skip
        when decReg.isStoreInd : @[Leros.scala 138:31]
          write mport MPORT_1 = dataMem[addrReg], clock
          MPORT_1 <= alu.io.accu
    reg exit : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Leros.scala 147:21]
    reg exit_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), exit_REG) @[Leros.scala 148:18]
    exit_REG <= decReg.exit @[Leros.scala 148:18]
    exit <= exit_REG @[Leros.scala 148:8]
    io.dout <= UInt<6>("h2a") @[Leros.scala 150:11]
    reg io_dbg_acc_REG : UInt, clock with :
      reset => (UInt<1>("h0"), io_dbg_acc_REG) @[Leros.scala 153:34]
    io_dbg_acc_REG <= alu.io.accu @[Leros.scala 153:34]
    reg io_dbg_acc_REG_1 : UInt, clock with :
      reset => (UInt<1>("h0"), io_dbg_acc_REG_1) @[Leros.scala 153:26]
    io_dbg_acc_REG_1 <= io_dbg_acc_REG @[Leros.scala 153:26]
    io.dbg.acc <= io_dbg_acc_REG_1 @[Leros.scala 153:16]
    reg io_dbg_pc_REG : UInt, clock with :
      reset => (UInt<1>("h0"), io_dbg_pc_REG) @[Leros.scala 154:33]
    io_dbg_pc_REG <= pcReg @[Leros.scala 154:33]
    reg io_dbg_pc_REG_1 : UInt, clock with :
      reset => (UInt<1>("h0"), io_dbg_pc_REG_1) @[Leros.scala 154:25]
    io_dbg_pc_REG_1 <= io_dbg_pc_REG @[Leros.scala 154:25]
    io.dbg.pc <= io_dbg_pc_REG_1 @[Leros.scala 154:15]
    reg io_dbg_instr_REG : UInt, clock with :
      reset => (UInt<1>("h0"), io_dbg_instr_REG) @[Leros.scala 155:36]
    io_dbg_instr_REG <= mem.io.instr @[Leros.scala 155:36]
    reg io_dbg_instr_REG_1 : UInt, clock with :
      reset => (UInt<1>("h0"), io_dbg_instr_REG_1) @[Leros.scala 155:28]
    io_dbg_instr_REG_1 <= io_dbg_instr_REG @[Leros.scala 155:28]
    io.dbg.instr <= io_dbg_instr_REG_1 @[Leros.scala 155:18]
    reg io_dbg_exit_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_dbg_exit_REG) @[Leros.scala 156:35]
    io_dbg_exit_REG <= exit @[Leros.scala 156:35]
    reg io_dbg_exit_REG_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), io_dbg_exit_REG_1) @[Leros.scala 156:27]
    io_dbg_exit_REG_1 <= io_dbg_exit_REG @[Leros.scala 156:27]
    io.dbg.exit <= io_dbg_exit_REG_1 @[Leros.scala 156:17]

