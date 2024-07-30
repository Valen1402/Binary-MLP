`timescale 1ns / 1ps

module tb_compute_unit_top;

  // global
  logic       clk;
  logic       rst;
  logic       tb_gated_clk;

  // layer control
  logic [2:0] layer;

  // gated reg control
  logic       g_reg_rst7;
  logic [14:0] tb_g_reg_in;
  logic [14:0] tb_accum1, tb_gated_reg_q;
  logic [6:0] tb_accum2;
  logic [6:0] tb_adder7_A, tb_adder7_B;

  // regfile control
  logic       rf_wen;
  logic       rf_ren;
  logic [6:0] rf_waddr;
  logic [6:0] rf_raddr;

  // layer data
  logic [8:0] d9;
  logic       w;
  logic       rf_d1;

  // output
  logic       bin_class;

  compute_unit_top computing_unit_top (
    .clk(clk),
    .rst(rst),
    .layer(layer),
    .g_reg_rst7(g_reg_rst7),
    .rf_wen(rf_wen),
    .rf_ren(rf_ren),
    .rf_waddr(rf_waddr),
    .rf_raddr(rf_raddr),
    .d9(d9),
    .w(w),
    .bin_class(bin_class),
    .rf_d1(rf_d1),
    .tb_g_reg_in(tb_g_reg_in),
    .tb_accum1(tb_accum1),
    .tb_accum2(tb_accum2),
    .tb_gated_reg_q(tb_gated_reg_q),
    .tb_gated_clk(tb_gated_clk),
    .tb_adder7_A(tb_adder7_A),
    .tb_adder7_B(tb_adder7_B)
  );

  initial begin
    #5;
    clk               = 1'b1;
    fork
      forever #5  clk = ~clk;
    join
  end

  integer i;

  // Initial block
  initial begin
    rst         = 0;
    g_reg_rst7  = 0;
    layer       = 3'b0;


    /////// FIRST LAYER ///////
    #5;
    layer       = 3'b1;
    #5;
    //rst         = 1;
    g_reg_rst7  = 1;
    d9          = 9'b0000000;
    w           = 1;
    #10;
    rst         = 1;
    g_reg_rst7  = 1;

    for (i=0; i< 30; i++) begin
      #10;
      d9        = 9'b1;
    end
    rf_wen      = 1;
    rf_waddr    = 0;
    #10;
    rst         = 0; g_reg_rst7 = 0;
    rf_wen      = 0;
    #10 rst     = 1; g_reg_rst7 = 1;
    w = 0;
    for (i=0; i< 30; i++) begin
      #10;
      d9        = 9'b1;
    end
    rf_wen      = 1;
    rf_waddr    = 1;

    /////// TRANSITION //////
    #10;
    rf_wen      = 0;
    rf_waddr    = 0;

    /////// SECOND LAYER ///////
    #5;
    layer       = 3'b000;
    g_reg_rst7  = 0;
    rf_ren      = 1;
    rf_raddr    = 0;

    #10;
    g_reg_rst7  = 1;
    rf_wen      = 1;
    rf_waddr    = 2;
    
    #200;
    rf_raddr    = 1;
    rf_waddr    = 3;
    #200

    /////// TRANSITION ///////
    #10;
    rf_wen      = 0;
    rf_waddr    = 0;

    /////// OUTPUT LAYER ///////
    g_reg_rst7  = 0;
    layer       = 3'b000;
    rf_raddr    = 2;

    #10;
    g_reg_rst7  = 1;
    #30;
    layer       = 3'b010;
    rf_raddr    = 3;
    #40;
    layer       = 3'b100;
    rf_ren      = 0;
    rf_raddr    = 0;


  end


endmodule