package uart

import chisel3._
import chisel3.util._

class UartIO extends DecoupledIO(UInt(8.W)) {}

class Tx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val txd = Output(UInt(1.W))
    val channel = Flipped(new UartIO())
  })

  val BIT_CNT = ((frequency + baudRate / 2) / baudRate - 1).asUInt

  val shiftReg = RegInit(0x7ff.U)
  val cntReg = RegInit(0.U(20.W))
  val bitsReg = RegInit(0.U(4.W))

  io.channel.ready := (cntReg === 0.U) && (bitsReg === 0.U)
  io.txd := shiftReg(0)

  when(cntReg === 0.U) {
    cntReg := BIT_CNT
    when(bitsReg =/= 0.U) {
      val shift = shiftReg >> 1
      shiftReg := Cat(1.U, shift(9, 0))
      bitsReg := bitsReg - 1.U
    }.otherwise {
      when(io.channel.valid) {
        // Two stop bits, data, one start bit.
        shiftReg := Cat(Cat(3.U, io.channel.bits), 0.U)
        bitsReg := 11.U
      }.otherwise {
        shiftReg := 0x7ff.U
      }
    }
  }.otherwise {
    cntReg := cntReg - 1.U
  }
}

class Rx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val rxd = Input(UInt(1.W))
    val channel = new UartIO()
  })

  val BIT_CNT = ((frequency + baudRate / 2) / baudRate - 1).U
  val START_CNT = ((3 * frequency / 2 + baudRate / 2) / baudRate - 1).U

  val rxReg = RegNext(RegNext(io.rxd, 1.U), 1.U)

  val shiftReg = RegInit(0.U(8.W))
  val cntReg = RegInit(0.U(20.W))
  val bitsReg = RegInit(0.U(4.W))
  val valReg = RegInit(false.B)

  when(cntReg =/= 0.U) {
    cntReg := cntReg - 1.U
  }.elsewhen(bitsReg =/= 0.U) {
    cntReg := BIT_CNT
    shiftReg := Cat(rxReg, shiftReg >> 1)
    bitsReg := bitsReg - 1.U
    // The last shifted in
    when(bitsReg === 1.U) {
      valReg := true.B
    }
  }.elsewhen(rxReg === 0.U) {
    cntReg := START_CNT
    bitsReg := 8.U
  }

  when(valReg && io.channel.ready) {
    valReg := false.B
  }

  io.channel.bits := shiftReg
  io.channel.valid := valReg
}

// A single byte buffer.
class Buffer extends Module {
  val io = IO(new Bundle {
    val in = Flipped(new UartIO())
    val out = new UartIO()
  })

  val empty :: full :: Nil = Enum(2)
  val stateReg = RegInit(empty)
  val dataReg = RegInit(0.U(8.W))

  io.in.ready := stateReg === empty
  io.out.valid := stateReg === full

  when(stateReg === empty) {
    when(io.in.valid) {
      dataReg := io.in.bits
      stateReg := full
    }
  }.otherwise {
    when(io.out.ready) {
      stateReg := empty
    }
  }

  io.out.bits := dataReg
}

// A transmitter with a single buffer.
class BufferedTx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val in = Flipped(new UartIO())
    val txd = Output(UInt(1.W))
  })

  val tx = Module(new Tx(frequency, baudRate))
  val buf = Module(new Buffer())

  buf.io.in <> io.in
  tx.io.channel <> buf.io.out
  io.txd <> tx.io.txd
}

// Send a string.
class Sender(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val txd = Output(UInt(1.W))
  })

  val tx = Module(new BufferedTx(frequency, baudRate))
  io.txd := tx.io.txd

  val msg = "Hello World!"
  val text = VecInit(msg.map(_.U))
  val len = msg.length.U

  val cntReg = RegInit(0.U(8.W))

  tx.io.in.bits := text(cntReg)
  tx.io.in.valid := cntReg =/= len

  when(tx.io.in.ready && cntReg =/= len) {
    cntReg := cntReg + 1.U
  }
}
