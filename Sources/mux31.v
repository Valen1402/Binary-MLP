module mux_31 (
  input  wire             sel1,
  input  wire             sel0,
  input  wire [1:0]       in10,
  input  wire [1:0]       in01,
  input  wire [1:0]       in00,
  output wire [1:0]       out
);

  assign out = sel1? in10 : (sel0? in01: in00);

endmodule