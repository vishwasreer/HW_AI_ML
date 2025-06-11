import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import time
import cProfile

# Load and shuffle data
data = pd.read_csv("train.csv")
data = np.array(data)
m, n = data.shape
np.random.shuffle(data)

# Dev and training split
data_dev = data[0:1000].T
Y_dev = data_dev[0]
X_dev = data_dev[1:n] / 255.

data_train = data[1000:m].T
Y_train = data_train[0]
X_train = data_train[1:n] / 255.
_, m_train = X_train.shape

# Initialize parameters
def init_params():
    W1 = np.random.rand(10, 784) - 0.5
    b1 = np.random.rand(10, 1) - 0.5
    W2 = np.random.rand(10, 10) - 0.5
    b2 = np.random.rand(10, 1) - 0.5
    return W1, b1, W2, b2

# Activation functions
def ReLU(Z):
    return np.maximum(0, Z)

def softmax(Z):
    Z_shifted = Z - np.max(Z, axis=0)
    A = np.exp(Z_shifted) / np.sum(np.exp(Z_shifted), axis=0)
    return A

# Forward propagation
def forward_prop(W1, b1, W2, b2, X):
    Z1 = W1.dot(X) + b1
    A1 = ReLU(Z1)
    Z2 = W2.dot(A1) + b2
    A2 = softmax(Z2)
    return Z1, A1, Z2, A2

# ReLU derivative
def ReLU_deriv(Z):
    return Z > 0

# One-hot encoding
def one_hot(Y):
    one_hot_Y = np.zeros((Y.size, Y.max() + 1))
    one_hot_Y[np.arange(Y.size), Y] = 1
    return one_hot_Y.T

# Backward propagation
def backward_prop(Z1, A1, Z2, A2, W1, W2, X, Y):
    one_hot_Y = one_hot(Y)
    dZ2 = A2 - one_hot_Y
    dW2 = 1 / m_train * dZ2.dot(A1.T)
    db2 = 1 / m_train * np.sum(dZ2, axis=1, keepdims=True)
    dZ1 = W2.T.dot(dZ2) * ReLU_deriv(Z1)
    dW1 = 1 / m_train * dZ1.dot(X.T)
    db1 = 1 / m_train * np.sum(dZ1, axis=1, keepdims=True)
    return dW1, db1, dW2, db2

# Parameter update
def update_params(W1, b1, W2, b2, dW1, db1, dW2, db2, alpha):
    W1 -= alpha * dW1
    b1 -= alpha * db1
    W2 -= alpha * dW2
    b2 -= alpha * db2
    return W1, b1, W2, b2

# Predictions
def get_predictions(A2):
    return np.argmax(A2, axis=0)

def get_accuracy(predictions, Y):
    return np.sum(predictions == Y) / Y.size

# Training loop
def gradient_descent(X, Y, alpha, iterations):
    W1, b1, W2, b2 = init_params()
    start_time = time.time()

    for i in range(iterations):
        iter_start = time.time()
        Z1, A1, Z2, A2 = forward_prop(W1, b1, W2, b2, X)
        dW1, db1, dW2, db2 = backward_prop(Z1, A1, Z2, A2, W1, W2, X, Y)
        W1, b1, W2, b2 = update_params(W1, b1, W2, b2, dW1, db1, dW2, db2, alpha)
        
        if i % 10 == 0:
            predictions = get_predictions(A2)
            acc = get_accuracy(predictions, Y)
            iter_time = time.time() - iter_start
            print(f"Iteration {i}: Accuracy = {acc:.4f}, Time = {iter_time:.3f}s")

    total_time = time.time() - start_time
    print(f"\n? Training completed in {total_time:.2f} seconds\n")
    return W1, b1, W2, b2

# Make predictions
def make_predictions(X, W1, b1, W2, b2):
    _, _, _, A2 = forward_prop(W1, b1, W2, b2, X)
    return get_predictions(A2)

# Test and save prediction image
def test_prediction(index, W1, b1, W2, b2):
    current_image = X_train[:, index, None]
    start = time.time()
    prediction = make_predictions(current_image, W1, b1, W2, b2)
    duration = time.time() - start

    label = Y_train[index]
    print(f"Prediction: {prediction[0]} | Label: {label} | Inference time: {duration:.4f}s")

    image = current_image.reshape((28, 28)) * 255
    plt.gray()
    plt.imshow(image, interpolation='nearest')
    filename = f"prediction_{index}_label_{label}_pred_{prediction[0]}.png"
    plt.savefig(filename)
    plt.close()
    print(f"?? Image saved as: {filename}\n")

# ---------- MAIN EXECUTION ----------
def main():
    W1, b1, W2, b2 = gradient_descent(X_train, Y_train, alpha=0.2, iterations=500)
    test_prediction(0, W1, b1, W2, b2)
    test_prediction(1, W1, b1, W2, b2)
    test_prediction(2, W1, b1, W2, b2)
    test_prediction(3, W1, b1, W2, b2)

# Run with profiling
if __name__ == "__main__":
    cProfile.run("main()", "profile_output.prof")

