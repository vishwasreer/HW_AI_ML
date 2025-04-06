module lif_neuron(
    input clk,                          // Clock input
    input reset,                        // Reset input
    input [15:0] current_input,         // Multi-bit current input (16 bits)
    input [15:0] threshold,             // Spike threshold (16 bits)
    input [7:0] refractory_period,      // Refractory period (8 bits)
    output reg spike,                   // Spike output
    output reg [15:0] membrane_potential // Membrane potential output
);

    // Parameters for LIF model
    parameter V_rest = 16'd0;           // Resting membrane potential (0)
    parameter V_reset = 16'd0;          // Reset membrane potential after spike (0)
    parameter tau = 16'd1000;           // Time constant for the neuron (in clock cycles)
    
    reg [15:0] membrane_potential_int;   // Internal membrane potential register
    reg [7:0] refractory_counter;        // Refractory counter
    
    // Integrate input current and leak
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            membrane_potential_int <= V_rest;
            spike <= 0;
            refractory_counter <= 0;
        end else begin
            // During the refractory period, the neuron cannot spike
            if (refractory_counter > 0) begin
                refractory_counter <= refractory_counter - 1;
                spike <= 0;
            end else begin
                // Membrane potential integration
                membrane_potential_int <= membrane_potential_int + current_input - (membrane_potential_int / tau);
                
                // Check for spike condition
                if (membrane_potential_int >= threshold) begin
                    spike <= 1;
                    membrane_potential_int <= V_reset;
                    refractory_counter <= refractory_period; // Start refractory period
                end else begin
                    spike <= 0;
                end
            end
        end
    end

    // Output the membrane potential value
    always @(membrane_potential_int) begin
        membrane_potential = membrane_potential_int;
    end
endmodule

