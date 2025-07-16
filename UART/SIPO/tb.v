module tb();

  reg reset;
  reg baud_clk, data_tx;
  wire [10:0] frame;
  wire active_flag;
  wire done_flag;

  sipo uut(
    .reset(reset), 
    .baud_clk(baud_clk),
    .data_tx(data_tx),
    .frame(frame),
    .active_flag(active_flag),
    .done_flag(done_flag)
  );

  // Baud clock: 10 time units period
  always #5 baud_clk = ~baud_clk;

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, tb);
    baud_clk = 0;
    data_tx = 1; // idle line
    reset = 1;
    #10 reset = 0;

    data_tx = 1;
  #10 data_tx = 1;
  #10 data_tx = 0;
  #10 data_tx = 1;
  #10 data_tx = 1;
  #10 data_tx = 1;
  #10 data_tx = 0;
  #10 data_tx = 1;
  #10 data_tx = 1;
 #10 data_tx = 0;
  #10 data_tx = 0;
  #10 data_tx = 1;
  #10 data_tx = 1;
  #10 data_tx = 1;
    #100;

    $display("\n==== Decoded Frame ====");
    $display("Full frame : %b", frame);
    $display("Start bit  : %b", frame[0]);
    $display("Data       : %b", frame[8:1]);
    $display("Parity bit : %b", frame[9]);
    $display("Stop bit   : %b", frame[10]);
    $display("Data (hex) : %h", frame[8:1]);
    $display("========================\n");

    $finish;
  end

endmodule
