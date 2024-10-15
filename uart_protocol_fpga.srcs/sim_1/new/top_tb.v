`timescale 1ns / 1ps

module top_tb;
    localparam DATA_BIT = 8;
    localparam CLOCK_TICK = 16;
    
    reg clock;
    reg reset;
    reg i_rx;
    wire o_tx;
    wire rx_done;
    wire [DATA_BIT-1:0] o_rx;
    
    top#(.DATA_BIT(DATA_BIT), .CLOCK_TICK(CLOCK_TICK)) uut(
        .clock(clock),
        .reset(reset),
        .i_rx(i_rx),
        .o_tx(o_tx),
        .rx_done(rx_done),
        .o_rx(o_rx)
        );
        
    task uart_send_byte(input [7:0] byte);
        integer i;
        integer j;
        begin
            // Send start bit (low)
            for (j = 0; j < (CLOCK_TICK*16); j = j + 1) begin
                i_rx = 0;
                @(posedge clock);
            end
            // Send 8 data bits (LSB first)
            for (i = 0; i < DATA_BIT; i = i + 1) begin
                for (j = 0; j < (CLOCK_TICK*16); j = j + 1) begin
                    i_rx = byte[i];
                    @(posedge clock);
                end
            end   
            // Send stop bit (high)
            for (j = 0; j < (CLOCK_TICK*32); j = j + 1) begin
                i_rx = 1;
                @(posedge clock);
            end
         
        end
    endtask
    always #5 clock = ~clock;  // 10ns clock period

    initial begin
        clock = 0;
        i_rx = 1;
        reset = 1;
        #20;
        reset = 0;
        #50;
        
        uart_send_byte(8'b00000001);
        uart_send_byte(8'b00000001);
        uart_send_byte(8'b00100000);
        
        #50;
        #50;
        $finish;
    end
            
        
endmodule
