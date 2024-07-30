`timescale 1ns / 1ps

module tb_controller;
  logic          clk;
  logic          rst;
  logic [2:0]    layer;
  logic          cu_rst;
  logic          g_reg_rst7;
  logic          rf_wen;
  logic          rf_ren;
  logic [6:0]    rf_waddr;
  logic [6:0]    rf_raddr;
  logic [6:0]    dmem_addr;
  logic [12:0]   wmem_addr;
  logic          wmem_data;
  logic [8:0]    dmem_data;

  logic [15:0]  cur_time_count;

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
  end


  controller controller(
    .clk(clk),
    .rst(rst),
    .layer(layer),
    .cu_rst(cu_rst),
    .g_reg_rst7(g_reg_rst7),
    .rf_wen(rf_wen),
    .rf_ren(rf_ren),
    .rf_waddr(rf_waddr),
    .rf_raddr(rf_raddr),
    .dmem_addr(dmem_addr),
    .wmem_addr(wmem_addr)
    ,.cur_time_count(cur_time_count)
  );

  wmem wmem(
    .clk(clk),
    .rst(rst),
    .addr(wmem_addr),
    .data(wmem_data)
  );

  dmem dmem(
    .clk(clk),
    .rst(rst),
    .addr(dmem_addr),
    .data(dmem_data)
  );

endmodule