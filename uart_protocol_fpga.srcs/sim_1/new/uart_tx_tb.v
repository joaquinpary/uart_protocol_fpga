`timescale 1ns / 1ps

module uart_tx_tb;

    // Parameter declaration
    localparam DATA_BIT = 8;
    localparam CLOCK_TICK = 10; // Para un baud rate típico de 9600 bps
    localparam STOP_BIT_TICK = 16;

    // Inputs to the DUT (Device Under Test)
    reg clock;
    reg reset;
    wire s_tick;
    reg tx_start;
    reg [7:0] i_data;

    // Outputs from the DUT
    wire tx_done_tick;
    wire tx;

    // Instantiate the baud rate generator
    baud_rate_generator #(.CLOCK_TICK(CLOCK_TICK)) baud_gen (
        .clock(clock),
        .o_tick(s_tick)
    );
    
    // Instantiate the UART TX module
    uart_tx #(
        .DATA_BIT(DATA_BIT),
        .STOP_BIT_TICK(STOP_BIT_TICK)
    ) uart_tx_inst (
        .clock(clock),
        .reset(reset),
        .s_tick(s_tick),
        .tx_start(tx_start),
        .i_data(i_data),
        .tx_done_tick(tx_done_tick),
        .tx(tx)
    );

    // Clock generation (100 MHz)
    always #5 clock = ~clock; // Periodo de 10 ns

    // Task to send a byte using UART
    task uart_send_byte(input [7:0] byte);
        begin
            // Assert tx_start and set i_data
            @(posedge s_tick);
            tx_start = 1;
            i_data = byte;
            @(posedge clock); // Esperar un ciclo de reloj
            tx_start = 0; // Desactivar tx_start
            // Esperar a que se complete la transmisión
            wait (tx_done_tick == 1);
        end
    endtask

    // Test stimulus
    initial begin
        // Initialize inputs
        clock = 0;
        reset = 1;
        tx_start = 0;
        i_data = 8'b0;

        // Apply reset
        #10 reset = 0; // Quitar reset después de 10 ns

        // Wait for a few clock cycles before starting the test
        #20;

        // Send a byte
        $display("Sending 0xA5...");
        uart_send_byte(8'hA5); // Enviar el byte 0xA5

        // Wait for transmission completion
        $display("Transmission completed.");

        // Send another byte
        #50; // Pausa entre transmisiones
        $display("Sending 0x3C...");
        uart_send_byte(8'h3C); // Enviar el byte 0x3C

        // Finish simulation
        #100; // Espera después de la última transmisión
        $finish;
    end

    // Monitor output signals
    initial begin
        $monitor("Time: %0t | tx: %b | tx_done_tick: %b", $time, tx, tx_done_tick);
    end

endmodule
