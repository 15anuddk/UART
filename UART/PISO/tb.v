`timescale 1ns/1ps
module tb();

reg baud_clk, reset;
reg [7:0] data_in;
reg send, parity_bit;

wire data_tx, active_flag, done_flag;


piso uut(.baud_clk(baud_clk),
         .reset(reset),
         .data_in(data_in),
         .send(send),
         .parity_bit(parity_bit),
         .data_tx(data_tx),
         .active_flag(active_flag),
         .done_flag(done_flag));

always #5 baud_clk = ~baud_clk;

initial begin
  $dumpfile("test.vcd");
  $dumpvars(0, tb);

  $monitor("data send,%b bit received %b", data_in, data_tx);
end

// Stimulus
initial begin
  // Init signals
  parity_bit = 0;
  baud_clk = 0;
  reset = 1;
  send = 0;
  data_in = 8'b0;

  #20 reset = 0;

  // Wait a few cycles, then send
  #20;
  data_in = 8'b01001010;
  send = 1;
  #10;        // one clk cycle
  send = 0;

  // Wait until done_flag is high
  wait (done_flag);
  #20;        // brief pause

  data_in = 8'b01001010;
  send = 1;
  #10;
  send = 0;
  wait (done_flag);
  #20;

  data_in = 8'b01001010;
  send = 1;
  #10;
  send = 0;
  wait (done_flag);
  #20;

  data_in = 8'b01011010;
  send = 1;
  #10;
  send = 0;
  wait (done_flag);
  #20;

  $finish;
end

endmodule