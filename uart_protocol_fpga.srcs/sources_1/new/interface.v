`timescale 1ns / 1ps

module interface#(
    parameter DATA_BIT = 8
    )
    (
    input clock,
    input reset,
    input [DATA_BIT-1:0] rx_data,
    input rx_done_tick,
    input tx_done_tick,
    input [DATA_BIT-1:0] alu_res,
    output [DATA_BIT-1:0] tx_data,
    output tx_start,
    output [DATA_BIT-1:0] data_a,
    output [DATA_BIT-1:0] data_b,
    output [DATA_BIT-1:0] data_op
    );
    
    // symbolic state declaration
    localparam [1:0]
        state_a     = 2'b00,
        state_b     = 2'b01,
        state_op    = 2'b10,
        state_tx    = 2'b11;
        
    // signal declaration
    reg [1:0] state_current, state_next;
    reg [DATA_BIT-1:0] alu_res_current, alu_res_next;
    reg [DATA_BIT-1:0] data_a_current, data_b_current, data_op_current;
    reg [DATA_BIT-1:0] data_a_next, data_b_next, data_op_next;
    reg tx_start_current, tx_start_next;
    
    always @(posedge clock) begin
        if (reset) begin
            state_current <= state_a;
            data_a_current <= 0;
            data_b_current <= 0;
            data_op_current <= 0;
            alu_res_current <= 0;
            tx_start_current <= 1'b0;
        end
        else begin
            state_current <= state_next;
            data_a_current <= data_a_next;
            data_b_current <= data_b_next;
            data_op_current <= data_op_next;
            alu_res_current <= alu_res_next;
            tx_start_current <= tx_start_next;
        end
    end
    
    always @(*) begin
        state_next = state_current;
        data_a_next = data_a_current;
        data_b_next = data_b_current;
        data_op_next = data_op_current;
        alu_res_next = alu_res_current;
        tx_start_next = 1'b0;
        case(state_current)
            state_a: begin
                if (rx_done_tick) begin
                    data_a_next = rx_data;
                    state_next = state_b;
                end
            end
            state_b: begin
                if (rx_done_tick) begin
                    data_b_next = rx_data;
                    state_next = state_op;
                end
            end
            state_op: begin
                if (rx_done_tick) begin
                    data_op_next = rx_data;
                    state_next = state_tx;
                end
            end
            state_tx: begin
                alu_res_next = alu_res;
                state_next = state_a;
                tx_start_next = 1'b1;
            end
        endcase
    end
    
    assign data_a = data_a_current;
    assign data_b = data_b_current;
    assign data_op = data_op_current;
    assign tx_data = alu_res_current;
    assign tx_start = tx_start_current;
    
endmodule
