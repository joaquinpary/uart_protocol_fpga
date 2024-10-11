`timescale 1ns / 1ps

module fifo_buffer_tb;

    // Parameter
    localparam BITS = 8;
    localparam BUS = 2;
    
    // Inputs
    reg clock;
    reg reset;
    reg rd, wr;
    reg [BITS-1:0] w_data;
    
    // Outputs
    wire empty;
    wire full;
    wire [BITS-1:0] r_data;
    
    // Instantiate the UUT
    fifo_buffer #(.BITS(BITS), .BUS(BUS)) uut(
        .clock(clock),
        .reset(reset),
        .rd(rd),
        .wr(wr),
        .w_data(w_data),
        .empty(empty),
        .full(full),
        .r_data(r_data)
    );
    
    // Clock generation
    always #5 clock = ~clock; // Clock period = 10 ns
    
    // Task to write to FIFO
    task write_fifo(input [BITS-1:0] data_in);
        begin
            @(posedge clock);
            w_data = data_in;
            wr = 1;
            @(negedge clock);
            wr = 0;
            
        end
    endtask
    
    // Task to read from FIFO
    task read_fifo;
        begin
            @(negedge clock);
            rd = 1;
            @(negedge clock);
            rd = 0;
        end
    endtask
    
    
    initial begin
        // Initialize Inputs
        clock = 0;
        reset = 1;
        rd = 0;
        wr = 0;
        w_data = 0;
        
        // Apply reset
        #10;
        reset = 0;
        #5;
        // Test writing to FIFO
        $display("Writing to FIFO...");
        write_fifo(8'hAA); // Write data 0xAA
        write_fifo(8'hBB); // Write data 0xBB
        write_fifo(8'hCC); // Write data 0xCC
        //write_fifo(8'hDD); // Write data 0xDD
        
        read_fifo();
        
        // Try to write when FIFO is full
        #10;
        $display("Trying to write when FIFO is full...");
        //wr = 1;
        //w_data = 8'hFF; // Try to write data 0xFF
        //#10;
        //wr = 0;
        //$display("Full flag: %b", full);
    
        // Test reading from FIFO
        #10;
        $display("Reading from FIFO...");
        read_fifo(); // Read data
        read_fifo(); // Read data
        read_fifo(); // Read data
        read_fifo(); // Read data
    
        // Try to read when FIFO is empty
        #10;
        $display("Trying to read when FIFO is empty...");
        rd = 1;
        #10;
        rd = 0;
        $display("Empty flag: %b", empty);
    
        // End simulation
        #20;
        $finish;
    end
    
endmodule
