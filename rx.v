`timescale 1ns / 1ps

module rx(
    input clk,
    input reset,
    input serial_data,
    output o_rx_dv,
    output [7:0] o_rx_data
);

parameter clk_per_bit = 87;
parameter idle = 3'b000;
parameter start_bit = 3'b001;
parameter packet = 3'b010;
parameter parity = 3'b011;
parameter stop_bit = 3'b100;


  reg           r_Rx_Data_R = 1'b1;
  reg           r_Rx_Data   = 1'b1;

reg [7: 0] clock_count = 0;
reg [2:0] bit_ind = 0;
reg [7:0] rx_data = 0;
reg [2:0] current_state = 0;
reg parity_check = 0;
reg rx_dv = 0;


always @(posedge clk) begin
  r_Rx_Data_R <= serial_data;
  r_Rx_Data   <= r_Rx_Data_R;
end

always @(posedge clk) begin
  if(reset) begin
    current_state <= idle ;
    clock_count <= 0;
    bit_ind <= 0;
    rx_data <= 0;
    parity_check <= 0;
    rx_dv <= 0;
  end
  else begin
    case (current_state) 
      idle: begin
        clock_count <= 0;
        bit_ind <= 0;
        rx_dv <= 0;

        if(r_Rx_Data == 1'b0) begin
          current_state <= start_bit;
        end
        else begin
          current_state <= idle;
        end
      end // idle end

      start_bit: begin
        if(clock_count == (clk_per_bit - 1)/2) begin
          if(r_Rx_Data == 1'b0) begin
            clock_count <= 0;
            current_state <= packet;
          end
          else current_state <= idle;
        end
        else begin
          clock_count <= clock_count + 1;
        end
      end // start bit end

      packet : begin
        if(clock_count < clk_per_bit - 1) begin
          clock_count <= clock_count +1 ;
        end
        else begin
          clock_count <= 0;
          rx_data[bit_ind] <= r_Rx_Data;
          parity_check <= parity_check ^ r_Rx_Data;
          if(bit_ind < 7) begin
            bit_ind <= bit_ind + 1;
          end
          else begin
            bit_ind <= 0;
            current_state <= parity;
          end
        end
      end // packet completed

      parity : begin
        if(clock_count < clk_per_bit - 1) begin
          clock_count <= clock_count + 1;
        end
        else begin
          clock_count <= 0;
          if(parity_check == r_Rx_Data) begin
            $display("Parity check matched");
          end
          else begin
            $display("Parity check unmatched");
          end
          current_state <= stop_bit;
        end
      end

      stop_bit : begin
        if(clock_count < clk_per_bit - 1) begin
          clock_count <= clock_count + 1;
        end
        else begin
          clock_count <= 0;
          parity_check <= 0;
          current_state <= idle;
          rx_dv <= 1'b1;
        end
      end

      default: current_state <= idle;

    endcase
  end
end

assign o_rx_data <= rx_data;
assign o_rx_dv <= rx_dv;

endmodule