`timescale 1ns / 1ps

module tb_mux_accum;

  // Inputs
  logic  l1;
  logic  [14:0] accum1;
  logic  [6:0]  accum2;

  // Outputs
  logic  [14:0] out;

  // Instantiate the module
  mux_accum uut (
    .l1(l1),
    .accum1(accum1),
    .accum2(accum2),
    .out(out)
  );


  // Initial block
  initial begin
    l1 = 1;
    accum1 = 15'b111111111111111;
    accum2 = 7'b1010101;

    #10; // Wait for a while

    // Check the output
    if (out != accum1)
      $fatal("Test case 1 failed");

    // Test case 2: Select accum2 when l1 is false
    l1 = 0;
    accum1 = 15'b111100001111000;
    accum2 = 7'b0101101;

    #10; // Wait for a while

    // Check the output
    if (out != { 8'b11111111 , accum2[6:0]})
      $fatal("Test case 2 failed");
    
    l1 = 1;
    accum1 = 15'b111111111111111;
    accum2 = 7'b0;

    #10; // Wait for a while
    // Check the output
    if (out != accum1)
      $fatal("Test case 1 failed");

  end

endmodule
