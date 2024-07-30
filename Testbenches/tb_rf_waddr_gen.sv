`timescale 1ns / 1ps

module tb_rf_waddr_gen;
  logic        clk;
  logic        rst;
  logic        en;
  logic [6:0]  endcount_rf_clk;
  logic [6:0]  endcount_rf_counter_waddr;
  logic        fin;
  logic [6:0]  rf_waddr;
  logic        rf_clk;

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
    endcount_rf_clk = 48;
    endcount_rf_counter_waddr = 60;
  end


  rip_counter_7b rf_clock(
    .clk(clk),
    .rst(rst),
    .en(en),
    .end_count(endcount_rf_clk),
    .fin(rf_clk),
    .cur_count()
  );

  rip_counter_7b rf_waddr_gen(
    .clk(rf_clk),
    .rst(rst),
    .en(en),
    .end_count(endcount_rf_counter_waddr),
    .fin(),
    .cur_count(rf_waddr)
  );

/*  rip_counter_7b rf_waddr_counter(
    .clk(clk),
    .rst(rst),
    .en(en),
    .end_count(end_count),
    .fin(fin),
    .cur_count(cur_count)
  );
*/
endmodule