// NeuronNetworkSystem.sv

`include "../rtl/SPI_Slave.sv"
`include "../rtl/MultiNeuron_Network.sv"
`include "../rtl/RegisterFile.sv"
`include "../rtl/leaky_integrate_fire_neuron.sv"
`include "../rtl/two_layer_neural_network.sv"


module NeuronNetworkSystem (
    input  wire clk,
    input  wire rst,
    input  wire sclk,
    input  wire mosi,
    input  wire ss,
    output wire [7:0] neuron_outputs
);

    wire wr_en;
    wire [4:0] wr_addr;
    wire [7:0] wr_data;
    wire [255:0] all_parameters;

    // Instantiate SPI Slave
    SPI_Slave spi_slave_inst (
        .clk(clk),
        .rst(rst),
        .sclk(sclk),
        .mosi(mosi),
        .ss(ss),
        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data)
    );

    // Instantiate Register File
    RegisterFile #( .NUM_REGS(32) ) reg_file_inst (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .all_data_out(all_parameters)
    );

    // Instantiate Neuron Network
    MultiNeuronNetwork neuron_net_inst (
        .clk(clk),
        .rst(rst),
        .all_parameters(all_parameters),
        .neuron_outputs(neuron_outputs)
    );

endmodule

