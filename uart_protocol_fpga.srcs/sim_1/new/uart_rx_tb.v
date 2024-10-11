`timescale 1ns / 1ps

module uart_rx_tb;
    
    // Parameters
    localparam DATA_BIT = 8;
    localparam CLOCK_TICK = 6;  //325 = 9600 baudios
    localparam CLOCK_PERIOD = 10;
    
    // Inputs
    reg clock, reset;
    reg rx;
    
    // Outputs
    wire rx_done_tick;
    wire [7:0] o_data;
    
    // Tick
    wire s_tick;
    
    // Instantiate
    baud_rate_generator #(.CLOCK_TICK(CLOCK_TICK)) baud_gen (
        .clock(clock),
        .o_tick(s_tick)
        );
    
    uart_rx #(.DATA_BIT(DATA_BIT), .CLOCK_TICK(CLOCK_TICK)) uut (
        .clock(clock),
        .reset(reset),
        .rx(rx),
        .s_tick(s_tick),
        .rx_done_tick(rx_done_tick),
        .o_data(o_data)
        );
    
    // Clock generation
    always #5 clock = ~clock; // Clock period = 10 ns
    
    task uart_send_byte(input [7:0] byte);
        integer i;
        integer j;
        begin
            // Send start bit (low)
            for (j = 0; j < 16; j = j + 1) begin
                rx = 0;
                @(posedge s_tick);
            end
            // Send 8 data bits (LSB first)
            for (i = 0; i < DATA_BIT; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    rx = byte[i];
                    @(posedge s_tick);
                end
            end
            
            // Send stop bit (high)
            rx = 1;
            @(posedge s_tick);
        end
    endtask
               
    initial begin
        // Initialize inputs
        clock = 0;
        reset = 1;
        rx = 1;   // Idle
        
        // Reset
        # (2 * CLOCK_PERIOD);
        reset = 0;
        
        // Wait for a few clock cycles before starting the test
        # (10 * CLOCK_PERIOD);
        
        // Send a byte
        $display("Send 0xA5");
        uart_send_byte(8'hA5); // 
        
        // Wait reception
        @(posedge rx_done_tick);
        $display("Received byte: %h", o_data);
        
        
        $finish;
    end  
endmodule
