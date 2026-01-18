`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 20:22:27
// Design Name: 
// Module Name: FIFO_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module tb_async_fifo();

    parameter WIDTH = 4, DEPTH = 8;

    reg w_clk;
    reg r_clk;
    reg rst;
    reg wr_rq, rd_rq;
    wire full, empty;
    reg [WIDTH-1:0] wdata;
    wire [WIDTH-1:0] rdata;

    // Internal variables for FIFO verification
    reg [WIDTH-1:0] fifo [0:DEPTH-1]; // Verification FIFO
    reg [$clog2(DEPTH)-1:0] wptr = 0; // Write pointer
    reg [$clog2(DEPTH)-1:0] rptr = 0;  // Read pointer

    // Instantiate the FIFO top module
    asynchronous_fifo #(DEPTH, WIDTH)as_fifo (w_clk, r_clk, rst, wr_rq, rd_rq, wdata, rdata, full, empty);

    // Generate input clock (50 MHz = 20 ns period)
    initial begin
        w_clk = 0;
        forever #10 w_clk = ~w_clk;
    end

    initial begin
        r_clk = 0;
        forever #16.67 r_clk = ~r_clk;
    end

    initial begin
        rst = 1;
        wr_rq = 0;
        rd_rq = 0;
        wdata = 0;
        #10 rst = 0;  
        #20 rst = 1;  

        #13 wr_rq=1;
            repeat (150) begin
                @(posedge w_clk);
                if (!full) begin
                    wdata = $random();           
                    fifo[wptr] = wdata;     
                    wptr = (wptr + 1) % DEPTH; 
                end
                            
            end
       forever begin
        #10 rd_rq = 1;
        #20 rd_rq = 1;
       end    
    end
endmodule