module gated_reg (
  input  wire             clk,
  input  wire             rst15,
  input  wire             rst7,
  input  wire             gated_clk,
  input  wire [14:0]      din,
  output reg  [14:0]      dout
);

  always @(posedge gated_clk or negedge rst7) begin
    if (~rst7)
      dout[14:7] <= 8'b0;
    else
      dout[14:7] <= din[14:7];
  end

  always @(posedge clk) begin
    if (~rst7) 
      dout[6:0]  <= 7'b0;
    else
      dout[6:0]  <= din[6:0];
  end

endmodule