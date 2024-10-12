module fifo_buffer
    #(
    parameter DATA_BIT = 8,
    parameter BUS = 2
    )
    (
    input clock, reset,
    input rd, wr,
    input [DATA_BIT-1:0] w_data,
    output empty, full,
    output [DATA_BIT-1:0] r_data
    );
    
    reg [DATA_BIT-1:0] array_reg [2**BUS-1:0];
    reg [BUS-1:0] w_ptr_reg, w_ptr_next, w_ptr_succ;
    reg [BUS-1:0] r_ptr_reg, r_ptr_next, r_ptr_succ;
    reg full_reg, empty_reg, full_next, empty_next;
    
    wire wr_en;
    
    // register file write operation
    always @(posedge clock) begin
        if (wr_en)
            array_reg[w_ptr_reg] <= w_data;
    end
    // register file read operation
    assign r_data = array_reg[r_ptr_reg];
    // write enabled only when FIFO is not full
    assign wr_en = wr & ~full_reg;
    
    // fifo control log
    // register for read and write pointers
    always @(posedge clock) begin
        if (reset) begin
            w_ptr_reg <= 0;
            r_ptr_reg <= 0;
            full_reg <= 1'b0;
            empty_reg <= 1'b1;
        end
        else begin
            w_ptr_reg <= w_ptr_next;
            r_ptr_reg <= r_ptr_next;
            full_reg <= full_next;
            empty_reg <= empty_next;
        end
    end    
    // next-state logic for read and write pointers
    always @(*) begin
        w_ptr_succ = w_ptr_reg + 1;
        r_ptr_succ = r_ptr_reg + 1;
        // default: keep old values
        w_ptr_next = w_ptr_reg;
        r_ptr_next = r_ptr_reg;
        full_next = full_reg;
        empty_next = empty_reg;
        
        case ({wr, rd})
            //2'b00:// 2'b00: no op
            2'b01: begin // 2'b01: read
                if (~empty_reg) begin // not empty
                    r_ptr_next = r_ptr_succ;
                    full_next = 1'b0;
                    if (r_ptr_succ == w_ptr_reg)
                        empty_next = 1'b1;
                end
            end
            2'b10: begin // write
                if (~full_reg) begin // not full
                    w_ptr_next = w_ptr_succ;
                    empty_next = 1'b0;
                    if (w_ptr_succ == r_ptr_reg)
                        full_next = 1'b1;
                end
            end
            2'b11: begin
                w_ptr_next = w_ptr_succ;
                r_ptr_next = r_ptr_succ;
            end
        endcase
    end
    
    // output
    assign full = full_reg;
    assign empty = empty_reg;

endmodule
