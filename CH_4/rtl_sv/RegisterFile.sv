// RegisterFile.sv

module RegisterFile (
    input  logic        clk,
    input  logic        rst,
    input  logic        wr_en,
    input  logic [4:0]  wr_addr,
    input  logic [7:0]  wr_data,
    output logic [159:0] all_data
);

    logic [7:0] reg_file [0:19];

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            for (int i = 0; i < 20; i++)
                reg_file[i] <= 8'd0;
        else if (wr_en)
            reg_file[wr_addr] <= wr_data;
    end

    always_comb begin
        all_data = {
            reg_file[19], reg_file[18], reg_file[17], reg_file[16], reg_file[15],
            reg_file[14], reg_file[13], reg_file[12], reg_file[11], reg_file[10],
            reg_file[9],  reg_file[8],  reg_file[7],  reg_file[6],  reg_file[5],
            reg_file[4],  reg_file[3],  reg_file[2],  reg_file[1],  reg_file[0]
        };
    end

endmodule

