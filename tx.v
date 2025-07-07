`timescale 1ns / 1ps

// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87

module tx(
    input i_clk, //clock
    input i_tx_dv,//datavalid : start transmitting
    input [7:0]i_tx_byte, //8-byte data to transmit
    output o_tx_act, //hight when it is transmitting
    output reg o_tx_serial, //serial output line
    output o_tx_done //high for one clk when done tx
);

parameter CLKS_PER_BIT = 2;
parameter idle = 3'b000; //FSM states
parameter tx_start_bit = 3'b001;
parameter tx_data_bits = 3'b010;
parameter tx_stop_bit = 3'b011;
parameter cleanup = 3'b100;

reg [2:0] current_state = 0;
reg [7:0] clock_count = 0;
reg [2:0] bit_ind = 0;
reg [7:0] tx_data = 0;
reg tx_done =0;
reg tx_active = 0;

always @(posedge i_clk) begin
  case(current_state)
    idle: begin
      o_tx_serial <= 1'b1; //high for idle
      r_Tx_Done     <= 1'b0;
      r_Clock_Count <= 0;
      r_Bit_Index   <= 0;

      if(i_tx_dv == 1'b1) begin //if data is valid
        tx_active <= 1'b1;
        tx_data <= i_tx_byte;
        current_state <= tx_start_bit;
      end
      else current_state = idle;
    end //idle ended

    tx_start_bit : begin
      o_tx_serial <= 1'b0; //start bit is low

      if(r_Clock_Count < CLKS_PER_BIT - 1) begin
        r_Clock_Count <= r_Clock_Count + 1;
        current_state <= tx_start_bit;
      end
      else begin
        r_Clock_Count <= 0;
        current_state <= tx_data_bits;
      end
    end // tx_data_bits ends

    tx_data_bits: begin
      o_tx_serial <= tx_data[bit_ind];

      if(r_Clock_Count < CLKS_PER_BIT - 1) begin
        r_Clock_Count <= r_Clock_Count +1;
        current_state <= tx_data_bits;
      end
      else begin
        r_Clock_Count <= 0;
        if(bit_ind < 7) begin
          bit_ind <= bit_ind + 1;
          current_state <= tx_data_bits;
        end
        else begin
          bit_ind <= 0;
          current_state <= tx_stop_bit;
        end
      end
    end//

    tx_stop_bit: begin
      o_tx_serial <= 1'b1;
      
      if(r_Clock_Count < CLKS_PER_BIT - 1) begin
        r_Clock_Count <= r_Clock_Count + 1;
        current_state <= tx_stop_bit;
      end
      else begin
        tx_done <= 1'b1;
        r_Clock_Count <= 0;
        current_state <= cleanup;
        tx_active <= 1'b0;
      end
    end

    cleanup: begin
      tx_done <= 1'b1;
      current_state <= idle;
    end

    default: current_state <=idle;
  endcase
end

assign o_tx_act = tx_active;
assign o_tx_done = tx_done;

endmodule
