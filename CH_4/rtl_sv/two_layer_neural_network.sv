module two_layer_neural_network #(
    parameter int N = 4,                      // Number of neurons in Layer 1
    parameter int M = 3,                      // Number of neurons in Layer 2
    parameter logic [7:0] SPIKE_CONTRIBUTION = 8'd10
)(
    input  logic        clk,
    input  logic        reset,
    input  logic [7:0]  input_current [N],    // Input current to Layer 1
    output logic        spike_out     [M]     // Spike outputs from Layer 2
);

    // Internal wires and registers
    logic spike_layer1 [N];
    logic [7:0] layer2_current [M];

    // Instantiate Layer 1 neurons
    genvar i;
    generate
        for (i = 0; i < N; i++) begin : gen_layer1
            leaky_integrate_fire_neuron neuron_L1 (
                .clk    (clk),
                .reset  (reset),
                .current(input_current[i]),
                .spike  (spike_layer1[i])
            );
        end
    endgenerate

    // Layer 2 current accumulation logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            foreach (layer2_current[j])
                layer2_current[j] <= 8'd0;
        end else begin
            foreach (layer2_current[j]) begin
                // Reset current each cycle before accumulation
                layer2_current[j] <= 8'd0;
                foreach (spike_layer1[k]) begin
                    if (spike_layer1[k])
                        layer2_current[j] <= layer2_current[j] + SPIKE_CONTRIBUTION;
                end
            end
        end
    end

    // Instantiate Layer 2 neurons
    genvar j;
    generate
        for (j = 0; j < M; j++) begin : gen_layer2
            leaky_integrate_fire_neuron neuron_L2 (
                .clk    (clk),
                .reset  (reset),
                .current(layer2_current[j]),
                .spike  (spike_out[j])
            );
        end
    endgenerate

endmodule

