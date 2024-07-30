module mux_7b (
  input  wire             sel,
  input  wire [6:0]       in0,
  input  wire [6:0]       in1,
  output wire [6:0]       out
);

  assign out = sel? in1 : in0;

endmodule