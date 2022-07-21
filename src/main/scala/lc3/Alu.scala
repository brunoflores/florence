package lc3

import chisel3._

object Alu {
  val SZ_ALU_FN = 4
  val XLEN = 32

  val FN_ADD = 0.U

  def isSub(cmd: UInt) = cmd(3)
}

import Alu._

class Alu extends Module {
  val io = IO(new Bundle {
    val fn = Input(UInt(SZ_ALU_FN.W))
    val in2 = Input(UInt(XLEN.W))
    val in1 = Input(UInt(XLEN.W))
    val out = Output(UInt(XLEN.W))
    val adder_out = Output(UInt(XLEN.W))
  })

  // ADD, SUB
  val in2_inv = Mux(isSub(io.fn), ~io.in2, io.in2)
  io.adder_out := io.in1 + in2_inv + isSub(io.fn)

  val out = Mux(io.fn === FN_ADD, io.adder_out, 0.U)

  io.out := out
}
