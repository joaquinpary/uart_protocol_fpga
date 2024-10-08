`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 01:42:33 PM
// Design Name: 
// Module Name: baud_rate_generator_tb
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


module baud_rate_generator_tb;
    
    reg clock;
    integer i;
    
    wire o_tick;
    baud_rate_generator 
        #(
        .CLOCK_TICK(16)
        )
    uut
        (
        .clock(clock),
        .o_tick(o_tick)
        );
    
    initial begin
        for (i = 0; i <= (16*5); i = i + 1) begin
            clock = 1;
            #5;
            clock = 0;
            #5;
        end
    $finish;
    end
endmodule
