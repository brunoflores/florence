package leros

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

import leros.Types._

class AluTest extends AnyFlatSpec with ChiselScalatestTester {
  "Alu" should "pass" in {
    test(new Alu(32)) { dut =>
      def alu(a: Int, b: Int, op: Int): Int = {
        op match {
          case 1 => a + b
          case 2 => a - b
          case 3 => a & b
          case 4 => a | b
          case 5 => a ^ b
          case 6 => b
          case 7 => a >>> 1
          case _ => -123
        }
      }

      def testOne(a: Int, b: Int, fun: Int): Unit = {
        dut.io.op.poke(ld)
        dut.io.ena.poke(true.B)
        dut.io.din.poke((a.toLong & 0x00ff_ff_ff_ffL).U)
        dut.clock.step()
        dut.io.op.poke(fun.U)
        dut.io.din.poke((b.toLong & 0x00ff_ff_ff_ffL).U)
        dut.clock.step()
        dut.io.accu.expect((alu(a, b, fun.toInt).toLong & 0x00ff_ff_ff_ffL).U)
      }

      def test(values: Seq[Int]): Unit = {
        for (fun <- 1 to 7) {
          for (a <- values) {
            for (b <- values) {
              testOne(a, b, fun)
            }
          }
        }
      }

      val interesting = Array(1, 2, 4, 123, 0, -1, -2, 0x80000000, 0x7fffffff)
      test(interesting.toIndexedSeq)

      val randArgs = Seq.fill(10)(scala.util.Random.nextInt())
      test(randArgs)
    }
  }
}
