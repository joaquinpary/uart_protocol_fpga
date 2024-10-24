`timescale 1ns / 1ps

module top#(
    parameter DATA_BIT = 8,
    parameter BAUD_RATE = 9600,
    parameter FREQ = 50E6,
    parameter STOP_BIT_TICK = 16
    )
    (
    input i_clock,
    input reset,
    input reset_cw,
    input i_rx,
    output o_tx,
    output reset_state,
    output reset_state_cw
    );
    
    wire clock;
    
    // BAUD RATE GENETERATE --- UART RX / UART TX
    wire s_tick;
    
    // UART_RX / UART_TX --- INTERFACE
    wire rx_done_tick;
    wire [DATA_BIT-1:0] rx_data; 
    wire tx_start;
    wire [DATA_BIT-1:0] tx_data;
    wire tx_done_tick;
  
    // INTERFACE --- ALU
    wire [DATA_BIT-1:0] alu_res;
    wire [DATA_BIT-1:0] data_a;
    wire [DATA_BIT-1:0] data_b;
    wire [DATA_BIT-1:0] data_op;
    
    reg reset_state_reg = 1'b0;
    reg reset_state_cw_reg = 1'b0;
    
    clk_wiz_0 instance_name(
        .clk_out1(clock),
        .reset(reset_cw),
        .clk_in1(i_clock)
        );
        
    baud_rate_generator#(.BAUD_RATE(BAUD_RATE), .FREQ(FREQ)) mod_baud_rate_generator(
        .clock(clock),
        .o_tick(s_tick)
        );
    
    uart_rx#(.DATA_BIT(DATA_BIT), .STOP_BIT_TICK(STOP_BIT_TICK)) mod_uart_rx(
        .clock(clock),
        .reset(reset),
        .rx(i_rx),
        .s_tick(s_tick),
        .rx_done_tick(rx_done_tick),
        .o_data(rx_data)
        );
    
    uart_tx#(.DATA_BIT(DATA_BIT), .STOP_BIT_TICK(STOP_BIT_TICK)) mod_uart_tx(
        .clock(clock),
        .reset(reset),
        .s_tick(s_tick),
        .tx_start(tx_start),
        .i_data(tx_data),
        .tx_done_tick(tx_done_tick),
        .tx(o_tx)
        );
     
    interface#(.DATA_BIT(DATA_BIT)) mod_interface(
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
    
    alu#(.DATA_BIT(DATA_BIT)) mod_alu(
        .i_data_a(data_a),
        .i_data_b(data_b),
        .i_op(data_op),
        .o_data(alu_res)
        );
    
    always@(posedge i_clock) begin
        if (reset)
            reset_state_reg = 1'b1;
        else
            reset_state_reg = 1'b0;
    end
    
    always@(posedge i_clock) begin
        if (reset_cw)
            reset_state_cw_reg = 1'b1;
        else
            reset_state_cw_reg = 1'b0;
    end
    
    assign reset_state = reset_state_reg;   
    assign reset_state_cw = reset_state_cw_reg;   
    
endmodule
