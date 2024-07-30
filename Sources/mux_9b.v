module mux_15b (
  input  wire             sel,
  input  wire [14:0]       in0,
  input  wire [14:0]       in1,
  output wire [14:0]       out
);

  assign out = sel? in1 : in0;

endmodule