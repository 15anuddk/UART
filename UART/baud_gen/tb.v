`timescale 1ns / 1ps
module tb();

reg sys_clk, reset;
wire baud_clk;

baudgen uut(.sys_clk(sys_clk),
            .reset(reset),
            .baud_clk(baud_clk));


initial begin
  $dumpfile("baud_test.vcd");
  $dumpvars(0,tb);
end

//system clk 10MHz

initial begin
  sys_clk = 0;
  forever #50 sys_clk = ~sys_clk;
end

initial begin
  reset = 1;
  #100 reset = 0;
end

initial begin
  #3500000 $finish;
end
endmodule