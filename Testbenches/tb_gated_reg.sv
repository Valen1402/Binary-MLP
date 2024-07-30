`timescale 1ns / 1ps

module tb_gated_reg;

  // Inputs
  logic clk;
  logic gated_clk;
  logic rst15;
  logic rst7;
  logic [14:0] din;
  logic l1;

  // Outputs
  logic [14:0] dout;

  // Instantiate the module
  gated_clk gclk (
    .clk(clk),
    .l1(l1),
    .gated_clk(gated_clk)
  );

  gated_reg greg (
    .clk(clk),
    .rst15(rst15),
    .rst7(rst7),
    .gated_clk(gated_clk),
    .din(din),
    .dout(dout)
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
    fork
      forever begin
        #100  l1 = 0;
        #100  l1 = 1;
      end
    join
  end

  // Input data generation
  initial begin
    din = 15'b000011111111111;
    fork
      forever begin
        #10 din = din<<1;
      end
    join
  end

  initial begin
    l1    = 0;
    rst15 = 0;
    rst7  = 0;
    #10;
    rst15 = 1;
    rst7  = 1;
    #25;
    l1    = 1;
  end

endmodule