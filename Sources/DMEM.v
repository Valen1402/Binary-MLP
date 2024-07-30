module dmem(
  input  wire         clk,
  input  wire         rst,
  input  wire [6:0]   addr,

  output reg [8:0]    data
);

  reg [1007:0]           mem; // 7 x 16 x 9

  integer i;
  always @(posedge clk) begin
    if(~rst) begin
      for (i=0; i<1008; i=i+9*4) begin
        {mem[i+8], mem[i+7], mem[i+6], mem[i+5], mem[i+4], mem[i+3], mem[i+2], mem[i+1], mem[i]}  <= 1;
      end
      for (i=9; i<1008; i=i+9*4) begin
        {mem[i+8], mem[i+7], mem[i+6], mem[i+5], mem[i+4], mem[i+3], mem[i+2], mem[i+1], mem[i]}  <= 1;
      end
      for (i=18; i<1008; i=i+9*4) begin
        {mem[i+8], mem[i+7], mem[i+6], mem[i+5], mem[i+4], mem[i+3], mem[i+2], mem[i+1], mem[i]}  <= 0;
      end
      for (i=27; i<1008; i=i+9*4) begin
        {mem[i+8], mem[i+7], mem[i+6], mem[i+5], mem[i+4], mem[i+3], mem[i+2], mem[i+1], mem[i]}  <= 0;
      end
    end else
      data <= {mem[(addr*9+8)], mem[(addr*9+7)], mem[(addr*9+6)], mem[(addr*9+5)], mem[(addr*9+4)], mem[(addr*9+3)], mem[(addr*9+2)], mem[(addr*9+1)], mem[(addr*9)]};
  end
endmodule