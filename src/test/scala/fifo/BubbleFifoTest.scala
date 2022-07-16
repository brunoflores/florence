import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import fifo.BubbleFifo
import os.size

class BubbleFifoTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Bubble FIFO"

  it should "pass" in {
    test(new BubbleFifo(size = 8, depth = 4))
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
        // Default signal values
        dut.io.enq.din.poke("hab".U)
        dut.io.enq.write.poke(false.B)
        dut.io.deq.read.poke(false.B)
        dut.clock.step()
        var full = dut.io.enq.full.peek.litToBoolean
        var empty = dut.io.deq.empty.peek.litToBoolean

        // Write into the buffer
        dut.io.enq.din.poke("h12".U)
        dut.io.enq.write.poke(true.B)
        dut.clock.step()
        full = dut.io.enq.full.peek.litToBoolean

        dut.io.enq.din.poke("hff".U)
        dut.io.enq.write.poke(false.B)
        dut.clock.step()
        full = dut.io.enq.full.peek.litToBoolean

        // Bubbling of the first element
        dut.clock.step()

        // Fill the whole buffer with a check for full condition.
        // Only every second cycle a write can happen.
        for (i <- 0 until 7) {
          full = dut.io.enq.full.peek.litToBoolean
          dut.io.enq.din.poke((0x80 + i).U)
          dut.io.enq.write.poke((!full).B)
          dut.clock.step()
        }

        // Now we know it is full, so do a single read and watch
        // how this empty slot bubbles up to the FIFO input.
        dut.io.deq.read.poke(true.B)
        dut.io.deq.dout.expect("h12".U)
        dut.clock.step()
        dut.io.deq.read.poke(false.B)
        dut.clock.step(6)

        // Now read out the whole buffer.
        // Also watch that maximum read out is every second clock cycle.
        for (i <- 0 until 7) {
          empty = dut.io.deq.empty.peek.litToBoolean
          dut.io.deq.read.poke((!empty).B)
          if (!empty) {
            dut.io.deq.dout.expect((0x80 + i).U)
          }
          dut.clock.step()
        }

        // Now write and read at maximum speed for some time.
        for (i <- 1 until 16) {
          full = dut.io.enq.full.peek.litToBoolean
          dut.io.enq.din.poke(i.U)
          dut.io.enq.write.poke((!full).B)

          empty = dut.io.deq.empty.peek.litToBoolean
          dut.io.deq.read.poke((!empty).B)
          dut.clock.step()
        }
      }
  }
}
