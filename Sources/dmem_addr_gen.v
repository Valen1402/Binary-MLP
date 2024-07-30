`timescale 1ns / 1ps

// seq: 0 3 6, 1 4 0, 2 5 1, 3 6 2, 4 0 3, 5 1 4, 6 2 5, 0 3 6, ...

module dmem_addr_gen(
  input                  clk,
  input                  rst,
  input                  en,
  output reg  [6:0]      dmem_addr

  //,output reg [2:0]     nxt_start_block
  //,output reg [2:0]     nxt_sub_block
);

  reg [2:0]     start_block;
  reg [2:0]     sub_block;
  reg [2:0]     nxt_start_block;
  reg [2:0]     nxt_sub_block;

  reg [1:0]     sub_block_counter;
  reg [3:0]     in_sub_block_counter;

  reg [1:0]     wait_bw_block;

  always @(*) begin
    dmem_addr   = (sub_block<<4) + in_sub_block_counter;

    case(sub_block)
      3'b000: nxt_sub_block   = 3'b011;
      3'b001: nxt_sub_block   = 3'b100;
      3'b010: nxt_sub_block   = 3'b101;
      3'b011: nxt_sub_block   = 3'b110;
      3'b100: nxt_sub_block   = 3'b000;
      3'b101: nxt_sub_block   = 3'b001;
      3'b110: nxt_sub_block   = 3'b010;
    endcase

    case(start_block)
      3'b000: nxt_start_block = 3'b001;
      3'b001: nxt_start_block = 3'b010;
      3'b010: nxt_start_block = 3'b011;
      3'b011: nxt_start_block = 3'b100;
      3'b100: nxt_start_block = 3'b101;
      3'b101: nxt_start_block = 3'b110;
      3'b110: nxt_start_block = 3'b000;
    endcase
  end

  always @(posedge clk) begin
    if(~rst) begin
      start_block           <= 0;
      sub_block             <= 0;
      sub_block_counter     <= 0;
      in_sub_block_counter  <= 0;
      wait_bw_block         <= 0;

    end else if (en) begin
      if (wait_bw_block) begin
        wait_bw_block       <= wait_bw_block + 1;
        if(wait_bw_block[0] & wait_bw_block[1]) begin
          start_block           <= nxt_start_block;
          sub_block             <= nxt_start_block;
          sub_block_counter     <= 0;
          in_sub_block_counter  <= 0;
        end

      end else begin 
        //in_sub_block_counter      <= in_sub_block_counter + 1;
        if (in_sub_block_counter == 4'b1111) begin
          if (sub_block_counter == 2'b10) begin
            wait_bw_block         <= 2;
          end else begin
            in_sub_block_counter  <= in_sub_block_counter + 1;
            sub_block_counter     <= sub_block_counter + 1;
            sub_block             <= nxt_sub_block;
          end

        end else 
          in_sub_block_counter    <= in_sub_block_counter + 1;
      end
    end
    
  end

endmodule