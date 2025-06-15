module MAC #(
    parameter int bit_width = 8,
    parameter int acc_width = 128
)(
    input  logic                     clk,
    input  logic                     control,
    input  logic                     reset,
    input  logic [acc_width-1:0]     acc_in,
    input  logic [bit_width-1:0]     data_in,
    input  logic [bit_width-1:0]     wt_path_in,
    output logic [acc_width-1:0]     acc_out,
    output logic [bit_width-1:0]     data_out,
    output logic [bit_width-1:0]     wt_path_out
);

    // Internal signals
    logic [bit_width*2-1:0] result;
    logic [acc_width-1:0]   acc_reg;
    logic [bit_width-1:0]   weight_reg;

    // Combinational block for MAC operation
    always_comb begin
        result   = data_in * wt_path_in;
        acc_reg  = acc_in + result;
    end

    // Sequential block for register updates
    always_ff @(posedge clk) begin
        if (reset) begin
            acc_out      <= '0;
            wt_path_out  <= '0;
            data_out     <= '0;
        end else begin
            acc_out      <= acc_reg;
            wt_path_out  <= wt_path_in;
            data_out     <= data_in;
        end
    end

endmodule

