`timescale 1ns / 1ps

module top#(
    parameter DATA_BIT = 8,
    parameter CLOCK_TICK = 325,
    parameter STOP_BIT_TICK = 16
    )
    (
    input clock,
    input reset,
    input i_rx,
    output o_tx,
    
    output rx_done,
    output [DATA_BIT-1:0] o_rx,
    output [DATA_BIT-1:0] o_data_a,
    output [DATA_BIT-1:0] o_data_b,
    output [DATA_BIT-1:0] o_data_op,
    output [DATA_BIT-1:0] o_alu_res,
    output o_tx_start,
    output [DATA_BIT-1:0] o_tx_data,
    output o_tx_done_tick
    );
    
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
    
    baud_rate_generator#(.CLOCK_TICK(CLOCK_TICK)) mod_baud_rate_generator(
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
    
    assign rx_done = rx_done_tick;
    assign o_rx = rx_data;
    
    assign o_data_a = data_a;
    assign o_data_b = data_b;
    assign o_data_op = data_op;
    assign o_alu_res = alu_res;
    assign o_tx_start = tx_start;
    assign o_tx_data = tx_data;
    assign o_tx_done_tick = tx_done_tick;
    
endmodule
