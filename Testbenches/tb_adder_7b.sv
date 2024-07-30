`timescale 1ns / 1ps

module tb_adder_7b;

  // Inputs
  logic  [6:0]      A;
  logic  [6:0]      B;

  // Outputs
  logic  [6:0]      S;
  logic              overflow;

  adder_7b adder_7b (
    .A(A),
    .B(B),
    .Cin(0),
    .S(S),
    .overflow(overflow)
  );

  initial begin
    #5;
    A = 15'b0001010; // 10
    B = 15'b0010100; // 20

    #10;
    A = 15'b1110110; //-10
    B = 15'b0110010; // 50

    #10;
    A = 15'b1000100; //-60
    B = 15'b0101011; // 43

    #10;
    A = 15'b1100000; //-32
    B = 15'b1001101; //-51

    #10;
    A = 15'b1110011; // -13
    B = 15'b1101000; // -24

    #10;
    A = 15'b0101000; // 40
    B = 15'b0110010; // 50

    #10;
    B = 15'b0111000; // 56
    A = 15'b0; // 0

  end


endmodule