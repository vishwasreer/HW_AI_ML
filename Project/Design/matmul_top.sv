module matmul_top (
    input logic clk,
    input logic rst_n,
    input logic [31:0] paddr,
    input logic [31:0] pwdata,
    input logic        pwrite,
    input logic        penable,
    input logic        psel,
    input  logic [3:0]  pstrb,       // Add this line
    output logic [31:0] prdata,
    output logic        pready,
    output logic        pslverr
);

    apb_if apb(clk);

    // Connect interface fields to top-level ports
    assign apb.paddr   = paddr;
    assign apb.pwdata  = pwdata;
    assign apb.pwrite  = pwrite;
    assign apb.penable = penable;
    assign apb.psel    = psel;
    assign apb.pstrb = pstrb;

    assign prdata  = apb.prdata;
    assign pready  = apb.pready;
    assign pslverr = apb.pslverr;

    // DUT instantiation using apb interface
    apb_slave u_apb_slave (
        .clk(clk),
        .rst_n(rst_n),
        .apb(apb)
    );

endmodule

