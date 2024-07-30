`timescale 1ns / 1ps

module rip_counter_13b(
  input                  clk,
  input                  rst,
  input                  en,
  input [12:0]           end_count,
  input [12:0]           end_sub_count,
  output reg             fin,
  output reg             fin_sub,
  output reg [12:0]      cur_count
);

  always @(posedge clk) begin
    if(~rst) begin
      cur_count   <= 0;
      fin         <= 0;
      fin_sub     <= 0;

    end else begin
      if(en) begin
        if (cur_count == end_count) begin
          fin     <= 1;

        end else if(cur_count == end_sub_count) begin
          if(~fin_sub)
            fin_sub <= 1;
          else
            fin_sub <= 0;

        end else begin
          fin       <= 0;
          fin_sub   <= 0;
          cur_count <= cur_count + 1;
        end

      end
    end
  end

endmodule