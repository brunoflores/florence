package uart
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class UartSenderTests extends AnyFlatSpec with ChiselScalatestTester {
  "UartSender" should "work" in {
    test(new Sender(10_000, 3_000)).withAnnotations(Seq(WriteVcdAnnotation)) {
      dut =>
        var bytes = List[Char]()
        val want = "Hello World!"
        for (n <- 0 until want.length()) {
          var byte: Int = 0;

          // Wait for start bit
          while (dut.io.txd.peek().litValue != 0) {
            dut.clock.step(1)
          }

          // To the first bit
          dut.clock.step(3)

          // Least significant bit first
          for (i <- 0 until 8) {
            byte |= dut.io.txd.peek().litValue.toInt << i
            dut.clock.step(3)
          }

          // Stop bit
          dut.io.txd.expect(1.U)

          bytes = byte.toChar :: bytes
        }
        val got = bytes.reverse.foldLeft("")(_ + _)
        assert(got == want)
    }
  }
}
