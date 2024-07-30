`timescale 1ns / 1ps

module tb_dmem_addr_gen;
  logic        clk;
  logic        rst;
  logic        en;
  logic [6:0]  dmem_addr;
  logic [2:0]     nxt_start_block;
  logic [2:0]     nxt_sub_block;

  initial begin
    clk               = 1'b0;
    fork
      forever #5  clk = ~clk;
    join
  end

  initial begin
    rst       = 0;
    #10;
    rst       = 1;
    #10;
    en        = 1;
  end


  dmem_addr_gen dmem_addr_gen(
    .clk(clk),
    .rst(rst),
    .en(en),
    .dmem_addr(dmem_addr)
    //,.nxt_start_block(nxt_start_block)
    //,.nxt_sub_block(nxt_sub_block)
  );

endmodule