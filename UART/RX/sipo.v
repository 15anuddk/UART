module sipo(
    input reset,
    input baud_clk,
    input data_tx,
    output reg [10:0]frame,
    output reg active_flag,
    output reg done_flag
);

parameter idle = 0, active=1;
reg state;
reg [3:0] clock_count;
always @(posedge baud_clk or posedge reset) begin
  if(reset) begin
    state <= idle;
    active_flag <= 0;
    done_flag <= 0;
    clock_count <= 0;
  end
  else begin
    case (state) 
    idle : begin
      active_flag <= 0;
      done_flag <= 0;

      if(data_tx == 0) begin
        state <= active;
        active_flag <= 1;
      end
    end

    active: begin
      frame[clock_count] <= data_tx;
      if(clock_count == 10) begin
        clock_count <= 0;
        state <= idle;
        done_flag <= 1;
        active_flag <= 0;
      end
      else begin
        clock_count <= clock_count + 1;
      end
    end
    default : state <= idle;
    endcase
  end
end
endmodule