`timescale 1ns / 1ps

module adder_15b(
  input  wire [14:0]      A,
  input  wire [14:0]      B,
  input  wire             Cin,
  output wire [14:0]      S,
  output wire             overflow
);

  wire [14:0] C;

  carryLA CLA0 (.A(A[2:0]),   .B(B[2:0]),   .Cin(Cin),   .Cout(C[2:0]),   .S(S[2:0]));
  carryLA CLA1 (.A(A[5:3]),   .B(B[5:3]),   .Cin(C[2]),  .Cout(C[5:3]),   .S(S[5:3]));
  carryLA CLA2 (.A(A[8:6]),   .B(B[8:6]),   .Cin(C[5]),  .Cout(C[8:6]),   .S(S[8:6]));
  carryLA CLA3 (.A(A[11:9]),  .B(B[11:9]),  .Cin(C[8]),  .Cout(C[11:9]),  .S(S[11:9]));
  carryLA CLA4 (.A(A[14:12]), .B(B[14:12]), .Cin(C[11]), .Cout(C[14:12]), .S(S[14:12]));

  assign overflow = C[13] ^ C[14];

endmodule