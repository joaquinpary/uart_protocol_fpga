`timescale 1ns / 1ps

module interface#(
    parameter DATA_BIT = 8
    )
    (
    input clock,
    input reset,
    input rx_empty,                     // RX_FIFO(empty) to INTERFACE
    input tx_empty,                     // TX_FIFO(empty) to INTERFACE
    input tx_full,                      // TX_FIFO(full) to INTERFACE
    input [DATA_BIT-1:0] fifo_rx,       // RX_FIFO(r_data) to INTERFACE
    input [DATA_BIT-1:0] alu_res,       // ALU(res) to INTERFACE
    output rx_rd,                       // RX_FIFO(rd) to INTERFACE
    output tx_wr,                       // TX_FIFO(wr) to INTERFACE
    output [DATA_BIT-1:0] tx_data,      // INTERFACE to TX_FIFO(w_data)
    output [DATA_BIT-1:0] data_a,       // INTERFACE to ALU(data_a)
    output [DATA_BIT-1:0] data_b,       // INTERFACE to ALU(data_b)
    output [DATA_BIT-1:0] data_op       // INTERFACE to ALU(data_op)
    );
    
    // symbolic state declaration
    localparam [2:0]
        idle        = 3'b000,
        state_a     = 3'b001,
        state_b     = 3'b010,
        state_op    = 3'b011,
        state_tx    = 3'b100;
        
    // signal declaration
    reg [2:0] state_current, state_next;
    reg [DATA_BIT-1:0] alu_res_reg;
    reg [DATA_BIT-1:0] data_a_reg, data_b_reg, data_op_reg;
    reg rx_rd_reg;
    reg tx_wr_reg;
     
    
    always @(posedge clock) begin
        if (reset) begin
            state_current <= idle;
            data_a_reg <= 0;
            data_b_reg <= 0;
            data_op_reg <= 0;
            alu_res_reg <= 0;
        end
        else begin
            state_current <= state_next;
            case (state_current)
                state_a: data_a_reg <= fifo_rx;
                state_b: data_b_reg <= fifo_rx;
                state_op: data_op_reg <= fifo_rx;
                state_tx: alu_res_reg <= alu_res;
            endcase
        end
    end
    
    always @(*) begin
        state_next = state_current;
        rx_rd_reg = 1'b0;
        tx_wr_reg = 1'b0;
        case(state_current)
            idle: begin
                if (~rx_empty) begin
                    state_next = state_a;
                end
            end
            state_a: begin
                if (~rx_empty) begin
                    rx_rd_reg = 1'b1;
                    state_next = state_b;
                end
            end
            state_b: begin
                if (~rx_empty) begin
                    rx_rd_reg = 1'b1;
                    state_next = state_op;
                end
            end
            state_op: begin
                if (~tx_full) begin
                    rx_rd_reg = 1'b1;
                    state_next = state_tx;
                end
            end
            state_tx: begin
                if (~tx_full) begin
                    tx_wr_reg = 1'b1;
                    state_next = idle;
                end
            end
        endcase
    end
    
    assign rx_rd = rx_rd_reg;
    assign tx_wr = tx_wr_reg;
    assign data_a = data_a_reg;
    assign data_b = data_b_reg;
    assign data_op = data_op_reg;
    assign tx_data = alu_res_reg;
    
endmodule
