import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class AdderTest extends AnyFlatSpec with ChiselScalatestTester {
  "Adder" should "pass" in {
    test(new Adder(8)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      dut.io.a.poke(41.U)
      dut.io.b.poke(1.U)
      dut.clock.step()
      dut.io.y.expect(42.U)
    }
  }
}
