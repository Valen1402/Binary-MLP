`timescale 1ns / 1ps

module tb_DUT;
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
  logic [8:0]    dmem_data;
  logic [12:0]   wmem_addr;
  logic          wmem_data;

  logic [15:0]  cur_time_count;
  


  // COUMPUTING UNIT
  logic       rf_d1;
  logic       bin_class;

  //logic       tb_gated_clk;
  //logic [14:0] tb_g_reg_in, tb_accum1;
  logic [14:0] tb_gated_reg_q;
  //logic [6:0] tb_accum2;
  //logic [6:0] tb_adder7_A, tb_adder7_B;
  //logic       bin_class;

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

  compute_unit_top computing_unit_top1 (
    .clk(clk),
    .rst(rst),
    .layer(layer),
    .g_reg_rst7(g_reg_rst7),
    .rf_wen(rf_wen),
    .rf_ren(rf_ren),
    .rf_waddr(rf_waddr),
    .rf_raddr(rf_raddr),
    .d9(dmem_data),
    .w(wmem_data),
    .bin_class(bin_class),
    .rf_d1(rf_d1),
    .tb_gated_reg_q(tb_gated_reg_q)
    //.tb_g_reg_in(tb_g_reg_in),
    //.tb_accum1(tb_accum1),
    //.tb_accum2(tb_accum2),
    //.tb_gated_reg_q(tb_gated_reg_q),
    //.tb_gated_clk(tb_gated_clk),
    //.tb_adder7_A(tb_adder7_A),
    //.tb_adder7_B(tb_adder7_B)
  );

  controller controller1(
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

  wmem wmem1(
    .clk(clk),
    .rst(rst),
    .addr(wmem_addr),
    .data(wmem_data)
  );

  dmem dmem1(
    .clk(clk),
    .rst(rst),
    .addr(dmem_addr),
    .data(dmem_data)
  );

endmodule