import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class HelloTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Hello"
  it should "pass" in {
    test(new Hello).withAnnotations(Seq(WriteVcdAnnotation)) { c =>
      c.clock.setTimeout(0)
      var ledStatus = BigInt(-1)
      println("Start the blinking LED")
      for (_ <- 0 until 10) {
        c.clock.step(10_000)
        val ledNow = c.io.led1.peek().litValue
        val s = if (ledNow == 0) "o" else "*"
        if (ledStatus != ledNow) {
          System.out.println(s)
          ledStatus = ledNow
        }
      }
      println("End the blinking LED")
    }
  }
}
