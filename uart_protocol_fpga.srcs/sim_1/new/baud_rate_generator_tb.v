`timescale 1ns / 1ps

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
