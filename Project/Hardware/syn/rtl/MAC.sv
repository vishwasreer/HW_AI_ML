module MMU #(
    parameter int depth = 16,
    parameter int bit_width = 8,
    parameter int acc_width = 32,
    parameter int size = 16
)(
    input  logic                     clk,
    input  logic                     control,
    input  logic                     reset,
    input  logic [(bit_width*depth)-1:0] data_arr,
    input  logic [(bit_width*depth)-1:0] wt_arr,
    output logic [acc_width*size-1:0] acc_out
);

    // Internal wires (flattened 2D arrays using packed logic)
    logic [bit_width-1:0] data_out [0:3][0:3];
    logic [bit_width-1:0] wt_out   [0:3][0:3];
    logic [acc_width-1:0] acc_temp [0:3][0:3];

    // Row 0
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m00 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in('0), .data_in(data_arr[7:0]), .wt_path_in(wt_arr[7:0]),
        .acc_out(acc_temp[0][0]), .data_out(data_out[0][0]), .wt_path_out(wt_out[0][0])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m01 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[0][0]), .data_in(data_arr[15:8]), .wt_path_in(wt_out[0][0]),
        .acc_out(acc_temp[0][1]), .data_out(data_out[0][1]), .wt_path_out(wt_out[0][1])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m02 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[0][1]), .data_in(data_arr[23:16]), .wt_path_in(wt_out[0][1]),
        .acc_out(acc_temp[0][2]), .data_out(data_out[0][2]), .wt_path_out(wt_out[0][2])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m03 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[0][2]), .data_in(data_arr[31:24]), .wt_path_in(wt_out[0][2]),
        .acc_out(acc_temp[0][3]), .data_out(data_out[0][3]), .wt_path_out(wt_out[0][3])
    );

    // Row 1
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m10 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in('0), .data_in(data_out[0][0]), .wt_path_in(wt_arr[15:8]),
        .acc_out(acc_temp[1][0]), .data_out(data_out[1][0]), .wt_path_out(wt_out[1][0])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m11 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[1][0]), .data_in(data_out[0][1]), .wt_path_in(wt_out[1][0]),
        .acc_out(acc_temp[1][1]), .data_out(data_out[1][1]), .wt_path_out(wt_out[1][1])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m12 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[1][1]), .data_in(data_out[0][2]), .wt_path_in(wt_out[1][1]),
        .acc_out(acc_temp[1][2]), .data_out(data_out[1][2]), .wt_path_out(wt_out[1][2])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m13 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[1][2]), .data_in(data_out[0][3]), .wt_path_in(wt_out[1][2]),
        .acc_out(acc_temp[1][3]), .data_out(data_out[1][3]), .wt_path_out(wt_out[1][3])
    );

    // Row 2
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m20 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in('0), .data_in(data_out[1][0]), .wt_path_in(wt_arr[23:16]),
        .acc_out(acc_temp[2][0]), .data_out(data_out[2][0]), .wt_path_out(wt_out[2][0])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m21 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[2][0]), .data_in(data_out[1][1]), .wt_path_in(wt_out[2][0]),
        .acc_out(acc_temp[2][1]), .data_out(data_out[2][1]), .wt_path_out(wt_out[2][1])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m22 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[2][1]), .data_in(data_out[1][2]), .wt_path_in(wt_out[2][1]),
        .acc_out(acc_temp[2][2]), .data_out(data_out[2][2]), .wt_path_out(wt_out[2][2])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m23 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[2][2]), .data_in(data_out[1][3]), .wt_path_in(wt_out[2][2]),
        .acc_out(acc_temp[2][3]), .data_out(data_out[2][3]), .wt_path_out(wt_out[2][3])
    );

    // Row 3
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m30 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in('0), .data_in(data_out[2][0]), .wt_path_in(wt_arr[31:24]),
        .acc_out(acc_temp[3][0]), .data_out(data_out[3][0]), .wt_path_out(wt_out[3][0])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m31 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[3][0]), .data_in(data_out[2][1]), .wt_path_in(wt_out[3][0]),
        .acc_out(acc_temp[3][1]), .data_out(data_out[3][1]), .wt_path_out(wt_out[3][1])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m32 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[3][1]), .data_in(data_out[2][2]), .wt_path_in(wt_out[3][1]),
        .acc_out(acc_temp[3][2]), .data_out(data_out[3][2]), .wt_path_out(wt_out[3][2])
    );
    MAC #(.bit_width(bit_width), .acc_width(acc_width)) m33 (
        .clk(clk), .control(control), .reset(reset),
        .acc_in(acc_temp[3][2]), .data_in(data_out[2][3]), .wt_path_in(wt_out[3][2]),
        .acc_out(acc_temp[3][3]), .data_out(data_out[3][3]), .wt_path_out(wt_out[3][3])
    );

    // Output accumulation
    always_ff @(posedge clk) begin
        if (reset)
            acc_out <= '0;
        else
            acc_out <= {
                acc_temp[3][3], acc_temp[2][3], acc_temp[1][3], acc_temp[0][3]
            };
    end

endmodule


