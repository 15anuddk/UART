module errorcheck(
    input reset,
    input [7:0] data_packet,
    input parity_bit,
    output reg error_flag
);

reg check_parity;
always @(*) begin
  if(reset) begin
    error_flag = 0;
    check_parity = 0;
  end
  else begin
    check_parity = (^data_packet);
    if(check_parity == parity_bit) error_flag = 0;
    else error_flag = 1;
  end
end

endmodule