module lif_neuron_binary #(
    parameter int DATA_WIDTH = 16,
    parameter int Q_FRACTIONAL = 8  
)(
    input  logic clk,
    input  logic reset,
    input  logic spike_input,                            // I(t): binary spike input (0 or 1)
    input  logic [DATA_WIDTH-1:0] leak_rate_q,           // Leak rate in Q format
    input  logic [DATA_WIDTH-1:0] firing_threshold_q,    // Threshold for firing spike
    input  logic [DATA_WIDTH-1:0] potential_reset_q,     // Reset potential after spike
    output logic spike_output                            // S(t): output spike
);

    logic [DATA_WIDTH-1:0] membrane_potential_q, updated_potential_q;
    logic [DATA_WIDTH*2-1:0] leak_mult_result_q;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            membrane_potential_q <= 0;
            spike_output <= 0;
        end else begin
            // Apply leakage: potential = (potential * leak_rate) >> Q_FRACTIONAL
            leak_mult_result_q = membrane_potential_q * leak_rate_q;
            updated_potential_q = leak_mult_result_q[DATA_WIDTH+Q_FRACTIONAL-1:Q_FRACTIONAL];

            // Add spike input (Q representation of 1.0 is 1 << Q_FRACTIONAL)
            if (spike_input)
                updated_potential_q = updated_potential_q + (1 << Q_FRACTIONAL);

            // Check threshold and update output
            if (updated_potential_q >= firing_threshold_q) begin
                spike_output <= 1;
                membrane_potential_q <= potential_reset_q;
            end else begin
                spike_output <= 0;
                membrane_potential_q <= updated_potential_q;
            end
        end
    end

endmodule


