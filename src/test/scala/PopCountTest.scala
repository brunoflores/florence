import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class PopCountTest extends AnyFlatSpec with ChiselScalatestTester {
  "PopCount" should "pass" in {
    test(new PopCount).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      dut.io.din.poke("b10101100".U)
      dut.io.dinValid.poke(true.B)
      dut.clock.step(9)
      dut.io.popCnt.expect(4.U)
    }
  }
}
