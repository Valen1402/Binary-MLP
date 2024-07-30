`timescale 1ns / 1ps

module tb_rip_counter_16b;

  logic        clk;
  logic        rst;
  logic        en;
  logic [15:0] end_count;
  logic        fin;
  logic [15:0] cur_count;

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
    end_count = 49;

    #495;
    #1 end_count = 100;
  end


  rip_counter_16b time_counter(
    .clk(clk),
    .rst(rst),
    .en(en),
    .end_count(end_count),
    .fin(fin)
    //,.cur_count(cur_count)
  );

endmodule