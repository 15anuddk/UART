module tx(
    input reset,
    input send,
    input clock,
    input parity_type,
    input data_in,

    output data_tx,
    output active_flag,
    output  done_flag
);

wire parity_bit_w;
wire baud_clk_w;

baudgen unit1(.reset(reset),
               . sys_clk(sys_clk),
               .baud_clk(baud_clk_w));

parity unit2(.reset(reset),
             .data_in(data_in),
             .parity_type(parity_type)
             .parity_bit(parity_bit_w));

piso unit3(.reset(reset),
           .baud_clk(baud_clk_w),
           .data_in(data_in),
           .send(send),
           .parity_bit(parity_bit_w),
           .data_tx(data_tx),
           .active_flag(active_flag),
           .done_flag(done_flag));
endmodule