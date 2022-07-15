/*
 * This code is a minimal hardware described in Chisel.
 *
 * Blinking LED: the FPGA version of Hello World
 */

import chisel3._

/**
 * The blinking LED component.
 */

class Hello extends Module {
  val io = IO(new Bundle {
    val led1 = Output(UInt(1.W))
    val led2 = Output(UInt(1.W))
  })
  val CNT_MAX = 12_000_000.U

  val cntReg = RegInit(0.U(32.W))
  val blkReg1 = RegInit(0.U(1.W))
  val blkReg2 = RegInit(1.U(1.W))

  cntReg := cntReg + 1.U
  when(cntReg === CNT_MAX) {
    cntReg := 0.U
    blkReg1 := ~blkReg1
    blkReg2 := blkReg1
  }
  io.led1 := blkReg1
  io.led2 := blkReg2
}

/**
 * An object extending App to generate the Verilog code.
 */
object Hello extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(
    new Hello(), Array("--target-dir", "generated"))
}
