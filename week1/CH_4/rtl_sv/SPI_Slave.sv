module spi_slave (
    input logic clk,          // System Clock
    input logic sclk,         // SPI Clock
    input logic reset,        // System Reset
    input logic cs_n,         // SPI Chip Select (Active Low)
    input logic mosi,         // SPI Master Out Slave In
    output logic [3:0] addr_out,
    output logic [7:0] data_out,
    output logic write_enable,
    output logic miso
);

    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        ADDR_SHIFT = 2'b01,
        DATA_SHIFT = 2'b10,
        WRITE_EN   = 2'b11
    } state_t;

    state_t state = IDLE;

    logic [3:0] shift_addr;
    logic [7:0] shift_data;
    logic [3:0] state_count;
    logic [11:0] miso_output;

    logic sclk_prev;
    logic sclk_posedge, sclk_negedge;

    // Edge Detection
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            sclk_prev <= 0;
            sclk_posedge <= 0;
            sclk_negedge <= 0;
        end else begin
            sclk_posedge <= (~sclk_prev & sclk);
            sclk_negedge <= (sclk_prev & ~sclk);
            sclk_prev <= sclk;
        end
    end

    // FSM Operation
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state         <= IDLE;
            addr_out      <= 4'b0;
            data_out      <= 8'b0;
            shift_addr    <= 4'b0;
            shift_data    <= 8'b0;
            state_count   <= 4'b0;
            write_enable  <= 0;
            miso_output   <= 12'b0;
        end else if (!cs_n && sclk_posedge) begin
            case (state)
                IDLE: begin
                    shift_addr    <= 4'b0;
                    shift_data    <= 8'b0;
                    state_count   <= 4'b0;
                    write_enable  <= 0;
                    state         <= ADDR_SHIFT;
                end

                ADDR_SHIFT: begin
                    shift_addr  <= {shift_addr[2:0], mosi};
                    state_count <= state_count + 1;
                    if (state_count == 3) begin
                        state_count <= 0;
                        state <= DATA_SHIFT;
                    end
                end

                DATA_SHIFT: begin
                    shift_data  <= {shift_data[6:0], mosi};
                    state_count <= state_count + 1;
                    if (state_count == 7) begin
                        state_count <= 0;
                        state <= WRITE_EN;
                    end
                end

                WRITE_EN: begin
                    addr_out     <= shift_addr;
                    data_out     <= shift_data;
                    write_enable <= 1;
                    miso_output  <= {shift_addr, shift_data};
                    state        <= IDLE;
                end
            endcase
        end
    end

    // Reset state on cs_n high
    always_ff @(posedge clk) begin
        if (cs_n) begin
            state <= IDLE;
            write_enable <= 0;
        end
    end

    // MISO shift on sclk falling edge
    always_ff @(posedge clk) begin
        if (sclk_negedge) begin
            miso <= miso_output[11];
            miso_output <= {miso_output[10:0], 1'b0};
        end
    end

    // Tri-state MISO when CS is high
    always_ff @(posedge clk) begin
        if (cs_n) begin
            miso <= 1'bz;
        end
    end

endmodule

