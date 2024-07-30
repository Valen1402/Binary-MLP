`timescale 1ns / 1ps

module tb_mux_31;

  // Inputs
  logic             sel0;
  logic             sel1;
  logic [6:0]       in10;
  logic [6:0]       in01;
  logic [6:0]       in00;

  // Outputs
  logic [6:0]       out;

  mux_31 mux_31(
    .sel1   (sel1),
    .sel0   (sel0),
    .in10   (in10),
    .in01   (in01),
    .in00   (in00),
    .out    (out )
  );

  initial begin
    in10 = 7'b1111111;
    in01 = 7'b0000001;
    in00 = 7'b0000000;
    #20;
    sel0 = 0; sel1 = 0;
    #20;
    sel0 = 1;
    #20;
    sel1 = 1;
    #20;
    sel0 = 0;
    #20;
    sel1 = 0;
    #20;
  end

endmodule