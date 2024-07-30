`timescale 1ns / 1ps

module tb_gated_clk;

  // Inputs
  logic     clk;
  logic     l1;

  // Outputs
  logic     gated_clk;

  // Instantiate the module
  gated_clk uut (
    .clk(clk),
    .l1(l1),
    .gated_clk(gated_clk)
  );

  // Clock generation
  initial begin
    clk                             = 1'b0;
    fork
      forever #5  clk = ~clk;
    join
  end

  // Initial block
  initial begin
    l1 = 0;
    fork
      forever begin
        #30  l1 = 1;
        #10  l1 = 0;
      end
    join
  end

endmodule
