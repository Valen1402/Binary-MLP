module gated_clk (
  input  wire       clk,
  input  wire       l1,

  output wire       gated_clk
);

  wire              en;
  reg               q;

  assign en        = ~clk;
  assign gated_clk = clk & q;

  always @(en or l1) begin
    if (en)
      q            <= l1;
  end


endmodule