module tb;
    logic clk;
    logic rst_n;
    logic [31:0] paddr;
    logic [31:0] pwdata;
    logic        pwrite;
    logic        penable;
    logic        psel;
    logic [3:0]  pstrb;
    logic [31:0] prdata;
    logic        pready;
    logic        pslverr;

    matmul_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .paddr(paddr),
        .pwdata(pwdata),
        .pwrite(pwrite),
        .penable(penable),
        .psel(psel),
        .pstrb(pstrb),
        .prdata(prdata),
        .pready(pready),
        .pslverr(pslverr)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end

    initial begin
        rst_n = 0;
        #20;
        rst_n = 1;
    end

    initial begin
        // drive other inputs here to valid values
        paddr = 0;
        pwdata = 0;
        pwrite = 0;
        penable = 0;
        psel = 0;
        pstrb = 4'b1111;
        #100;
        $finish;
    end
endmodule

