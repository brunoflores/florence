import chisel3._

class Dut extends Module {
  val io = IO(new Bundle {
                val a = Input(UInt(2.W))
                val b = Input(UInt(2.W))
                val out = Output(UInt(2.W))
              })

  // Bit-wise AND
  io.out := io.a & io.b
}
