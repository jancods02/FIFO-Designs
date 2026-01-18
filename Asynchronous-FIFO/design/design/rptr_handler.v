`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 20:04:37
// Design Name: 
// Module Name: rptr_handler
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


module rptr_handler #(PTR_WIDTH=6)(
    input rclk, rst, r_en,
    input [PTR_WIDTH:0] wptr,
    output reg [PTR_WIDTH:0] b_rptr, g_rptr,
    output reg empty
    );
    reg [PTR_WIDTH:0] b_rptr_next;
    reg [PTR_WIDTH:0] g_rptr_next;
    reg wempty;
    always @(*) begin
        b_rptr_next = b_rptr +(r_en & !empty);
        g_rptr_next = (b_rptr_next >> 1)^b_rptr_next;
        wempty = (wptr == g_rptr_next);
    end
    always @(posedge rclk, negedge rst) begin
        if(!rst) begin
            b_rptr <= 0;
            g_rptr <= 0;
        end
        else begin 
            b_rptr <= b_rptr_next;
            g_rptr <= g_rptr_next;
        end
    end
    always @(posedge rclk, negedge rst) begin
        if(!rst) empty <= 0;
        else empty <= wempty ;
    end
endmodule
