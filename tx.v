`timescale 1ns / 1ps

//identify input output
module tx(
    input reset,
    input [7:0] data,
    input clk,
    input tx_start,
    output o_tx_active,
    output reg serial_data,
    output o_tx_done  
);

parameter idle = 3'b000;
parameter start_bit = 3'b001;
parameter packet = 3'b010;
parameter parity = 3'b011;
parameter stop_bit = 3'b100;


parameter clk_per_bit = 87;

reg [2:0] current_state = 3'b000;
reg [7:0] clock_count = 0;
reg [2:0] bit_ind = 0;
reg [7:0] tx_data = 0;
reg tx_done =0;
reg tx_active = 0;
reg parity_bit = 0;

always @(posedge clk) begin
if (reset) begin
  current_state <= idle;
    clock_count <= 0;
    bit_ind <= 0;
    tx_data <= 0;
    tx_done <= 0;
    tx_active <= 0;
    parity_bit <= 0;
    serial_data <= 1;
end
else begin
  

  case(current_state)
    
    idle : begin
      serial_data <= 1'b1;
      tx_active <= 1'b0;
      tx_done <= 1'b0;

      if(tx_start == 1'b1) begin
        tx_active <= 1'b1;
        tx_data <= data;
        current_state <= start_bit;
      end
    end //idle ended

    start_bit : begin
      serial_data <= 1'b0; //start bit is low
      if(clock_count < clk_per_bit -1) begin
        clock_count <= clock_count + 1;
      end
      else begin
        current_state <= packet;
        clock_count <= 0;
      end
    end // start_bit end

    packet : begin
      serial_data <= tx_data[bit_ind];
      

      if(clock_count < clk_per_bit - 1) begin
        clock_count <= clock_count + 1;
      end
      else begin
        clock_count <= 1'b0;
        parity_bit <= parity_bit ^ tx_data[bit_ind];
        if(bit_ind < 7) begin
          bit_ind <= bit_ind + 1;
          current_state <= packet;
        end
        else begin
          bit_ind <= 0;
          current_state <= parity;
        end
      end
    end // packet tx done

    parity: begin
      serial_data <= parity_bit;
      if(clock_count < clk_per_bit - 1) begin
        clock_count <= clock_count + 1;
      end
      else begin
        clock_count <= 0;
        current_state <= stop_bit;
      end
    end //parity end

    stop_bit : begin
      serial_data <= 1'b1;
       tx_done <= 1'b1;
      if(clock_count < clk_per_bit -1) begin
        clock_count <= clock_count + 1;
      end
      else begin
        clock_count <= 0;
        tx_done <= 0;
        tx_active <= 0;
        current_state <= idle;
        parity_bit <= 0;
      end
    end // stop bit ended

    default: current_state <= idle;

    endcase
end
end
assign o_tx_active = tx_active;
assign o_tx_done = tx_done;

endmodule