module regfile(
  input  wire         rst,
  input  wire         clk,
  input  wire         wen,
  input  wire         ren,
  input  wire [6:0]   waddr,
  input  wire [6:0]   raddr,
  input  wire         wdata,
  output reg          rdata
);
  
  reg [83:0]          mem;

  always @(posedge clk) begin
      if(~rst) begin
          mem[83:0]   <= 84'b0;

      end else begin
        if (wen)
          mem[waddr]  <= wdata;
        if (ren)
          rdata       <= mem[raddr];
      end
  end

endmodule