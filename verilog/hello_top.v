module hello_top(input sysclk, output led1, output led2, output pio1);
  wire h_io_led1;
  wire h_io_led2;
  wire h_io_pio1;

  wire rst;

  assign led1 = h_io_led1;
  assign led2 = h_io_led2;
  assign pio1 = h_io_pio1;

  assign rst = 1'h0;

  Hello h(
       .clock(sysclk),
       .reset(rst),
       .io_led1( h_io_led1 ),
       .io_led2( h_io_led2 ),
       .io_txd( h_io_pio1 ));
endmodule
