module tb_lif_neuron_binary;

    parameter int DATA_WIDTH = 16;
    parameter int Q_FRACTIONAL = 8;

    logic clk, reset;
    logic spike_input, spike_output;
    logic [DATA_WIDTH-1:0] leak_rate_q, firing_threshold_q, potential_reset_q;

    lif_neuron_binary #(
        .DATA_WIDTH(DATA_WIDTH),
        .Q_FRACTIONAL(Q_FRACTIONAL)
    ) dut (
        .clk(clk),
        .reset(reset),
        .spike_input(spike_input),
        .leak_rate_q(leak_rate_q),
        .firing_threshold_q(firing_threshold_q),
        .potential_reset_q(potential_reset_q),
        .spike_output(spike_output)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Convert real number to fixed-point Qm.n
    function logic [DATA_WIDTH-1:0] to_q_fixed(input real val);
        return val * (1 << Q_FRACTIONAL);
    endfunction

    initial begin
        $display("Time\tIn\tPotential\tSpike");
        $monitor("%0t\t%b\t%d\t\t%b", $time, spike_input, dut.membrane_potential_q, spike_output);

        // Initialization
        clk = 0;
        reset = 1;
        spike_input = 0;
        leak_rate_q = to_q_fixed(0.9);             // Leak rate = 0.9
        firing_threshold_q = to_q_fixed(3.0);       // Threshold = 3.0
        potential_reset_q = to_q_fixed(0.5);        // Reset to 0.5

        #10 reset = 0;

        // Scenario 1: Constant input below threshold
        $display("\n-- Scenario 1: Constant input below threshold --");
        repeat (5) begin
            spike_input = 1;
            #10;
        end

        // Scenario 2: Leakage with no input
        $display("\n-- Scenario 2: Leakage with no input --");
        spike_input = 0;
        repeat (10) #10;

        // Scenario 3: Input accumulates to threshold
        $display("\n-- Scenario 3: Accumulation to threshold --");
        repeat (15) begin
            spike_input = 1;
            #10;
        end

        // Scenario 4: Immediate spike from strong input
        $display("\n-- Scenario 4: Immediate spike from strong input --");
        firing_threshold_q = to_q_fixed(1.0);
        spike_input = 1;
        #10;

            end

endmodule

