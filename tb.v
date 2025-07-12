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

   // Mistake 1: Incorrect timing for tx_start and tx_data
   // You are setting tx_start high, then changing tx_data multiple times,
   // then setting tx_start low. This is not how most UART TX modules work.
   // Typically, you set tx_data, then pulse tx_start for one clock cycle,
   // or hold it high until tx_active goes high and then low.
   // The provided code would likely only attempt to transmit the *last* value assigned to tx_data (8'h6F).
   #10 tx_start = 1;
   #10 tx_data = 8'h48; //H
   #10 tx_data = 8'h65;
   #10 tx_data = 8'h6C; // ASCII 'l'
   #10 tx_data = 8'h6C; // ASCII 'l'
   #10 tx_data = 8'h6F; // ASCII 'o'
   #10 tx_start = 0;

   // Mistake 2: Missing loopback connection
   // You never connected the 'tx_serial' output to the 'rx_serial' input.
   // So even if the transmitter worked perfectly, there's no data reaching the receiver.
   // The 'rx_serial' signal will remain at its initial default value (likely 'x' or '0') because it's an undriven 'reg' type without explicit initialization.

   // Mistake 3: Immediate and flawed data verification
   // You're waiting for #200 and then trying to check rx_data multiple times.
   // Firstly, #200 is likely not the correct delay for a full 5-character transmission and reception cycle.
   // Secondly, 'rx_data' only holds the *last* received byte when 'rx_dv' is pulsed.
   // You need to capture 'rx_data' when 'rx_dv' is high, for each byte individually.
   // The way you've written this, it will only ever check the value of rx_data at specific time points,
   // and won't react to when rx_dv actually goes high.
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
