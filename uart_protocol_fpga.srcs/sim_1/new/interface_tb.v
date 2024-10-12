`timescale 1ns / 1ps

module interface_tb;
    localparam DATA_BIT = 8;
    localparam BUS = 3;
    
    //INTERFACE
    // Inputs
    reg clock;
    reg reset;
    wire rx_empty;
    wire tx_empty;
    wire tx_full;
    wire [DATA_BIT-1:0] fifo_rx;
    wire [DATA_BIT-1:0] alu_res;
    
    
    // Outputs
    wire tx_wr;
    wire rx_rd;
    wire [DATA_BIT-1:0] tx_data;
    wire [DATA_BIT-1:0] data_a;
    wire [DATA_BIT-1:0] data_b;
    wire [DATA_BIT-1:0] data_op;
    
    // FIFO_RX
    // Inputs and Outputs
    reg rx_wr;
    reg [DATA_BIT-1:0] rx_w_data;
    
    // FIFO_TX
    // Inputs and Outputs
    reg tx_rd;
    wire [DATA_BIT-1:0] tx_r_data;
    
    fifo_buffer#(.DATA_BIT(DATA_BIT), .BUS(BUS)) fifo_buffer_rx(
        .clock(clock),
        .reset(reset),
        .rd(rx_rd),
        .wr(rx_wr),
        .w_data(rx_w_data),
        .empty(rx_empty),
        .r_data(fifo_rx)
    );
    
    fifo_buffer#(.DATA_BIT(DATA_BIT), .BUS(BUS)) fifo_buffer_tx(
        .clock(clock),
        .reset(reset),
        .rd(tx_rd),
        .wr(tx_wr),
        .w_data(tx_data),
        .empty(tx_empty),
        .full(tx_full),
        .r_data(tx_r_data)
    );
    
    interface#(.DATA_BIT(DATA_BIT)) uut(
        .clock(clock),
        .reset(reset),
        .rx_empty(rx_empty),
        .tx_empty(tx_empty),
        .tx_full(tx_full),
        .fifo_rx(fifo_rx),
        .alu_res(alu_res),
        .rx_rd(rx_rd),
        .tx_wr(tx_wr),
        .tx_data(tx_data),
        .data_a(data_a),
        .data_b(data_b),
        .data_op(data_op)
    );
    
    // Task to write to FIFO RX
    task write_fifo_rx(input [DATA_BIT-1:0] data_in);
        begin
            @(posedge clock);
            rx_w_data = data_in;
            rx_wr = 1;
            @(posedge clock);
            rx_wr = 0;
        end
    endtask
    
    // Task to read from FIFO TX
    task read_fifo_tx;
        begin
            @(posedge clock);
            tx_rd = 1;
            @(posedge clock);
            tx_rd = 0;
        end
    endtask
    
    // Clock generation
    always #5 clock = ~clock; // Clock period = 10 ns
    
    initial begin
        // Initialize Inputs
        clock = 0;
        reset = 1;
        
        @(posedge clock);
        reset = 0;
       
        // RX FIFO   //WRITE
        rx_wr = 0;
        rx_w_data = 0;
        
        // TX FIFO   //READ
        tx_rd = 0;
        
        @(posedge clock);
         
        // Write data_a
        write_fifo_rx(8'b00000001);
        // Write data_b
        write_fifo_rx(8'b00000011);
        // Write data_op
        write_fifo_rx(8'b00100000);
        
                
        $finish;
    end
    // Monitoreo de señales
    initial begin
        $monitor("Time=%0t | rx_wr=%b | rx_rd=%b | tx_rd=%b | tx_wr=%b | fifo_rx=%b | tx_data=%b | data_a=%b | data_b=%b | data_op=%b",
                 $time, rx_wr, rx_rd, tx_rd, tx_wr, fifo_rx, tx_data, data_a, data_b, data_op);
    end
endmodule
