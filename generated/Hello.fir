circuit Hello :
  module Hello :
    input clock : Clock
    input reset : UInt<1>
    output io : { led1 : UInt<1>, led2 : UInt<1>}

    reg cntReg : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0")) @[Hello.scala 20:23]
    reg blkReg1 : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Hello.scala 21:24]
    reg blkReg2 : UInt<1>, clock with :
      reset => (reset, UInt<1>("h1")) @[Hello.scala 22:24]
    node _cntReg_T = add(cntReg, UInt<1>("h1")) @[Hello.scala 24:20]
    node _cntReg_T_1 = tail(_cntReg_T, 1) @[Hello.scala 24:20]
    cntReg <= _cntReg_T_1 @[Hello.scala 24:10]
    node _T = eq(cntReg, UInt<24>("hb71b00")) @[Hello.scala 25:15]
    when _T : @[Hello.scala 25:28]
      cntReg <= UInt<1>("h0") @[Hello.scala 26:12]
      node _blkReg1_T = not(blkReg1) @[Hello.scala 27:16]
      blkReg1 <= _blkReg1_T @[Hello.scala 27:13]
      blkReg2 <= blkReg1 @[Hello.scala 28:13]
    io.led1 <= blkReg1 @[Hello.scala 30:11]
    io.led2 <= blkReg2 @[Hello.scala 31:11]

