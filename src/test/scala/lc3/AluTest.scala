package lc3

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class AluTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "ALU"
  it should "add" in {
    test(new Alu).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      dut.io.fn.poke(Alu.FN_ADD)
      dut.io.in1.poke(40.U)
      dut.io.in2.poke(2.U)
      dut.io.out.expect(42.U)
    }
  }
  it should "add large numbers" in {
    test(new Alu).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      dut.io.fn.poke(Alu.FN_ADD)
      dut.io.in1.poke((scala.math.pow(2, 32) - 2).toLong.U)
      dut.io.in2.poke(1.U)
      dut.io.out.expect((scala.math.pow(2, 32) - 1).toLong.U)
    }
  }
  it should "wrap around" in {
    test(new Alu).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      dut.io.fn.poke(Alu.FN_ADD)
      dut.io.in1.poke((scala.math.pow(2, 32) - 1).toLong.U)
      dut.io.in2.poke(2.U)
      dut.io.out.expect(1.U)
    }
  }
  it should "subtract" in {
    test(new Alu).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      dut.io.fn.poke(Alu.FN_SUB)
      dut.io.in1.poke(44.U)
      dut.io.in2.poke(2.U)
      dut.io.out.expect(42.U)
    }
  }
}
