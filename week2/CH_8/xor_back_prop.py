import numpy as np

# Sigmoid and its derivative
def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def sigmoid_derivative(x):
    return x * (1 - x)

# XOR dataset
X = np.array([[0,0], [0,1], [1,0], [1,1]])  # Inputs
y = np.array([[0], [1], [1], [0]])          # Targets

# Seed for reproducibility
np.random.seed(42)

# Initialize weights and biases
input_layer_size = 2
hidden_layer_size = 2
output_layer_size = 1

weights_input_hidden = np.random.uniform(-1, 1, (input_layer_size, hidden_layer_size))
bias_hidden = np.zeros((1, hidden_layer_size))

weights_hidden_output = np.random.uniform(-1, 1, (hidden_layer_size, output_layer_size))
bias_output = np.zeros((1, output_layer_size))

# Training
epochs = 10000
learning_rate = 0.1

for epoch in range(epochs):
    # --- Forward pass ---
    hidden_input = np.dot(X, weights_input_hidden) + bias_hidden
    hidden_output = sigmoid(hidden_input)

    final_input = np.dot(hidden_output, weights_hidden_output) + bias_output
    final_output = sigmoid(final_input)

    # --- Backward pass ---
    error = y - final_output
    d_output = error * sigmoid_derivative(final_output)

    error_hidden = d_output.dot(weights_hidden_output.T)
    d_hidden = error_hidden * sigmoid_derivative(hidden_output)

    # --- Weight updates ---
    weights_hidden_output += hidden_output.T.dot(d_output) * learning_rate
    bias_output += np.sum(d_output, axis=0, keepdims=True) * learning_rate

    weights_input_hidden += X.T.dot(d_hidden) * learning_rate
    bias_hidden += np.sum(d_hidden, axis=0, keepdims=True) * learning_rate

    # Optional: Print loss every 1000 epochs
    if epoch % 1000 == 0:
        loss = np.mean(np.square(error))
        print(f"Epoch {epoch}, Loss: {loss:.4f}")

# Final Output
print("\nTrained Output:")
print(final_output.round(3))

