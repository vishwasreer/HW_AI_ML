module tb_logic_depth;
    // Testbench signals
    logic [3:0] fan_in;
    logic [3:0] fan_out;
    logic [1:0] gate_type;
    logic [3:0] depth_out;

    // Instantiate the DUT 
    logic_depth_predictor uut (
        .fan_in(fan_in),
        .fan_out(fan_out),
        .gate_type(gate_type),
        .depth_out(depth_out)
    );

    // Test procedure
    initial begin
        $display("============================================");
        $display("   AI-Based Logic Depth Predictor Testbench ");
        $display("============================================\n");

        for (int i = 0; i < 5; i++) begin
            // Generate random values
            fan_in = $random % 16;    // 4-bit random value (0-15)
            fan_out = $random % 16;   // 4-bit random value (0-15)
            gate_type = $random % 4;  // 2-bit random value (0-3)

            #10;
            $display("[Time: %0t Test %0d  Fan-in: %0d  Fan-out: %0d  Gate: %0d  Predicted Depth: %0d",
                     $time, i+1, fan_in, fan_out, gate_type, depth_out);
        end

        $display("\nTestbench Execution Completed.");
        $finish;
    end
endmodule
