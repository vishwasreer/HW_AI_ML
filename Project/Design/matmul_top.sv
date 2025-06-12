`include "apb_if.sv"

module matmul_top(input logic clk, input logic rst_n);

    apb_if apb(clk);

    // Internal wires to drive MMU
    logic [255:0] data_arr, wt_arr;
    logic [127:0] acc_out;
    logic control, reset;

    MMU #(.depth(32), .bit_width(8), .acc_width(32), .size(4)) u_mmu (
        .clk(clk),
        .control(control),
        .reset(reset),
        .data_arr(data_arr),
        .wt_arr(wt_arr),
        .acc_out(acc_out)
    );

    // APB-to-MMU example bridge (extend this as needed)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_arr <= '0;
            wt_arr   <= '0;
            control  <= 0;
            reset    <= 1;
        end else if (apb.psel && apb.penable) begin
            if (apb.pwrite) begin
                case (apb.paddr)
                    32'h00: data_arr[31:0]  <= apb.pwdata;
                    32'h04: data_arr[63:32] <= apb.pwdata;
                    32'h08: wt_arr[31:0]    <= apb.pwdata;
                    32'h0C: control         <= apb.pwdata[0];
                    32'h10: reset           <= apb.pwdata[0];
                endcase
            end
        end
    end

    assign apb.prdata  = acc_out[31:0];  // Example: returning LSBs of acc_out
    assign apb.pready  = 1'b1;
    assign apb.pslverr = 1'b0;

endmodule

