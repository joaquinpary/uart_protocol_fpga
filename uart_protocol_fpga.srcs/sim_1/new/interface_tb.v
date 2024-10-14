`timescale 1ns / 1ps

module interface_tb;

    // Parameters
    localparam DATA_BIT = 8;

    // Inputs
    reg clock;
    reg reset;
    reg [DATA_BIT-1:0] rx_data;
    reg rx_done_tick;
    reg tx_done_tick;
    reg [DATA_BIT-1:0] alu_res;

    // Outputs
    wire [DATA_BIT-1:0] tx_data;
    wire tx_start;
    wire [DATA_BIT-1:0] data_a;
    wire [DATA_BIT-1:0] data_b;
    wire [DATA_BIT-1:0] data_op;
    
    interface #(.DATA_BIT(DATA_BIT)) uut (
        .clock(clock),
        .reset(reset),
        .rx_data(rx_data),
        .rx_done_tick(rx_done_tick),
        .tx_done_tick(tx_done_tick),
        .alu_res(alu_res),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .data_a(data_a),
        .data_b(data_b),
        .data_op(data_op)
    );

    always #5 clock = ~clock;  // 10ns clock period

    initial begin
    // Initialize inputs
    clock = 0;
    reset = 1;
    rx_data = 0;
    rx_done_tick = 0;
    tx_done_tick = 0;
    alu_res = 0;

    // Reset the system
    #20;
    reset = 0;

    // data_a
    #10;
    rx_data = 8'hA5;       
    rx_done_tick = 1;
    #10;
    rx_done_tick = 0;
    
    #20;                  

    // data_b
    rx_data = 8'h5A;     
    rx_done_tick = 1;
    #10;
    rx_done_tick = 0;

    #20;                   

    // data_op
    rx_data = 8'hF0;  
    rx_done_tick = 1;
    #10;
    rx_done_tick = 0;

    #10;
    alu_res = 8'hFF;       // Set ALU result to FF
    #10;
    tx_done_tick = 1;
    #10;
    tx_done_tick = 0;

    // Finalizar la simulación
    #50;
    $finish;
end


endmodule
