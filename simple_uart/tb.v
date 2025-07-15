module tb();

reg clk, reset;

reg rx_serial; // This is the input to the UART receiver, but it's never being driven by any data.
wire tx_serial; // This is the output from the UART transmitter.

reg tx_start;
reg [7:0] tx_data;

wire tx_active;
wire tx_done;

wire rx_dv;
wire [7:0] rx_data;

uart_full_duplex dut (
    .clk(clk),
    .reset(reset),
    .rx_serial(rx_serial),
    .tx_serial(tx_serial),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx_active(tx_active),
    .tx_done(tx_done),
    .rx_dv(rx_dv),
    .rx_data(rx_data)
);

always #5 clk = ~clk;

initial begin
  clk = 0;
  reset = 1;
  rx_serial = 1;
  #50 reset = 0;

  reset = 1;
  #10 reset = 0; // transmit and receive single character

   #10 tx_start = 1;
   #10 tx_data = 8'h48; //H
   #10 tx_data = 8'h65;
   #10 tx_data = 8'h6C; // ASCII 'l'
   #10 tx_data = 8'h6C; // ASCII 'l'
   #10 tx_data = 8'h6F; // ASCII 'o'
   #10 tx_start = 0;


   #200
   if (rx_data !== 8'h48) begin
    $display("ERROR: Expected H, got %h", rx_data);
    $stop; // or use $fatal if your tool supports SystemVerilog
    end
    #10
     if (rx_data !== 8'h65) begin
    $display("ERROR: Expected e, got %h", rx_data);
    $stop; // or use $fatal if your tool supports SystemVerilog
    end
    // ... similar checks for other characters
    #10
     if (rx_data !== 8'h6F) begin
    $display("ERROR: Expected O, got %h", rx_data);
    $stop; // or use $fatal if your tool supports SystemVerilog
    end

  #50 $finish;

end
endmodule
