import chisel3._

class Adder(n: Int) extends Module {
  val io = IO(new Bundle {
    val a = Input(UInt(n.W))
    val b = Input(UInt(n.W))
    val y = Output(UInt(n.W))
  })

  io.y := io.a + io.b
}
