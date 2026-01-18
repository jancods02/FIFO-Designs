`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 20:12:58
// Design Name: 
// Module Name: FIFO_Memory
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


module FIFO_Memory #(parameter DEPTH = 64, DATA_WIDTH = 8, PTR_WIDTH = 8)(
    input wclk, w_en, rclk, r_en,
    input [PTR_WIDTH:0] b_wptr, b_rptr,
    input [DATA_WIDTH-1:0] din,
    input full, empty,
    output reg [DATA_WIDTH-1:0] dout
    );
    reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];
    always @(posedge wclk) begin
        if(w_en && !full) begin
            fifo[b_wptr[PTR_WIDTH-1:0]] <= din;
        end
    end
    always @(posedge rclk) begin
        if(r_en && !empty) 
            dout <= fifo[b_rptr[PTR_WIDTH-1:0]];
        else
            dout = {DATA_WIDTH{1'b0}};
    end
endmodule
