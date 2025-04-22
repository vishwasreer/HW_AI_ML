module MultiNeuron_Network (
    input wire clk,
    input wire rst,
    input wire [7:0] external_input,
    input wire [7:0] parameters [0:31], // Flattened parameters array
    output wire [7:0] network_output
);

    Leaky_IntFire_Neuron neuron0 (.clk(clk), .rst(rst), .external_input(external_input), .leak_rate(parameters[0]), .threshold(parameters[4]), .synapse_weights_0(parameters[8]), .synapse_weights_1(parameters[12]), .synapse_weights_2(parameters[16]), .neuron_output(neuron_output0));
    Leaky_IntFire_Neuron neuron1 (.clk(clk), .rst(rst), .external_input(external_input), .leak_rate(parameters[1]), .threshold(parameters[5]), .synapse_weights_0(parameters[9]), .synapse_weights_1(parameters[13]), .synapse_weights_2(parameters[17]), .neuron_output(neuron_output1));
    Leaky_IntFire_Neuron neuron2 (.clk(clk), .rst(rst), .external_input(external_input), .leak_rate(parameters[2]), .threshold(parameters[6]), .synapse_weights_0(parameters[10]), .synapse_weights_1(parameters[14]), .synapse_weights_2(parameters[18]), .neuron_output(neuron_output2));
    Leaky_IntFire_Neuron neuron3 (.clk(clk), .rst(rst), .external_input(external_input), .leak_rate(parameters[3]), .threshold(parameters[7]), .synapse_weights_0(parameters[11]), .synapse_weights_1(parameters[15]), .synapse_weights_2(parameters[19]), .neuron_output(neuron_output3));

    // Outputs of neurons are summed and sent as the network output.
    assign network_output = neuron_output0 + neuron_output1 + neuron_output2 + neuron_output3;

endmodule

