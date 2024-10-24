`timescale 1ns / 1ps

module baud_rate_generator
    #(
    parameter BAUD_RATE = 9600,
    parameter FREQ = 50E6
    )
    (
    input clock,
    output o_tick
    );
    
    localparam integer CLOCK_TICK = FREQ / (BAUD_RATE * 16);
    
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
