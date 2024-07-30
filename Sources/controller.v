`timescale 1ns / 1ps

module controller(
  input  wire         clk,
  input  wire         rst,

  output reg [2:0]    layer,
  output reg          cu_rst,
  output reg          g_reg_rst7,

  output reg          rf_wen,
  output reg          rf_ren,
  output wire [6:0]   rf_waddr,
  output wire [6:0]   rf_raddr,
  output wire [6:0]   dmem_addr,
  output wire [12:0]  wmem_addr

  ,output wire [15:0] cur_time_count
);

  localparam time_bw_frame      = 4997; // 10ms
  localparam time_to_1st_frame  = 9;    // 42500 =85ms

  localparam addr_wmem_layer1   = 2879; // 0            + 48 * 60 - 1
  localparam addr_wmem_layer2   = 4319; // wmem_layer1  + 60 * 24
  localparam addr_wmem_layer3   = 4583; // wmem_layer2  + 24 * 11
  localparam addr_wmem_layer_o1 = 4594; // wmem_layer3  + 11
  localparam addr_wmem_layer_o2 = 4605; // wmem_layer3  + 11 * 2

  //localparam time_layer1_1 = 2992;
  localparam time_layer1   = 2997;
  localparam time_layer2   = 4485;
  localparam time_layer3   = 4771;
  localparam time_layer_o1 = 4784; 
  localparam time_layer_o2 = 4797;

  localparam end_rf_waddr_layer1   = 59;
  localparam end_rf_waddr_layer2   = 83;
  localparam end_rf_waddr_layer3   = 10;
  //localparam end_rf_waddr_layero

  localparam neutron_lin           = 48;
  localparam neutron_l1            = 60;
  localparam neutron_l2            = 24;
  localparam neutron_l3            = 11;

  /////////// LAYERS CONTROL ///////////
  reg                 start;
  reg                 layer1;
  reg                 layer2;
  reg                 layer3;
  reg                 layer_o1;
  reg                 layer_o2;
  reg                 layer_end;

  reg                 flag_1st_layer2;
  reg                 flag_1st_layer3;
  reg                 flag_1st_layero;

  /////////// COUNTERS ///////////
  reg                 flag_cu_rst;
  // Counter to generate clock for Regfile
  wire                rf_clk;
  reg                 rst_rf_clk;
  reg                 en_rf_clk;
  reg [6:0]           endcount_rf_clk;

  // Counter for write address in Regfile
  reg                 rst_rf_counter_waddr;
  reg                 en_rf_counter_waddr;
  reg  [6:0]          endcount_rf_counter_waddr;
  wire                fin_rf_counter_waddr;

  // Counter for read address in Regfile
  reg                 rst_rf_counter_raddr;
  reg                 en_rf_counter_raddr;
  reg  [6:0]          startcount_rf_counter_raddr;
  reg  [6:0]          endcount_rf_counter_raddr;
  wire                fin_rf_counter_raddr;

  // Counter for read address in DMEM
  reg                 rst_dmem_counter;
  reg                 en_dmem_counter;

  // Counter for read address in WMEM
  reg                 rst_wmem_counter;
  reg                 en_wmem_counter;
  wire                fin_wmem_counter;
  wire                fin_wmem_subcounter;
  //wire                wire_fin_wmem_counter; assign wire_fin_wmem_counter = fin_wmem_counter;
  reg  [12:0]         end_wmem_counter;
  wire [12:0]         wire_end_wmem_counter;
  assign              wire_end_wmem_counter = end_wmem_counter;
  reg  [12:0]         end_wmem_subcounter;
  wire [12:0]         wire_end_wmem_subcounter;
  assign              wire_end_wmem_subcounter = end_wmem_subcounter;

  // Counter for time between frames for DMEM
  reg                 rst_time_counter;
  reg                 en_time_counter;
  wire                fin_time_counter;
  reg [15:0]          wait_time;
  wire [15:0]         wire_wait_time;
  assign              wire_wait_time = wait_time;

  reg                 wait_for_1st_frame;

  /////////// SEQUENCIAL LOGIC ///////////
  always @(posedge clk) begin
    if (~rst) begin
      wait_for_1st_frame    <= 1;

      rst_rf_clk            <= 0;
      rst_rf_counter_waddr  <= 0;
      rst_rf_counter_raddr  <= 0;
      rst_dmem_counter      <= 0;
      rst_wmem_counter      <= 0;
      rst_time_counter      <= 0;

      en_rf_clk             <= 0;
      en_rf_counter_waddr   <= 0;
      en_rf_counter_raddr   <= 0;
      en_dmem_counter       <= 0;
      en_wmem_counter       <= 0;
      en_time_counter       <= 0;
      wait_time             <= time_to_1st_frame;

      endcount_rf_clk           <= 0;
      endcount_rf_counter_waddr <= 0;
      endcount_rf_counter_raddr <= 0;
      startcount_rf_counter_raddr<=0;

      flag_cu_rst           <= 0;
      cu_rst                <= 0;
      g_reg_rst7            <= 0;

      {start, layer1, layer2, layer3, layer_o1, layer_o2, layer_end} <= 0;
      layer                 <= 3'b000;

      rf_wen                <= 0;
      rf_ren                <= 0;
      //endcount_rf_counter_raddr <= 7'b1111111;
      //endcount_rf_counter_waddr <= 7'b1111111;
      

    // WAIT FOR DMEM TO BE LOADED WITH ALL 7 FRAMES, BEFORE WE COULD CLASSIFIY THE FIRST FRAME
    end else if (wait_for_1st_frame) begin
      rst_time_counter      <= 1;
      en_time_counter       <= 1;

      if (fin_time_counter) begin
        wait_for_1st_frame  <= 0;
        start               <= 1;
        //layer               <= 3'b001;
        rst_time_counter    <= 0;
      end


    end else if (start) begin
      rst_rf_clk            <= 1;
      rst_rf_counter_waddr  <= 1;
      rst_rf_counter_raddr  <= 1;
      rst_dmem_counter      <= 1;
      rst_wmem_counter      <= 1;
      rst_time_counter      <= 1;

      start                 <= 0;
      layer1                <= 1;
      layer                 <= 3'b001;

      en_dmem_counter       <= 1;
      en_wmem_counter       <= 1;

      end_wmem_subcounter   <= 1;
      end_wmem_counter      <= addr_wmem_layer1;
      end_wmem_subcounter   <= neutron_lin - 1;
      endcount_rf_counter_waddr   <= end_rf_waddr_layer1;

      en_time_counter       <= 1;
      wait_time             <= time_layer1;

      endcount_rf_clk       <= 49;


    // LAYER 1 CONVOLUTION STARTS
    end else if (layer1) begin  
      en_rf_clk             <= 1;
      en_rf_counter_waddr   <= 1;
      
      // layer 1 is ending
      if (fin_time_counter) begin
        en_dmem_counter   <= 0;
        rst_dmem_counter  <= 0;
        layer1            <= 0;
        layer2            <= 1;
          
        layer             <= 3'b000;
        g_reg_rst7        <= 0;

        rf_wen            <= 1;
        endcount_rf_counter_waddr <= end_rf_waddr_layer2;
        endcount_rf_counter_raddr <= end_rf_waddr_layer1;

        end_wmem_counter    <= addr_wmem_layer2;
        end_wmem_subcounter <= 2939;//end_wmem_subcounter + neutron_l2;
        wait_time           <= time_layer2;

        rst_rf_clk        <= 0;
        endcount_rf_clk   <= 0;
        
        flag_1st_layer2   <= 1;
        rf_ren            <= 1;

      // layer 1 is continuing
      end else begin
        // rf_wen is 1 after 48 cycles. repeat this 60 times
        if(rf_clk) begin
          rst_rf_clk          <= 0;
          endcount_rf_clk     <= 47; //48 cycles due to delay of reset
        end else
          rst_rf_clk  <= 1;

        // subcounter is for 1 batch of weight, wait a few cycles for store into RF
        if(fin_wmem_subcounter) begin
          end_wmem_subcounter <= end_wmem_subcounter + neutron_lin;
          flag_cu_rst         <= 1;
          rf_wen              <= 1;
        end else if(flag_cu_rst) begin
          flag_cu_rst         <= 0;
          cu_rst              <= 0;
          g_reg_rst7          <= 0;
          rf_wen              <= 0;
        end else if (~cu_rst) begin
          cu_rst              <= 1;
          g_reg_rst7          <= 1;
        end
      end


    end else if (layer2) begin
      flag_1st_layer2     <= 0;
      en_rf_counter_raddr <= 1;
      endcount_rf_counter_waddr   <= end_rf_waddr_layer2;

      // LAYER 2 IS ENDING
      if (fin_time_counter) begin
        layer2              <= 0;
        layer3              <= 1;

        g_reg_rst7          <= 0;
        rf_wen              <= 1;
        //endcount_rf_counter_waddr <= 7; //end_rf_waddr_layer3;
        endcount_rf_counter_raddr <= end_rf_waddr_layer2;

        end_wmem_counter    <= addr_wmem_layer3;
        end_wmem_subcounter <= 4343; //end_wmem_subcounter + neutron_l3;
        wait_time           <= time_layer3;

        rst_rf_clk        <= 0;
        endcount_rf_clk   <= 25;
        //rst_rf_counter_waddr <= 0;
        flag_1st_layer3   <= 1;
        startcount_rf_counter_raddr <= 60;

      // LAYER 2 IS CONTINUING
      end else begin

        // rf_wen is 1 after 48 cycles. repeat this 60 times
        if(rf_clk) begin
          rst_rf_clk          <= 0;
          endcount_rf_clk     <= 59; //60 cycles due to delay of reset
        end else begin
          rst_rf_clk  <= 1;
        end
        // subcounter is for 1 batch of weight, wait a few cycles for store into RF
        if(fin_wmem_subcounter) begin
          end_wmem_subcounter <= end_wmem_subcounter + neutron_l1;
          flag_cu_rst         <= 1;
          rf_wen              <= 1;
          rst_rf_counter_raddr<= 0;
        end else if(flag_cu_rst) begin
          flag_cu_rst         <= 0;
          cu_rst              <= 0;
          g_reg_rst7          <= 0;
          rf_wen              <= 0;
          rst_rf_counter_raddr<= 1;
        end else begin
          rf_wen              <= 0;
          if(~flag_1st_layer2) begin
            cu_rst              <= 1;
            g_reg_rst7          <= 1;
          end
        end
      end

    end else if (layer3) begin

      if (fin_time_counter) begin
        layer3              <= 0;
        layer_o1            <= 1;

        g_reg_rst7          <= 0;
        rf_wen              <= 1;

        en_rf_counter_waddr <= 0;
        startcount_rf_counter_raddr <= 0;
        rst_rf_counter_raddr<= 0;

        endcount_rf_counter_raddr <= end_rf_waddr_layer3;
        end_wmem_counter    <= addr_wmem_layer_o2;
        wait_time           <= time_layer_o1;
        end_wmem_subcounter <= 4594;

        flag_1st_layero   <= 1;

      end else begin

        // rf_wen is 1 after 23 cycles. repeat this 11 times
        if(rf_clk) begin
          rst_rf_clk          <= 0;
          endcount_rf_clk     <= 23; //24 cycles due to delay of reset
        end else begin 
          rst_rf_clk  <= 1;
        end
        // subcounter is for 1 batch of weight, wait a few cycles for store into RF
        if(fin_wmem_subcounter) begin
          end_wmem_subcounter <= end_wmem_subcounter + neutron_l2;
          flag_cu_rst         <= 1;
          rf_wen              <= 1;
          rst_rf_counter_raddr<= 0;
        end else if(flag_cu_rst) begin
          flag_cu_rst         <= 0;
          cu_rst              <= 0;
          g_reg_rst7          <= 0;
          rf_wen              <= 0;
          rst_rf_counter_raddr<= 1;
        end else begin
          if (~flag_1st_layer3) begin
            cu_rst              <= 1;
            g_reg_rst7          <= 1;
            rst_rf_counter_waddr<= 1;
          end else begin
            flag_1st_layer3     <= 0;
            rf_wen              <= 0;
            rst_rf_counter_waddr<= 0;
            endcount_rf_counter_waddr   <= end_rf_waddr_layer3;
          end
        end
      end

    end else if (layer_o1) begin
      rf_wen                <= 0;
      flag_1st_layero       <= 0;

      if (fin_time_counter) begin
        layer_o1            <= 0;
        layer_o2            <= 1;
        layer               <= 3'b010;
        wait_time           <= time_layer_o2;
        end_wmem_subcounter <= end_wmem_counter;

      end else begin

        if(~flag_1st_layero) begin
          g_reg_rst7        <= 1;
        end
        if (rf_raddr == 10) begin
          rst_rf_counter_raddr <= 0;
        end else begin
          rst_rf_counter_raddr <= 1;
        end
      end

    end else if (layer_o2) begin
      rst_rf_counter_raddr  <= 1;
      if (fin_time_counter) begin
        layer_o2            <= 0;
        layer_end           <= 1;
        rf_ren              <= 0;
        en_wmem_counter     <= 0;
        layer               <= 3'b100;
        wait_time           <= time_bw_frame;
      end

    end else if (layer_end) begin
        if (fin_time_counter) begin
          layer             <= 3'b000;
          start             <= 1;
          layer_end         <= 0;

          g_reg_rst7        <= 0;
          cu_rst            <= 0;
          rst_dmem_counter  <= 0;
          rst_wmem_counter  <= 0;
          rst_time_counter  <= 0;
          rst_rf_counter_raddr  <= 0;
          rst_rf_counter_waddr  <= 0;
          en_rf_counter_raddr   <= 0;

        end
    end
  end
  

  

  ////////// COUNTER LOGIC //////////
  rip_counter_7b rf_clock(
    .clk(clk),
    .rst(rst_rf_clk),
    .en(en_rf_clk),
    .end_count(endcount_rf_clk),
    .fin(rf_clk),
    .cur_count()
  );

  rip_counter_7b rf_waddr_gen(
    .clk(rf_clk),
    .rst(rst_rf_counter_waddr),
    .en(en_rf_counter_waddr),
    .end_count(endcount_rf_counter_waddr),
    .fin(),
    //.fin(fin_rf_counter_waddr),
    .cur_count(rf_waddr)
  );

  rip_counter_7b_v2 rf_raddr_gen(
    .clk(clk),
    .rst(rst_rf_counter_raddr),
    .en(en_rf_counter_raddr),
    .start_count(startcount_rf_counter_raddr),
    .end_count(endcount_rf_counter_raddr),
    .fin(),
    //.fin(fin_rf_counter_raddr),
    .cur_count(rf_raddr)
  );

  dmem_addr_gen dmem_addr_gen(
    .clk(clk),
    .rst(rst_dmem_counter),
    .en(en_dmem_counter),
    .dmem_addr(dmem_addr)
  );
  
  rip_counter_13b wmem_addr_gen(
    .clk(clk),
    .rst(rst_wmem_counter),
    .en(en_wmem_counter),
    .end_count(wire_end_wmem_counter),
    .end_sub_count(wire_end_wmem_subcounter),
    .fin(fin_wmem_counter),
    .fin_sub(fin_wmem_subcounter),
    .cur_count(wmem_addr)
  );

  rip_counter_16b global_time_counter (
    .clk(clk),
    .rst(rst_time_counter),
    .en(en_time_counter),
    .end_count(wire_wait_time),
    .fin(fin_time_counter)
    ,.cur_count(cur_time_count)
  );

endmodule
