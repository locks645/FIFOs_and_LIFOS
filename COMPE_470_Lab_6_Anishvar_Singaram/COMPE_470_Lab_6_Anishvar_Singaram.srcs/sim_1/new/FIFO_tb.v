`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2023 12:07:39 AM
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

// testing the FIFO module
module FIFO_tb();

    // module inputs and outputs
    reg        clk;
    reg        rst_n;
    reg        rd_req;
    reg        wr_req;
    reg  [3:0] wr_data;
    wire       full;
    wire       empty;
    wire       error;
    wire [3:0] rd_data;
    
    // inner module variables
    wire [3:0] stack [0:7];
    assign stack[0] = F00.stack[0]; 
    assign stack[1] = F00.stack[1];
    assign stack[2] = F00.stack[2];
    assign stack[3] = F00.stack[3];
    assign stack[4] = F00.stack[4];
    assign stack[5] = F00.stack[5];
    assign stack[6] = F00.stack[6];
    assign stack[7] = F00.stack[7];
    wire [2:0] rp;
    assign rp = F00.rp;
    wire [2:0] wp;
    assign wp = F00.wp;
    wire r_wrap;
    assign r_wrap = F00.r_wrap;
    wire w_wrap;
    assign w_wrap = F00.w_wrap;
    
    // instantiate test module
    FIFO 
         #(
           .WL    (4), 
           .DEPTH (8)
          ) 
      F00 (
           .clk        (clk),
           .rst_n      (rst_n),
           .rd_req     (rd_req),
           .wr_req     (wr_req),
           .wr_data    (wr_data),
           .full       (full),
           .empty      (empty),
           .error      (error),
           .rd_data    (rd_data)
          );
    
    // generate clk cycle
    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) clk = ~clk;
    
    initial begin
    
        // initalize inputs
        // assert rst_n
        clk = 1;
        rst_n = 0;
        rd_req = 0;
        wr_req = 0;
        wr_data = 0;
        
        repeat (2) @(posedge clk);
        
        // deassert rst_n
        rst_n <= 1;
    
    end
    
    initial begin
    
        // wait for rst_n
        @(rst_n);
        
        // pushing and popping variables
        @(posedge clk);
        wr_data <= 1; // push 1
        wr_req <= 1;
        rd_req <= 0;
        @(posedge clk);
        wr_data <= 2; // push 2
        wr_req <= 1;
        rd_req <= 0;
        @ (posedge clk);
        wr_data <= 4; // push 4
        wr_req <= 1;
        rd_req <= 0;
        @ (posedge clk);
        wr_data <= 5; // push 5
        wr_req <= 1;
        rd_req <= 0;
        @ (posedge clk);
        wr_data <= 7; // push 7
        wr_req <= 1;
        rd_req <= 0;
        @ (posedge clk);
        wr_data <= 4; // push 4
        wr_req <= 1;
        rd_req <= 0;
        @ (posedge clk);
        wr_data <= 0; // pop
        wr_req <= 0;
        rd_req <= 1;
        @ (posedge clk);
        wr_data <= 3; // push 3
        wr_req <= 1;
        rd_req <= 0;
        @ (posedge clk);
        wr_data <= 1; // push 1
        wr_req <= 1;
        rd_req <= 0;   
        @ (posedge clk);
        wr_data <= 0; // pop
        wr_req <= 0;
        rd_req <= 1;
        @ (posedge clk);
        wr_data <= 0; // pop
        wr_req <= 0;
        rd_req <= 1;
        @ (posedge clk);
        wr_data <= 0; // pop
        wr_req <= 0;
        rd_req <= 1;
        @ (posedge clk);
        wr_data <= 0; // pop
        wr_req <= 0;
        rd_req <= 1;
        @ (posedge clk);
        wr_data <= 0; // pop
        wr_req <= 0;
        rd_req <= 1;
        @ (posedge clk);
        wr_data <= 2; // push 2
        wr_req <= 1;
        rd_req <= 0;
        @(posedge clk);
        wr_data <= 0; // end pushes and pops
        wr_req <= 0;
        rd_req <= 0;
        
        repeat (10) @(posedge clk);
    
        // end waveform
        @(posedge clk);
        $finish;
    
    end
    
endmodule
