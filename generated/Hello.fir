circuit Hello :
  module Tx :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip channel : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg shiftReg : UInt, clock with :
      reset => (reset, UInt<11>("h7ff")) @[Uart.scala 16:25]
    reg cntReg : UInt<20>, clock with :
      reset => (reset, UInt<20>("h0")) @[Uart.scala 17:23]
    reg bitsReg : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[Uart.scala 18:24]
    node _io_channel_ready_T = eq(cntReg, UInt<1>("h0")) @[Uart.scala 20:31]
    node _io_channel_ready_T_1 = eq(bitsReg, UInt<1>("h0")) @[Uart.scala 20:52]
    node _io_channel_ready_T_2 = and(_io_channel_ready_T, _io_channel_ready_T_1) @[Uart.scala 20:40]
    io.channel.ready <= _io_channel_ready_T_2 @[Uart.scala 20:20]
    node _io_txd_T = bits(shiftReg, 0, 0) @[Uart.scala 21:21]
    io.txd <= _io_txd_T @[Uart.scala 21:10]
    node _T = eq(cntReg, UInt<1>("h0")) @[Uart.scala 23:15]
    when _T : @[Uart.scala 23:24]
      cntReg <= UInt<11>("h4e1") @[Uart.scala 24:12]
      node _T_1 = neq(bitsReg, UInt<1>("h0")) @[Uart.scala 25:18]
      when _T_1 : @[Uart.scala 25:27]
        node shift = shr(shiftReg, 1) @[Uart.scala 26:28]
        node _shiftReg_T = bits(shift, 9, 0) @[Uart.scala 27:33]
        node _shiftReg_T_1 = cat(UInt<1>("h1"), _shiftReg_T) @[Cat.scala 31:58]
        shiftReg <= _shiftReg_T_1 @[Uart.scala 27:16]
        node _bitsReg_T = sub(bitsReg, UInt<1>("h1")) @[Uart.scala 28:26]
        node _bitsReg_T_1 = tail(_bitsReg_T, 1) @[Uart.scala 28:26]
        bitsReg <= _bitsReg_T_1 @[Uart.scala 28:15]
      else :
        when io.channel.valid : @[Uart.scala 30:30]
          node _shiftReg_T_2 = cat(UInt<2>("h3"), io.channel.bits) @[Cat.scala 31:58]
          node _shiftReg_T_3 = cat(_shiftReg_T_2, UInt<1>("h0")) @[Cat.scala 31:58]
          shiftReg <= _shiftReg_T_3 @[Uart.scala 32:18]
          bitsReg <= UInt<4>("hb") @[Uart.scala 33:17]
        else :
          shiftReg <= UInt<11>("h7ff") @[Uart.scala 35:18]
    else :
      node _cntReg_T = sub(cntReg, UInt<1>("h1")) @[Uart.scala 39:22]
      node _cntReg_T_1 = tail(_cntReg_T, 1) @[Uart.scala 39:22]
      cntReg <= _cntReg_T_1 @[Uart.scala 39:12]

  module Buffer :
    input clock : Clock
    input reset : Reset
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg stateReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Uart.scala 90:25]
    reg dataReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[Uart.scala 91:24]
    node _io_in_ready_T = eq(stateReg, UInt<1>("h0")) @[Uart.scala 93:27]
    io.in.ready <= _io_in_ready_T @[Uart.scala 93:15]
    node _io_out_valid_T = eq(stateReg, UInt<1>("h1")) @[Uart.scala 94:28]
    io.out.valid <= _io_out_valid_T @[Uart.scala 94:16]
    node _T = eq(stateReg, UInt<1>("h0")) @[Uart.scala 96:17]
    when _T : @[Uart.scala 96:28]
      when io.in.valid : @[Uart.scala 97:23]
        dataReg <= io.in.bits @[Uart.scala 98:15]
        stateReg <= UInt<1>("h1") @[Uart.scala 99:16]
    else :
      when io.out.ready : @[Uart.scala 102:24]
        stateReg <= UInt<1>("h0") @[Uart.scala 103:16]
    io.out.bits <= dataReg @[Uart.scala 107:15]

  module BufferedTx :
    input clock : Clock
    input reset : Reset
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, txd : UInt<1>}

    inst tx of Tx @[Uart.scala 117:18]
    tx.clock <= clock
    tx.reset <= reset
    inst buf of Buffer @[Uart.scala 118:19]
    buf.clock <= clock
    buf.reset <= reset
    buf.io.in <= io.in @[Uart.scala 120:13]
    tx.io.channel <= buf.io.out @[Uart.scala 121:17]
    io.txd <= tx.io.txd @[Uart.scala 122:10]

  module Hello :
    input clock : Clock
    input reset : UInt<1>
    output io : { led1 : UInt<1>, led2 : UInt<1>, txd : UInt<1>}

    inst tx of BufferedTx @[Hello.scala 13:18]
    tx.clock <= clock
    tx.reset <= reset
    io.txd <= tx.io.txd @[Hello.scala 14:10]
    reg cntReg : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0")) @[Hello.scala 16:23]
    reg blkReg1 : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Hello.scala 17:24]
    reg blkReg2 : UInt<1>, clock with :
      reset => (reset, UInt<1>("h1")) @[Hello.scala 18:24]
    wire onMsg : UInt<7>[2] @[Hello.scala 20:22]
    onMsg[0] <= UInt<7>("h4f") @[Hello.scala 20:22]
    onMsg[1] <= UInt<7>("h4e") @[Hello.scala 20:22]
    wire offMsg : UInt<7>[3] @[Hello.scala 22:23]
    offMsg[0] <= UInt<7>("h4f") @[Hello.scala 22:23]
    offMsg[1] <= UInt<7>("h46") @[Hello.scala 22:23]
    offMsg[2] <= UInt<7>("h46") @[Hello.scala 22:23]
    reg txCntReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[Hello.scala 24:25]
    reg txLenReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[Hello.scala 25:25]
    reg startTxReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Hello.scala 26:27]
    reg runningTxReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Hello.scala 27:29]
    node _cntReg_T = add(cntReg, UInt<1>("h1")) @[Hello.scala 29:20]
    node _cntReg_T_1 = tail(_cntReg_T, 1) @[Hello.scala 29:20]
    cntReg <= _cntReg_T_1 @[Hello.scala 29:10]
    node _T = eq(cntReg, UInt<24>("hb71b00")) @[Hello.scala 30:15]
    when _T : @[Hello.scala 30:28]
      cntReg <= UInt<1>("h0") @[Hello.scala 31:12]
      node _blkReg1_T = not(blkReg1) @[Hello.scala 33:16]
      blkReg1 <= _blkReg1_T @[Hello.scala 33:13]
      blkReg2 <= blkReg1 @[Hello.scala 34:13]
      startTxReg <= UInt<1>("h1") @[Hello.scala 36:16]
    node _T_1 = eq(startTxReg, UInt<1>("h1")) @[Hello.scala 39:19]
    when _T_1 : @[Hello.scala 39:31]
      startTxReg <= UInt<1>("h0") @[Hello.scala 40:16]
      runningTxReg <= UInt<1>("h1") @[Hello.scala 41:18]
      txCntReg <= UInt<1>("h0") @[Hello.scala 42:14]
    node _T_2 = eq(blkReg1, UInt<1>("h1")) @[Hello.scala 44:16]
    when _T_2 : @[Hello.scala 44:25]
      txLenReg <= UInt<2>("h2") @[Hello.scala 45:14]
      node _tx_io_in_bits_T = bits(txCntReg, 0, 0)
      tx.io.in.bits <= onMsg[_tx_io_in_bits_T] @[Hello.scala 46:19]
    else :
      txLenReg <= UInt<2>("h3") @[Hello.scala 48:14]
      node _tx_io_in_bits_T_1 = bits(txCntReg, 1, 0)
      tx.io.in.bits <= offMsg[_tx_io_in_bits_T_1] @[Hello.scala 49:19]
    node _T_3 = neq(txCntReg, txLenReg) @[Hello.scala 51:35]
    node _T_4 = and(tx.io.in.ready, _T_3) @[Hello.scala 51:23]
    when _T_4 : @[Hello.scala 51:49]
      node _txCntReg_T = add(txCntReg, UInt<1>("h1")) @[Hello.scala 52:26]
      node _txCntReg_T_1 = tail(_txCntReg_T, 1) @[Hello.scala 52:26]
      txCntReg <= _txCntReg_T_1 @[Hello.scala 52:14]
    node _T_5 = eq(runningTxReg, UInt<1>("h1")) @[Hello.scala 54:21]
    when _T_5 : @[Hello.scala 54:33]
      node _T_6 = neq(txCntReg, txLenReg) @[Hello.scala 55:19]
      when _T_6 : @[Hello.scala 55:33]
        tx.io.in.valid <= UInt<1>("h1") @[Hello.scala 56:22]
      else :
        runningTxReg <= UInt<1>("h0") @[Hello.scala 58:20]
        tx.io.in.valid <= UInt<1>("h0") @[Hello.scala 59:22]
    else :
      tx.io.in.valid <= UInt<1>("h0") @[Hello.scala 62:20]
    io.led1 <= blkReg1 @[Hello.scala 65:11]
    io.led2 <= blkReg2 @[Hello.scala 66:11]

