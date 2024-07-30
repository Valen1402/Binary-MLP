`timescale 1ns / 1ps

module adder_7b(
  input  wire [6:0]      A,
  input  wire [6:0]      B,
  input  wire            Cin,
  output wire [6:0]      S,
  output wire            overflow
);

  wire [6:0]  C;
  wire        P, G;
  carryLA CLA5 (.A(A[2:0]), .B(B[2:0]), .Cin(Cin),  .Cout(C[2:0]), .S(S[2:0]));
  carryLA CLA6 (.A(A[5:3]), .B(B[5:3]), .Cin(C[2]), .Cout(C[5:3]), .S(S[5:3]));
  assign P = A[6] ^ B[6];
  assign S[6] = C[5] ^ P;
  assign G = A[6] & B[6];
  assign C[6] = (C[5] & P) | G;
  assign overflow = C[5] ^ C[6];

endmodule