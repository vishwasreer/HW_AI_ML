module top_level (
    input clk,
    input reset
);

    // Define signals for SPI communication
    reg [15:0] spi_data_in;
    wire spi_clk;
    wire spi_mosi;
    wire spi_miso;
    wire spi_cs;
    
    // Define network output signals
    wire [9:0] spike_output;
    wire [4:0] spike_output_layer2;
    
    // Instantiate the SPI master module
    spi_master spi_inst (
        .clk(clk),
        .reset(reset),
        .spi_data_in(spi_data_in),
        .spi_clk(spi_clk),
        .spi_mosi(spi_mosi),
        .spi_miso(spi_miso),
        .spi_cs(spi_cs)
    );
    
    // Instantiate the fully connected network module
    fully_connected_network #(
        .NUM_LAYER1(10),
        .NUM_LAYER2(5),
        .THRESHOLD(8'b00000001),
        .REFRACTORY_PERIOD(5),
        .SYNAPSE_WEIGHTS({50'b10101010101010101010101010101010101010101010101010})  // Example weights
    ) network_inst (
        .current_input(spi_data_in),
        .threshold(8'b00000001),  // Example threshold
        .refractory_period(5),
        .synapse_weights({50'b10101010101010101010101010101010101010101010101010}),  // Example weights
        .spike_output(spike_output),
        .spike_output_layer2(spike_output_layer2),
        .clk(clk),
        .reset(reset)
    );

    initial begin
        // Initialize SPI input data
        spi_data_in = 16'b0000000000000000;
        #10 spi_data_in = 16'b1010101010101010;
        #10 spi_data_in = 16'b1100110011001100;
        #10 spi_data_in = 16'b1111000011110000;
    end

endmodule

