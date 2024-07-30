`timescale 1ns / 1ps

module rip_counter_7b_v2(
  input             clk,
  input             rst,
  input             en,
  input [6:0]       start_count,
  input [6:0]       end_count,
  output reg        fin,
  output reg [6:0]  cur_count
);

  always @(posedge clk or negedge rst) begin
    if(~rst) begin
      cur_count   <= start_count;
      fin         <= 0;
    end else begin
      if(en) begin
        if (cur_count == end_count) begin
          fin     <= 1;
        end else begin
          fin     <= 0;
          cur_count <= cur_count + 1;
        end
        //cur_count <= cur_count + 1;
      end
    end
  end

endmodule