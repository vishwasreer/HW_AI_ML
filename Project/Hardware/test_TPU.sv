`timescale 1ns / 1ps

module test_TPU;

  // Inputs
  logic clk;
  logic control;
  logic reset;
  logic [31:0] data_arr;
  logic [31:0] wt_arr;

  // Outputs
  logic [127:0] acc_out;

  // Instantiate the Unit Under Test (UUT)
  MMU uut (
    .clk(clk), 
    .control(control), 
    .reset(reset), 
    .data_arr(data_arr), 
    .wt_arr(wt_arr), 
    .acc_out(acc_out)
  );

  // Clock generation
  initial clk = 0;
  always #250 clk = ~clk;

  // Memory arrays for matrices A and B
  reg [31:0] matrix_a [0:31]; // 4 rows of A, each 32 bits (4 elements x 8 bits)
  reg [31:0] matrix_b [0:31]; // 4 columns of B

  integer idx;

  initial begin
    // Load matrix files at start of simulation
    $readmemh("matrix_a.mem", matrix_a);
    $readmemh("matrix_b.mem", matrix_b);

    // Initialize inputs
    control = 0;
    reset = 1;
    data_arr = 32'd0;
    wt_arr = 32'd0;

    // Deassert reset
    #100;
    reset = 0;

    // Start feeding weights (control=1), one column per clock
    control = 1;
    for (idx = 0; idx < 32; idx = idx + 1) begin
      @(posedge clk);
      wt_arr = matrix_b[idx];
    end

    // Feed data rows (control=0), one row per clock
    control = 0;
    for (idx = 0; idx < 32; idx = idx + 1) begin
      @(posedge clk);
      data_arr = matrix_a[idx];
    end

    // Wait for result to stabilize
    #1000;

    
  end

endmodule


