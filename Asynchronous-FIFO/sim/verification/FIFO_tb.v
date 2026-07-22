`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026
// Design Name: 
// Module Name: tb_async_fifo
// Description: Verification for Write Freq (80MHz) > Read Freq (50MHz) 
//              with a burst size of 120. Configured for DEPTH=64, DATA_WIDTH=8.
//////////////////////////////////////////////////////////////////////////////////

module tb_async_fifo();

    // Parameters matching the top module defaults
    parameter DEPTH = 64; 
    parameter DATA_WIDTH = 8;

    // Testbench signals
    reg wclk;
    reg rclk;
    reg rst;
    reg w_en;
    reg r_en;
    reg [DATA_WIDTH-1:0] data_in;
    
    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;

    // Internal variables for behavioral verification
    reg [DATA_WIDTH-1:0] fifo_tracker [0:DEPTH-1]; 
    reg [$clog2(DEPTH)-1:0] wptr = 0; 

    // Instantiate the asynchronous_fifo top module
    asynchronous_fifo #(
        .DEPTH(DEPTH), 
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .wclk(wclk),
        .rclk(rclk),
        .rst(rst),
        .w_en(w_en),
        .r_en(r_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Generate Write Clock: 80 MHz = 12.5 ns period (6.25 ns half-period)
    initial begin
        wclk = 0;
        forever #6.25 wclk = ~wclk;
    end

    // Generate Read Clock: 50 MHz = 20.0 ns period (10.0 ns half-period)
    initial begin
        rclk = 0;
        forever #10.0 rclk = ~rclk;
    end

    initial begin
        // Initialize signals
        rst = 1;
        w_en = 0;
        r_en = 0;
        data_in = 0;
        #12.5 rst = 0;  
        #25.0 rst = 1;  
        #15; 
        
        // Burst Write operation: 120 items
        w_en <= 1;
        repeat (120) begin
            data_in = $random();           
            fifo_tracker[wptr] = data_in; 
            @(posedge wclk);
            wptr = (wptr + 1) % DEPTH; 
            
            while (full) @(posedge wclk); 
        end
        w_en <= 0; // Stop writing after burst
    end
    
    // Read operation (continuous reading as soon as data is available)
    initial begin
        #50; // Wait for reset and initial writes to propagate
        forever begin
            @(posedge rclk);
            if (!empty) begin
                r_en <= 1;
            end else begin
                r_en <= 0;
            end
        end    
    end

endmodule