`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 20:19:55
// Design Name: 
// Module Name: TOP
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


`include "synchronizer.v"
`include "wptr_handler.v"
`include "rptr_handler.v"
`include "FIFO_Memory.v"

module asynchronous_fifo #(parameter DEPTH=64, DATA_WIDTH=8) (
  input wclk,
  input rclk, rst,
  input w_en, r_en,
  input [DATA_WIDTH-1:0] data_in,
  output wire [DATA_WIDTH-1:0] data_out,
  output wire full, empty
);
  
  localparam PTR_WIDTH = $clog2(DEPTH);
 
  wire [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
  wire [PTR_WIDTH:0] b_wptr, b_rptr;
  wire [PTR_WIDTH:0] g_wptr, g_rptr;
  // wire [PTR_WIDTH-1:0] waddr, raddr;

  synchronizer #(PTR_WIDTH) sync_wptr (rclk, rst, g_wptr, g_wptr_sync); //write pointer to read clock domain
  synchronizer #(PTR_WIDTH) sync_rptr (wclk, rst, g_rptr, g_rptr_sync); //read pointer to write clock domain 
  wptr_handler #(PTR_WIDTH) wptr_h(wclk, rst, w_en,g_rptr_sync,b_wptr,g_wptr,full);
  rptr_handler #(PTR_WIDTH) rptr_h(rclk, rst, r_en,g_wptr_sync,b_rptr,g_rptr,empty);
// Explicitly pass parameters and map ports by name to prevent floating 'Z' bits
  FIFO_Memory #(
      .DEPTH(DEPTH),
      .DATA_WIDTH(DATA_WIDTH),
      .PTR_WIDTH(PTR_WIDTH) 
  ) fifom (
      .wclk(wclk), 
      .w_en(w_en), 
      .rclk(rclk), 
      .r_en(r_en),
      .b_wptr(b_wptr), 
      .b_rptr(b_rptr), 
      .din(data_in),
      .full(full),
      .empty(empty), 
      .dout(data_out)
  );
  
endmodule
