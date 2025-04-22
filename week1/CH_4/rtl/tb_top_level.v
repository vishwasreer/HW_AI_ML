module tb_top_level;

    reg clk;
    reg reset;
    
    // Instantiate the top-level module
    top_level uut (
        .clk(clk),
        .reset(reset)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        
        // Apply reset
        #10 reset = 1;
        #10 reset = 0;
        
        // Run simulation for a while to observe outputs
        #100;
        
        $finish;
    end

    // Monitor the outputs for verification
    initial begin
        $monitor("Time: %0d, Spike Output Layer 1: %b, Spike Output Layer 2: %b", $time, uut.spike_output, uut.spike_output_layer2);
    end

endmodule

