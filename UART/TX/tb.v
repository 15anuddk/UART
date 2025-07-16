`timescale 1ns/1ps
module tb();

reg sys_clk, reset, send;
reg [7:0] data_in;

wire data_tx;
wire tx_active, tx_done;

tx uut(
    .reset(reset),
    .sys_clk(sys_clk),
    .send(send),
    .data_in(data_in),
    .data_tx(data_tx),
    .active_flag(tx_active),
    .done_flag(tx_done)
);

always #50 sys_clk = ~sys_clk; // 100ns clock period

initial begin
  $dumpfile("test.vcd");
  $dumpvars(0, tb);
  $monitor($time, "   The Outputs:  Data Tx = %b  Done Flag = %b  Active Flag = %b The Inputs:   Reset = %b  Data In = %b  Send = %b ",
    data_tx, tx_done, tx_active, reset, 
    data_in[7:0], send);
end

initial begin
  sys_clk = 0;
  reset = 1;
  send = 0;
  #10 reset = 0;

  #10;
  data_in = 8'b00110111;
  send = 1;
  // Wait for transmission to complete
  wait(tx_done);
  #100;
  $finish;
end

endmodule
