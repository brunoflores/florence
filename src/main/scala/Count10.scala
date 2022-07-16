import chisel3._

class Count10 extends Module {
  val io = IO(new Bundle {
                val dout = Output(UInt(8.W))
              })

  val add = Module(new Adder())
  val reg = Module(new Register())

  // Name the output of the register.
  val count = reg.io.q

  add.io.a := 1.U
  add.io.b := count
  // Name the output of the adder.
  val result = add.io.y

  // Name the output of the multiplexer.
  val next = Mux(count === 9.U, 0.U, result)
  reg.io.d := next

  io.dout := count
}
