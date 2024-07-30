`timescale 1ns / 1ps

module tb_DMEM;
  logic        clk;
  logic        rst;
  logic [6:0]  dmem_addr;
  logic [8:0]  dmem_data;

  initial begin
    clk               = 1'b0;
    fork
      forever #5  clk = ~clk;
    join
  end
  initial begin
    #10 dmem_addr = 0;
    fork
      forever #10  dmem_addr = dmem_addr + 1;
    join
  end
    initial begin
    rst       = 0;
    #10;
    rst       = 1;
  end


  dmem dmem1(
    .clk(clk),
    .rst(rst),
    .addr(dmem_addr),
    .data(dmem_data)
  );

endmodule