`timescale 1ns / 1ps

module rip_counter_16b(
  input                   clk,
  input                   rst,
  input                   en,
  input [15:0]            end_count,
  output reg              fin
  ,output reg  [15:0]             cur_count
);

  //reg  [15:0]             cur_count;

  always @(posedge clk) begin
    if(~rst) begin
      cur_count   <= 0;
      fin         <= 0;
    end else begin
      if(en) begin
        if (cur_count == end_count) begin
          fin     <= 1;
        end else begin
          fin     <= 0;
        end
        cur_count <= cur_count + 1;
      end
    end
  end

endmodule