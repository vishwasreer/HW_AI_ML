module apb_slave (
    input logic clk,
    input logic rst_n,
    apb_if apb
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            apb.pready <= 1'b0;
        end else begin
            if (!apb.psel || !apb.penable)
                apb.pready <= 1'b0;  // default not ready

            if (apb.psel && apb.penable && apb.pwrite && !apb.pready) begin
                // handle write
                apb.pready <= 1'b1;
            end

            if (apb.psel && apb.penable && !apb.pwrite && !apb.pready) begin
                // handle read
                apb.pready <= 1'b1;
            end
        end
    end
endmodule

