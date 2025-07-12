`timescale 1ns / 1ps

module uart_full_duplex(
    input  wire       clk,
    input  wire       reset,

    // UART interface
    input  wire       rx_serial,       // Input serial line
    output wire       tx_serial,       // Output serial line

    // Transmit interface
    input  wire       tx_start,        // Trigger to start transmission
    input  wire [7:0] tx_data,         // Data to transmit
    output wire       tx_active,       // TX is active
    output wire       tx_done,         // TX is done

    // Receive interface
    output wire       rx_dv,           // Data valid
    output wire [7:0] rx_data          // Received data
);

  //----------------------------------------------------------
  // TX Instance
  //----------------------------------------------------------
  tx uart_tx_inst (
    .reset(reset),
    .clk(clk),
    .tx_start(tx_start),
    .data(tx_data),
    .o_tx_active(tx_active),
    .serial_data(rx_serial),
    .o_tx_done(tx_done)
  );
 
  //----------------------------------------------------------
  // RX Instance
  //----------------------------------------------------------
  rx uart_rx_inst (
    .clk(clk),
    .reset(reset),
    .serial_data(rx_serial),
    .o_rx_dv(rx_dv),
    .o_rx_data(rx_data)
  );

endmodule
