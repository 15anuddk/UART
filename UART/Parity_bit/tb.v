`timescale 1ns/1ps
module tb();
reg reset;
reg [7:0] data_in;

wire parity_bit;

parity uut(.reset(reset),
            .data_in(data_in),
            .parity_bit(parity_bit));

initial begin
  $dumpfile("test.vcd");
  $dumpvars(0,tb);

  $monitor("data_in = %b, parity %b", data_in,parity_bit);
end

initial
begin
    reset = 1'b1;
    #10 reset = 1'b0;
end

//  Test
initial
begin
    #10    data_in = 8'b00110111;
    #10 data_in = 8'b00001111;
    #10 data_in = 8'b10101111;
    #10 data_in= 8'b10101001;
    #10 data_in = 8'b10101001;
    #10 data_in = 8'b10111101;
end

endmodule