module mux_1b (
  input  wire             sel,
  input  wire             in0,
  input  wire             in1,
  output wire             out
);

  assign out = sel? in1 : in0;

endmodule