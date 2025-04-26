import math
import random

# Sigmoid activation
def sigmoid(x):
    return 1 / (1 + math.exp(-x))

# Derivative of sigmoid (for backpropagation)
def sigmoid_derivative(output):
    return output * (1 - output)

# Simple neuron class
class Neuron:
    def __init__(self):
        self.weight1 = random.uniform(-1, 1)
        self.weight2 = random.uniform(-1, 1)
        self.bias = random.uniform(-1, 1)

    def forward(self, input1, input2):
        self.input1 = input1
        self.input2 = input2
        self.z = input1 * self.weight1 + input2 * self.weight2 + self.bias
        self.output = sigmoid(self.z)
        return self.output

    def train(self, data, labels, epochs, lr):
        for epoch in range(epochs):
            total_loss = 0
            for (input1, input2), label in zip(data, labels):
                pred = self.forward(input1, input2)
                error = label - pred
                total_loss += error**2

                # Backpropagation
                d_error = error
                d_output = sigmoid_derivative(pred)
                d_z = d_error * d_output

                # Update weights and bias
                self.weight1 += lr * d_z * input1
                self.weight2 += lr * d_z * input2
                self.bias += lr * d_z

            if epoch % 1000 == 0:
                print(f"Epoch {epoch}, Loss: {total_loss}")

# Training for NAND
data = [
    (0, 0),
    (0, 1),
    (1, 0),
    (1, 1),
]

labels_nand = [
    1, 1, 1, 0  # NAND truth table
]

# Create and train neuron
neuron = Neuron()
neuron.train(data, labels_nand, epochs=10000, lr=0.1)

# Test
print("\nTesting NAND after training:")
for inputs in data:
    output = neuron.forward(*inputs)
    print(f"Input: {inputs}, Output: {round(output)}")
