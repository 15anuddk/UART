module parity(
    input reset,
    input [7:0] data_in,
    output reg parity_bit
);


always @(*) begin
  if(reset) parity_bit = 1'b0;
  else begin
      parity_bit = (^data_in);
  end
end
endmodule   