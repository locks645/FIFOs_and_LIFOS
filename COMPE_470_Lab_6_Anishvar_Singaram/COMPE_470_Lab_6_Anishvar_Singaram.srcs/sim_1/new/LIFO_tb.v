`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2023 06:58:23 PM
// Design Name: 
// Module Name: LIFO_tb
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

// testing the LIFO module
module LIFO_tb();

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
    assign stack[0] = L00.stack[0]; 
    assign stack[1] = L00.stack[1];
    assign stack[2] = L00.stack[2];
    assign stack[3] = L00.stack[3];
    assign stack[4] = L00.stack[4];
    assign stack[5] = L00.stack[5];
    assign stack[6] = L00.stack[6];
    assign stack[7] = L00.stack[7];
    wire [2:0] sp;
    assign sp = L00.sp;
    
    // instantiate test module
    LIFO 
         #(
           .WL         (4),
           .DEPTH      (8)
          )
      L00 (
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
    
        //wait for rst_n
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
