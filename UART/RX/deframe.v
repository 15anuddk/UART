module deframe(
    input reset,
    input [10:0] frame,
    output reg parity_bit,
    output reg [7:0] data_packet
);

always @(*) begin
    if(reset) begin
      data_packet = 8'b0;
        parity_bit = 0;
    end
    else begin
      data_packet = frame[8:1];
      parity_bit = frame[9];
    end
endmodule