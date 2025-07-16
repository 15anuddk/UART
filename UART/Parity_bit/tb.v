`timescale 1ns/1ps
module tb();
reg reset;
reg [7:0] data_in;
reg [1:0] parity_type;

wire parity_bit;

parity uut(.reset(reset),
            .data_in(data_in),
            .parity_type(parity_type),
            .parity_bit(parity_bit));

initial begin
  $dumpfile("test.vcd");
  $dumpvars(0,tb);

  $monitor("data_in = %b, paritytype %b , parity %b", data_in,parity_type, parity_bit);
end

initial
begin
    reset = 1'b1;
    #10 reset = 1'b0;
end

//  Test
initial
begin
        data_in = 8'b00010111;
    #10 data_in = 8'b00001111;
    #10 data_in = 8'b10101111;
    #10 data_in= 8'b10101001;
    #10 data_in = 8'b10101001;
    #10 data_in = 8'b10111101;
end

//  Parity Types
initial
begin
        parity_type = 2'b00;
    #10 parity_type = 2'b00;
    #10 parity_type = 2'b01;
    #10 parity_type = 2'b10;
    #10 parity_type = 2'b11;
end
endmodule