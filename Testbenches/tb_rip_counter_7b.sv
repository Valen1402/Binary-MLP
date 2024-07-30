`timescale 1ns / 1ps

module tb_rip_counter_7b;
  logic        clk;
  logic        rst;
  logic        en;
  logic [6:0]  end_count;
  logic        fin;
  logic [6:0]  cur_count;

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
    end_count = 59;

    #595;
    #1 end_count = 83;
  end


  rip_counter_7b rf_waddr_counter(
    .clk(clk),
    .rst(rst),
    .en(en),
    .end_count(end_count),
    .fin(fin),
    .cur_count(cur_count)
  );

endmodule