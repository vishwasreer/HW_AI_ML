import math
import random

# Sigmoid activation function
def sigmoid(x):
    return 1 / (1 + math.exp(-x))

# Derivative of sigmoid
def sigmoid_derivative(output):
    return output * (1 - output)

# Simple two-layer neural network
class XOR_Network:
    def __init__(self):
        # Hidden layer weights and biases (2 neurons)
        self.w1 = random.uniform(-1, 1)
        self.w2 = random.uniform(-1, 1)
        self.w3 = random.uniform(-1, 1)
        self.w4 = random.uniform(-1, 1)
        self.b1 = random.uniform(-1, 1)
        self.b2 = random.uniform(-1, 1)

        # Output neuron weights and bias
        self.w5 = random.uniform(-1, 1)
        self.w6 = random.uniform(-1, 1)
        self.b3 = random.uniform(-1, 1)

    def forward(self, x1, x2):
        # Hidden layer
        self.z1 = x1 * self.w1 + x2 * self.w2 + self.b1
        self.h1 = sigmoid(self.z1)

        self.z2 = x1 * self.w3 + x2 * self.w4 + self.b2
        self.h2 = sigmoid(self.z2)

        # Output layer
        self.z3 = self.h1 * self.w5 + self.h2 * self.w6 + self.b3
        self.output = sigmoid(self.z3)

        return self.output

    def train(self, data, labels, epochs, lr):
        for epoch in range(epochs):
            total_loss = 0
            for (x1, x2), label in zip(data, labels):
                pred = self.forward(x1, x2)
                error = label - pred
                total_loss += error**2

                # Derivatives for output neuron
                d_output = error * sigmoid_derivative(pred)

                # Derivatives for hidden neurons
                d_h1 = d_output * self.w5 * sigmoid_derivative(self.h1)
                d_h2 = d_output * self.w6 * sigmoid_derivative(self.h2)

                # Update output neuron weights and bias
                self.w5 += lr * d_output * self.h1
                self.w6 += lr * d_output * self.h2
                self.b3 += lr * d_output

                # Update hidden neuron weights and biases
                self.w1 += lr * d_h1 * x1
                self.w2 += lr * d_h1 * x2
                self.b1 += lr * d_h1

                self.w3 += lr * d_h2 * x1
                self.w4 += lr * d_h2 * x2
                self.b2 += lr * d_h2

            if epoch % 1000 == 0:
                print(f"Epoch {epoch}, Loss: {total_loss}")

# XOR truth table
data = [
    (0, 0),
    (0, 1),
    (1, 0),
    (1, 1),
]

labels_xor = [
    0, 1, 1, 0  # XOR truth table
]

# Create and train network
network = XOR_Network()
network.train(data, labels_xor, epochs=30000, lr=0.1)

# Test
print("\nTesting XOR after training:")
for inputs in data:
    output = network.forward(*inputs)
    print(f"Input: {inputs}, Output: {round(output)}")

