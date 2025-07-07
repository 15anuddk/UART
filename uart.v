`timescale 1ns / 1ps

module uart #(
    parameter CLKS_PER_BIT = 87  // For 115200 baud with 10MHz clock
)(
    input        i_Clock,
    input        i_Reset,
    
    // Transmitter Inputs
    input        i_Tx_DV,
    input  [7:0] i_Tx_Byte,
    output       o_Tx_Active,
    output       o_Tx_Serial,
    output       o_Tx_Done,

    // Receiver Inputs
    input        i_Rx_Serial,
    output       o_Rx_DV,
    output [7:0] o_Rx_Byte
);

  // Transmitter instance
  uart_tx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
  ) tx_inst (
    .i_clk(i_Clock),
    .i_Tx_DV(i_Tx_DV),
    .i_Tx_Byte(i_Tx_Byte),
    .o_Tx_Active(o_Tx_Active),
    .o_Tx_Serial(o_Tx_Serial),
    .o_Tx_Done(o_Tx_Done)
  );

  // Receiver instance
  receiver #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
  ) rx_inst (
    .i_Clock(i_Clock),
    .i_Rx_Serial(i_Rx_Serial),
    .o_Rx_DV(o_Rx_DV),
    .o_Rx_Byte(o_Rx_Byte)
  );

endmodule
