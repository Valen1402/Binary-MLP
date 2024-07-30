`timescale 1ns / 1ps
module wmem(
  input  wire         clk,
  input  wire         rst,
  input  wire [12:0]  addr,

  output reg          data
);

  reg  [4605:0]       mem;
  integer i;
  always @ (posedge clk) begin
    if(~rst) begin
      for (i=0; i<4606; i=i+2) begin
        mem[i] <= 1;
      end
      for (i=1; i<4606; i=i+2) begin
        mem[i] <= 0;
      end
    end else
      data    <= mem[addr];
  end

endmodule
