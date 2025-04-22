module spi_master(
    input clk,
    input reset,
    input [15:0] spi_data_in,
    output reg spi_clk,
    output reg spi_mosi,
    input spi_miso,
    output reg spi_cs
);

    reg [3:0] bit_counter;  // Counter for SPI bit transmission
    reg [15:0] shift_reg;   // Shift register for transmitting data

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            spi_clk <= 0;
            spi_cs <= 1;  // Active low chip select
            bit_counter <= 0;
            shift_reg <= 0;
        end 
        else begin
            spi_cs <= 0;  // Enable SPI device
            spi_clk <= ~spi_clk; // Toggle SPI clock
            
            if (bit_counter < 16) begin
                spi_mosi <= shift_reg[15]; // Send MSB first
                shift_reg <= shift_reg << 1; // Shift left
                bit_counter <= bit_counter + 1;
            end 
            else begin
                bit_counter <= 0;
                spi_cs <= 1; // Deselect SPI device
            end
        end
    end

endmodule

