module carryLA(	
	input  wire [2:0] A,
  input  wire [2:0] B,
	input  wire 			Cin,
	output wire [2:0] Cout,
	output wire [2:0] S
);
	
	wire   [2:0] P, G;
	
	assign P[0] = A[0] ^ B[0];
	assign G[0] = A[0] & B[0];
	
	assign P[1] = A[1] ^ B[1];
	assign G[1] = A[1] & B[1];
	
	assign P[2] = A[2] ^ B[2];
	assign G[2] = A[2] & B[2];
	
	assign Cout[0] = (Cin & P[0]) | G[0];
	assign Cout[1] = (Cin & P[0] & P[1]) | (G[0] & P[1]) | G[1];
	assign Cout[2] = (Cin & P[0] & P[1] & P[2]) | (G[0] & P[1] & P[2]) | (G[1] & P[2]) | G[2];
	
	assign S[0] = Cin ^ P[0];
	assign S[1] = Cout[0] ^ P[1];
	assign S[2] = Cout[1] ^ P[2];

endmodule