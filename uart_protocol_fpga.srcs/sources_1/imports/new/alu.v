module alu#(
    parameter NB_OP = 6,
    parameter NB_DATA = 4
)
(
    input signed [NB_DATA-1:0] i_data_a,
    input signed [NB_DATA-1:0] i_data_b,
    input [NB_OP-1:0] i_op,
    output signed [NB_DATA-1:0] o_data
);
   
    reg signed [NB_DATA-1:0] tmp;
    
    always @(*) begin:mux_alu       
        case(i_op)       
            6'b100000: tmp = i_data_a + i_data_b;   // ADD
            6'b100010: tmp = i_data_a - i_data_b;   // SUB
            6'b100100: tmp = i_data_a & i_data_b;   // AND
            6'b100101: tmp = i_data_a | i_data_b;   // OR
            6'b100110: tmp = i_data_a ^ i_data_b;   // XOR
            6'b000011: tmp = i_data_a >>> i_data_b;  // SRA
            6'b000010: tmp = i_data_a >> i_data_b;  // SRL
            6'b100111: tmp = ~(i_data_a | i_data_b);//NOR
            default: tmp = {NB_DATA{1'b0}};
        endcase
    end
    assign o_data = tmp;
  
endmodule