`default_nettype none

module fully_connected_network #(
    parameter integer NUM_LAYER1 = 4,               // Number of neurons in layer 1
    parameter integer NUM_LAYER2 = 4,               // Number of neurons in layer 2
    parameter integer CURRENT_INPUT_WIDTH = 16,     // Width of current input (per neuron)
    parameter integer THRESHOLD_WIDTH = 16,         // Bit-width for neuron threshold
    parameter integer REFRACTORY_WIDTH = 8,         // Bit-width for refractory period
    parameter integer SYNAPSE_WEIGHT_WIDTH = 16     // Bit-width for synapse weights
)(
    input wire clk,                                           // System clock
    input wire reset,                                         // Active-high reset
    input wire [CURRENT_INPUT_WIDTH-1:0] current_input,       // Neuron input
    input wire [THRESHOLD_WIDTH-1:0] threshold,               // Neuron threshold
    input wire [REFRACTORY_WIDTH-1:0] refractory_period,      // Refractory period
    input wire [SYNAPSE_WEIGHT_WIDTH-1:0] synapse_weights,    // Synapse weight values
    output reg [NUM_LAYER1-1:0] spike_output_layer1,          // Spikes from Layer 1
    output reg [NUM_LAYER2-1:0] spike_output_layer2           // Spikes from Layer 2
);

    // Implement neuron behavior for layer 1
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            spike_output_layer1 <= 0;
        end else begin
            if (current_input > threshold) 
                spike_output_layer1 <= {NUM_LAYER1{1'b1}};  // Set all neurons to spike
            else 
                spike_output_layer1 <= 0;
        end
    end

    // Implement neuron behavior for layer 2
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            spike_output_layer2 <= 0;
        end else begin
            if (| (spike_output_layer1 & synapse_weights))  // Any active neuron triggers output
                spike_output_layer2 <= {NUM_LAYER2{1'b1}}; 
            else 
                spike_output_layer2 <= 0;
        end
    end

endmodule

`default_nettype wire

