`timescale 1ns / 1ps

module top_tb;
    localparam DATA_BIT = 8;            // number of data bits
    localparam CLOCK_TICK = 10;          // clock for tick (baud rate gen mod)
    localparam STOP_BIT_TICK = 16;      // bits for stop bit in rx/tx
    
    reg clock;
    reg reset;
    reg i_rx;
    wire o_tx;
    wire s_tick;
    wire clock_wizard;
    
    wire rx_done_tick;
    wire [DATA_BIT-1:0] o_data_tx;
    
    
    
    baud_rate_generator#(.CLOCK_TICK(CLOCK_TICK)) baud_rate_generator_mod (
        .clock(clock),
        .o_tick(s_tick)
        );
        
    top#(.DATA_BIT(DATA_BIT), .CLOCK_TICK(CLOCK_TICK), .STOP_BIT_TICK(STOP_BIT_TICK)) uut(
        .clock_50mhz(clock),
        .reset(reset),
        .i_rx(i_rx),
        .o_tx(o_tx),
        .clock_wizard(clock_wizard)
        );
        
    uart_rx#(.DATA_BIT(DATA_BIT), .STOP_BIT_TICK(STOP_BIT_TICK)) rx_test_mod(
        .clock(clock),
        .reset(reset),
        .rx(o_tx),
        .s_tick(s_tick),
        .rx_done_tick(rx_done_tick),
        .o_data(o_data_tx)
        );
        
        
    task uart_send_byte(input [7:0] byte);
        integer i;
        integer j;
        begin
            // Send start bit (low)
            for (j = 0; j < (16); j = j + 1) begin
                i_rx = 0;
                @(posedge s_tick);
            end
            // Send 8 data bits (LSB first)
            for (i = 0; i < DATA_BIT; i = i + 1) begin
                for (j = 0; j < (16); j = j + 1) begin
                    i_rx = byte[i];
                    @(posedge s_tick);
                end
            end   
            // Send stop bit (high)
            for (j = 0; j < (16); j = j + 1) begin
                i_rx = 1;
                @(posedge s_tick);
            end
         
        end
    endtask
    always #5 clock = ~clock;  // 10ns clock period
    
    integer i;
    integer j;
    reg [DATA_BIT-1:0] o_data_tx = 8'b00000000;
    reg [DATA_BIT-1:0] o_data_tx_aux = 8'b00000000; 
    
    initial begin
        clock = 0;
        i_rx = 1;
        reset = 1;
        #20;
        reset = 0;
        #50;
        
        uart_send_byte(8'b00000001);
        i_rx = 1;
        #100;
        uart_send_byte(8'b00000001);
        i_rx = 1;
        #100;
        uart_send_byte(8'b00100000);
               
        #50;
        #50;
        $finish;
    end
            
        
endmodule
