module alu#(
    parameter DATA_BIT = 8
    )
    (
    input signed [DATA_BIT-1:0] i_data_a,
    input signed [DATA_BIT-1:0] i_data_b,
    input [DATA_BIT-1:0] i_op,
    output signed [DATA_BIT-1:0] o_data
    );
    
    localparam [DATA_BIT-1:0]
        add_op = 8'b00100000,
        sub_op = 8'b00100010,
        and_op = 8'b00100100,
        or_op  = 8'b00100101,
        xor_op = 8'b00100110,
        sra_op = 8'b00000011,
        srl_op = 8'b00000010,
        nor_op = 8'b00100111;
        
    reg signed [DATA_BIT-1:0] tmp;
    
    always @(*) begin:mux_alu       
        case(i_op)       
            add_op: tmp = i_data_a + i_data_b;     // ADD
            sub_op: tmp = i_data_a - i_data_b;     // SUB
            and_op: tmp = i_data_a & i_data_b;     // AND
            or_op:  tmp = i_data_a | i_data_b;     // OR
            xor_op: tmp = i_data_a ^ i_data_b;     // XOR
            sra_op: tmp = i_data_a >>> i_data_b;   // SRA
            srl_op: tmp = i_data_a >> i_data_b;    // SRL
            nor_op: tmp = ~(i_data_a | i_data_b);  //NOR
            default: tmp = {DATA_BIT{1'b1}};
        endcase
    end
    
    assign o_data = tmp;
  
endmodule
