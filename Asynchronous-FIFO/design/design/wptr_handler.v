`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 19:48:15
// Design Name: 
// Module Name: wptr_handler
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


module wptr_handler #(parameter PTR_WIDTH=6)(
    input wclk, rst, w_en,
    input [PTR_WIDTH:0] r_ptr,
    output reg [PTR_WIDTH:0] b_wptr, g_wptr,
    output reg full
    );
    reg [PTR_WIDTH:0] b_wptr_next, g_wptr_next;
    reg wfull;
  
    always @(posedge wclk, negedge rst) begin
        if(!rst) begin
            b_wptr <= 0;
            g_wptr <= 0;
        end
        else begin
            
            b_wptr <= b_wptr_next;
            g_wptr <= g_wptr_next;
        end
    end
    always @(posedge wclk, negedge rst) begin
        if(!rst) 
            full <= 0;
        else 
            full <= wfull;
    end
    always @(*) begin
        b_wptr_next = b_wptr + (w_en & !full);
        g_wptr_next = (b_wptr_next >> 1) ^ (b_wptr_next);
        wfull = (g_wptr_next == {~r_ptr[PTR_WIDTH:PTR_WIDTH-1], r_ptr[PTR_WIDTH-2:0]});
    end
endmodule
