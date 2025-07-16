
//sys clk 10 MHz  and baud rate 115200 i.e 87 clk_per_bit
module baudgen(
    input reset,
    input sys_clk,
    output reg baud_clk
);

parameter clk_per_bit= 87;
reg [6:0] clock_count = 0;
always @(posedge sys_clk or posedge reset) begin
  if(reset) begin
    baud_clk <= 0;
    clock_count <= 0;
  end
  else begin
    if(clock_count < clk_per_bit - 1) begin
      clock_count <= clock_count + 1;
      baud_clk <= baud_clk;
    end
    else begin
      clock_count <= 0;
      baud_clk <= ~baud_clk;
    end
  end
end

endmodule