module leaky_integrate_fire_neuron #(
    parameter logic [7:0] THRESHOLD     = 8'd255,
    parameter logic [7:0] LEAK_RATE     = 8'd1,
    parameter int         REFRAC_PERIOD = 32
)(
    input  logic        clk,
    input  logic        reset,
    input  logic [7:0]  current,
    output logic        spike
);

    // Internal states
    logic [7:0] membrane_potential;
    logic [5:0] refrac_counter;
    logic       in_refrac;

    // Temporary variable for overflow check
    logic [8:0] temp_potential;

    // Main logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            membrane_potential <= 8'd0;
            refrac_counter     <= 6'd0;
            in_refrac          <= 1'b0;
            spike              <= 1'b0;
        end else begin
            spike <= 1'b0;

            if (in_refrac) begin
                if (refrac_counter == 6'd1) begin
                    in_refrac      <= 1'b0;
                    refrac_counter <= 6'd0;
                end else begin
                    refrac_counter <= refrac_counter - 6'd1;
                end
            end else begin
                if (membrane_potential < LEAK_RATE) begin
                    membrane_potential <= current;
                end else begin
                    temp_potential = membrane_potential + current - LEAK_RATE;

                    if (temp_potential[8] == 1'b1 || temp_potential[7:0] < membrane_potential) begin
                        membrane_potential <= THRESHOLD;
                    end else begin
                        membrane_potential <= temp_potential[7:0];
                    end
                end

                if (membrane_potential >= THRESHOLD) begin
                    membrane_potential <= 8'd0;
                    spike              <= 1'b1;
                    in_refrac          <= 1'b1;
                    refrac_counter     <= REFRAC_PERIOD[5:0];
                end
            end
        end
    end

endmodule

