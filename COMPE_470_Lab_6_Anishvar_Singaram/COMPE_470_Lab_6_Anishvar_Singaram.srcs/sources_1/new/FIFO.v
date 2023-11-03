// `timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2023 02:20:05 PM
// Design Name: 
// Module Name: FIFO
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

// parameterized, circular, read-first stack
// synchronous, active-low rst_n
module FIFO #(
              parameter    WL = 4,
              parameter DEPTH = 8
             )
             (
              input  wire          clk,
              input  wire          rst_n,
              input  wire          rd_req,
              input  wire          wr_req,
              input  wire [WL-1:0] wr_data,
              output wire          full,
              output wire          empty,
              output wire          error,
              output reg  [WL-1:0] rd_data
             );
    
    // for-loop variables
    integer i;
    
    // inner module variables
    reg r_wrap;
    reg w_wrap;
    reg [($clog2(DEPTH))-1:0] rp;
    reg [($clog2(DEPTH))-1:0] wp;
    reg [WL-1:0] stack [0:DEPTH-1];
    
    // full and empty combinational logic
    assign full = ( (rp == wp) && (r_wrap != w_wrap) ) ? 1'b1 : 1'b0;
    assign empty = ( (rp == wp) && (r_wrap == w_wrap) ) ? 1'b1 : 1'b0;
    
    // error combinational logic
    assign error = (empty == 1 && rd_data == 1) ? 1'b1 : 1'b0;
    assign error = (full == 1 && wr_data == 1) ? 1'b1 : 1'b0;

    // reading and writing sequential logic
    always @(posedge clk) begin
    
        // take if rst_n is active
        if (rst_n == 0) begin 
                
                rp <= 0;
                wp <= 0;
                r_wrap <= 0;
                w_wrap <= 0;
                rd_data <= 0;
            
                // initallize stack with 0's
                for (i = 0; i < DEPTH; i = i+1) begin 
                    stack[i] <= 0;
                end
            
        end
            
        // take if rst_n isn't active
        else begin
            
            // read and write only if error isn't active
            if (error == 0) begin
            
                // reading from the stack
                if (rd_req == 1) begin
                    
                    // special condition for circular read
                    if (rp == DEPTH-1) begin
                        rd_data <= stack[rp];
                        rp <= 0;    
                        stack[rp] <= 0;
                        r_wrap <= !(r_wrap);
                    end 
                    else begin
                        rd_data <= stack[rp];
                        rp <= rp+1;
                        stack[rp] <= 0;
                    end

                end

                // writing to the stack
                if (wr_req == 1) begin
                
                    // special condition for circular write
                    if (wp == DEPTH-1) begin
                        stack[wp] <= wr_data;
                        wp <= 0;
                        w_wrap <= !(w_wrap);
                    end
                    else begin
                        stack[wp] <= wr_data;
                        wp <= wp+1;
                    end
                    
                end
                            
            end
            
        end
    
    end

endmodule
