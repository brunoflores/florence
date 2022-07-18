import chisel3._
import uart.BufferedTx

class Hello extends Module {
  val io = IO(new Bundle {
    val led1 = Output(UInt(1.W))
    val led2 = Output(UInt(1.W))
    val txd = Output(UInt(1.W))
  })

  val CNT_MAX = 12_000_000.U

  val tx = Module(new BufferedTx(12_000_000, 9600))
  io.txd := tx.io.txd

  val cntReg = RegInit(0.U(32.W))
  val blkReg1 = RegInit(0.U(1.W))
  val blkReg2 = RegInit(1.U(1.W))

  val onMsg = VecInit("ON".map(_.U))
  val onLen = onMsg.length.U
  val offMsg = VecInit("OFF".map(_.U))
  val offLen = offMsg.length.U
  val txCntReg = RegInit(0.U(8.W))
  val txLenReg = RegInit(0.U(8.W))
  val startTxReg = RegInit(false.B)
  val runningTxReg = RegInit(false.B)

  cntReg := cntReg + 1.U
  when(cntReg === CNT_MAX) {
    cntReg := 0.U

    blkReg1 := ~blkReg1
    blkReg2 := blkReg1

    startTxReg := true.B
  }

  when(startTxReg === true.B) {
    startTxReg := false.B
    runningTxReg := true.B
    txCntReg := 0.U
  }
  when(blkReg1 === 1.U) {
    txLenReg := onLen
    tx.io.in.bits := onMsg(txCntReg)
  }.otherwise {
    txLenReg := offLen
    tx.io.in.bits := offMsg(txCntReg)
  }
  when(tx.io.in.ready && txCntReg =/= txLenReg) {
    txCntReg := txCntReg + 1.U
  }
  when(runningTxReg === true.B) {
    when(txCntReg =/= txLenReg) {
      tx.io.in.valid := true.B
    }.otherwise {
      runningTxReg := false.B
      tx.io.in.valid := false.B
    }
  }.otherwise {
    tx.io.in.valid := false.B
  }

  io.led1 := blkReg1
  io.led2 := blkReg2
}

object Hello extends App {
  (new chisel3.stage.ChiselStage)
    .emitVerilog(new Hello(), Array("--target-dir", "generated"))
}
