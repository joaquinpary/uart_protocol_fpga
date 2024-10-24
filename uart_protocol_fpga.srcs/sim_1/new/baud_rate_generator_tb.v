`timescale 1ns / 1ps

module baud_rate_generator_tb;
    reg clock;
    integer i;
    
    wire o_tick;

    localparam BAUD_RATE = 9600;
    localparam FREQ = 50E6;
        
    baud_rate_generator 
        #(
        .BAUD_RATE(BAUD_RATE),
        .FREQ(FREQ)
        )
    uut
        (
        .clock(clock),
        .o_tick(o_tick)
        );
    
    initial begin
        for (i = 0; i <= (500); i = i + 1) begin
            clock = 1;
            #10;
            clock = 0;
            #10;
        end
    $finish;
    end
endmodule
