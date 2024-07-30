module mux_accum (
  input  wire             l1,
  input  wire [14:0]      accum1,
  input  wire [6:0]       accum2,

  output reg [14:0]       out
);

  always @(*) begin
    if (l1)
      out [14:0]      = accum1 [14:0];
    else 
      out [6:0]       = accum2 [6:0];
  end

endmodule