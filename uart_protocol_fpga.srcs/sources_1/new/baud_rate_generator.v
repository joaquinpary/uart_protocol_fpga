`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2024 05:17:32 PM
// Design Name: 
// Module Name: baud_rate_generator
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


module baud_rate_generator
    #(
    CLOCK_TICK = 325   // Para 9600 baudios
    )
    (
    input clock,
    output o_tick
    );
    integer count = 0;
    reg tick;
    
    always @(posedge clock) begin
        if (count == (CLOCK_TICK-1)) begin
            count = 0;
            tick = 1;
        end
        else
            tick = 0;
        count = count + 1;
    end       
    
    assign o_tick = tick; 
endmodule
