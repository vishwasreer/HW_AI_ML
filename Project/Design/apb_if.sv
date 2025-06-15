interface apb_if #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter STRB_WIDTH = 4
) (
    input logic clk
);
    logic psel;
    logic penable;
    logic pwrite;
    logic [ADDR_WIDTH-1:0] paddr;
    logic [DATA_WIDTH-1:0] pwdata;
    logic [STRB_WIDTH-1:0] pstrb;

    logic pready;
    logic pslverr;
    logic [DATA_WIDTH-1:0] prdata;

endinterface

