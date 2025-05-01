import numpy as np
import matplotlib.pyplot as plt

# Activation function
def sigmoid(x):
    return 1 / (1 + np.exp(-x))

# XOR input space grid
xx, yy = np.meshgrid(np.linspace(0, 1, 100), np.linspace(0, 1, 100))
grid = np.c_[xx.ravel(), yy.ravel()]

# Manually defined weights and biases (after training, or just for plotting)
# For XOR, a network with 2 inputs, 2 hidden neurons, and 1 output neuron is typical
weights_input_hidden = np.array([[20, 20],
                                 [-20, -20]])   # shape (2, 2)
bias_hidden = np.array([-10, 30])              # shape (2,)

weights_hidden_output = np.array([[20], [20]]) # shape (2, 1)
bias_output = np.array([-30])                  # shape (1,)

# Forward pass for the whole grid
hidden_grid = sigmoid(np.dot(grid, weights_input_hidden) + bias_hidden)
output_grid = sigmoid(np.dot(hidden_grid, weights_hidden_output) + bias_output)

# Plot the decision boundary
plt.contourf(xx, yy, output_grid.reshape(xx.shape), levels=[0, 0.5, 1], cmap="coolwarm", alpha=0.6)
plt.title("XOR Decision Boundary")
plt.xlabel("Input 1")
plt.ylabel("Input 2")
plt.colorbar(label="Output")
plt.savefig("xor_decision_boundary.png")

