`timescale 1ns / 1ps

module compute_unit_top(

  // global
  input  wire       clk,
  input  wire       rst,

  // layer control
  input  wire [2:0] layer,

  // gated reg control
  input  wire       g_reg_rst7,

  // regfile control
  input  wire       rf_wen,
  input  wire       rf_ren,
  input  wire [6:0] rf_waddr,
  input  wire [6:0] rf_raddr,

  // layer data
  input  wire [8:0] d9,
  input  wire       w,

  // output
  output wire        bin_class
  ,output wire      rf_d1
  ,output wire        tb_gated_clk
  ,output wire [14:0] tb_g_reg_in
  ,output wire [14:0] tb_accum1
  ,output wire [6:0]  tb_accum2
  ,output wire [14:0] tb_gated_reg_q
  ,output wire [6:0]  tb_adder7_A
  ,output wire [6:0]  tb_adder7_B
);

  wire   logic_0, logic_1;
  assign logic_0 = 1'b0;
  assign logic_1 = 1'b1;

  wire [14:0] gated_reg_q; assign tb_gated_reg_q = gated_reg_q;
  wire d1; assign rf_d1 = d1;

  wire   l1, lo2,  lend;
  assign {lend, lo2, l1} = layer;
  //assign l1 = layer[0];

  wire   gated_clk;         assign tb_gated_clk = gated_clk;
  gated_clk g_clk (
    .clk(clk),
    .l1(l1),
    .gated_clk(gated_clk)
  );

  wire [14:0] d9_ext, n_d9_ext;
  assign      d9_ext   = {6'b000000, d9};
  assign      n_d9_ext = -d9_ext;
  wire [14:0] adder15_A, adder15_B;

  assign adder15_A = gated_reg_q;

  mux_15b mux_15b (
    .sel(w),
    .in0(n_d9_ext),
    .in1(d9_ext),
    .out(adder15_B)
  );

  wire [14:0] accum1;             assign tb_accum1 = accum1;
  adder_15b adder_15b(
    .A(adder15_A),
    .B(adder15_B),
    .Cin(logic_0),
    .S(accum1),
    .overflow(overflow)
  );

  wire   mux_31_sel1, mux_31_sel2; 
  wire [1:0]  mux_31_in10, mux_31_in01, mux_31_in00;
  wire   xor_lo2_w;
  wire [6:0] adder7_A, adder7_B;

  assign xor_lo2_w   = lo2 ^ w;
  assign mux_31_sel1 = ~ xor_lo2_w & d1;
  assign mux_31_sel0 = xor_lo2_w & d1;
  assign mux_31_in10 = 2'b11;
  assign mux_31_in01 = 2'b01;
  assign mux_31_in00 = 2'b00;

  mux_31 mux_31 (
    .sel1   (mux_31_sel1),
    .sel0   (mux_31_sel0),
    .in10   (mux_31_in10),
    .in01   (mux_31_in01),
    .in00   (mux_31_in00),
    .out    (adder7_A[1:0])
  );
  assign adder7_A[6:2] = {adder7_A[1], adder7_A[1], adder7_A[1], adder7_A[1], adder7_A[1]};
  assign adder7_B = gated_reg_q[6:0];
  assign tb_adder7_A = adder15_A;
  assign tb_adder7_B = adder15_B;

  wire [6:0]  accum2;             assign tb_accum2 = accum2;
  adder_7b adder_7b(
    .A(adder7_A),
    .B(adder7_B),
    .Cin(logic_0),
    .S(accum2),
    .overflow(overflow)
  );

  wire [14:0] g_reg_in;     assign tb_g_reg_in = g_reg_in;
  mux_accum mux_accum (
    .l1(l1),
    .accum1(accum1),
    .accum2(accum2),
    .out(g_reg_in)
  );

  gated_reg g_reg (
    .clk(clk),
    .rst15(rst),
    .rst7(g_reg_rst7),
    .gated_clk(gated_clk),
    .din(g_reg_in),
    .dout(gated_reg_q)
  );


  wire   HS_in, HS_out;
  assign HS_out = ~HS_in;
  mux_1b mux_1b (
    .sel(l1),
    .in0(gated_reg_q[6]),
    .in1(gated_reg_q[14]),
    .out(HS_in)
  );

  regfile regfile(
    .rst(rst),
    .clk(clk),
    .wen(rf_wen),
    .ren(rf_ren),
    .waddr(rf_waddr),
    .raddr(rf_raddr),
    .wdata(HS_out),
    .rdata(d1)
  ); 

  mux_1b binary_class (
    .sel(lend),
    .in0(logic_0),
    .in1(gated_reg_q[6]),
    .out(bin_class)
  );

endmodule