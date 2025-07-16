module piso(
    input reset,
    input baud_clk,
    input [7:0] data_in,
    input send, //enable to start send
    input parity_bit,

    output reg data_tx,
    output reg active_flag,
    output reg done_flag
);

reg [3:0] clock_count;
reg [10:0] frame; //
reg state;

parameter idle = 0;
parameter active = 1;


always @(posedge baud_clk or posedge reset) begin
  if(reset) begin
    state <= idle;
    clock_count <= 0;
    data_tx <= 1'b1;
    active_flag <= 0;
    done_flag <= 0;
    frame <= {11{1'b1}};
  end
  else begin
    case (state)
        idle: begin
          data_tx <= 1'b1;
          clock_count <= 0;
          active_flag <= 0;
          done_flag <= 0;
        
          if(send) begin
            state <= active;
            active_flag <= 1'b1;
            frame <= {1'b1,parity_bit,data_in,1'b0};
          end
        end 

        active: begin
            data_tx <= frame[0];
          if(clock_count == 10) begin
            state <= idle;
            clock_count <= 0;
            done_flag <= 1;
            active_flag <= 0;
          end
          else begin
            frame <= frame >> 1;
            clock_count <= clock_count + 1;
            active_flag <= 1;
            done_flag <= 0;
          end
        end 
        default: state <= idle;
    endcase
  end

end









endmodule