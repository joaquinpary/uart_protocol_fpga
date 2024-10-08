`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2024 05:17:32 PM
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx
    #(
    parameter DATA_BIT = 8,
    parameter SB_TICK = 325
    )
    (
    input clock,
    input reset,
    input i_rx,
    input i_tick,
    output reg rx_done_tick,
    output [7:0] o_data
    );
    
    // symbolic state declaration
    localparam [1:0]
        idle    = 2'b00,
        start   = 2'b01,
        data    = 2'b10,
        stop    = 2'b11;
    
    // signal declaration
    reg [1:0] state_current, state_next; 
    reg [3:0] s_current, s_next;
    reg [2:0] n_current, n_next;
    reg [7:0] b_current, b_next;
    
    // body
    // FSMD state & data registers
    always @(posedge clock, posedge reset) begin
        if (reset) begin
            state_current <= idle;
            s_current <= 0;
            n_current <= 0;
            b_current <= 0;
        end
        else begin
            state_current <= state_next;
            s_current <= s_next;
            n_current <= n_next;
            b_current <= b_next;
        end         
    end
    
    // FSMD next-stage logic
    always @(*) begin
        state_next = state_current;
        rx_done_tick = 1'b0;
        s_next = s_current;
        n_next = n_current;
        b_next = b_current;
        case (state_current)
            idle: begin
                if (~i_rx) begin
                    state_next = start;
                    s_next = 0;
                end
            end
            start: begin
                if (i_tick) begin
                    if (s_current == 7) begin
                        state_next = data;
                        s_next = 0;
                        n_next = 0;
                    end
                    else
                        s_next = s_current + 1;
                end
            end
            data: begin
                if (i_tick) begin
                    if (s_current == 15) begin
                        s_next = 0;
                        
                        b_next = b_current >> 1;
                        b_next[7] = i_rx;
                        
                        if (n_current == (DATA_BIT-1))
                            state_next = stop;
                        else
                            n_next = n_current + 1;
                    
                    end
                    else
                        s_next = s_current + 1;
                end
            end
            stop: begin
                if (i_tick) begin
                    if (s_current == (SB_TICK - 1)) begin
                        state_next = idle;
                        rx_done_tick = 1'b1;
                    end
                    else
                        s_next = s_current + 1;
                end
            end
        endcase
    end
    
    assign o_data = b_current; 
endmodule
