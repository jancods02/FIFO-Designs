`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 17:47:44
// Design Name: 
// Module Name: synchronizer
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


module synchronizer #(parameter WIDTH = 6) (input clk, rstn, [WIDTH:0] din, output reg [WIDTH:0] dout);
reg [WIDTH:0] q1;
always @(posedge clk) begin
    if(!rstn) begin
        q1 <= 0;
        dout <= 0;
    end
    else begin
        q1 <= din;
        dout <= q1;
    end
end
endmodule
