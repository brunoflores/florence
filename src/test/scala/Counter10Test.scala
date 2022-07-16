import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class Counter10Test extends AnyFlatSpec with ChiselScalatestTester {
  "Counter" should "pass" in {
    test(new Count10).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      for (a <- 0 until 15) {
        dut.clock.step()
      }
    }
  }
}
