import numpy as np
import matplotlib.pyplot as plt

# Sample data (X: input, y: label)
X = np.array([[0,0],[0,1],[1,0],[1,1]])
y = np.array([0, 0, 0, 1])  # AND gate output

# Initial weights and bias
w = np.random.randn(2)
b = np.random.randn()

def step(x):
    return 1 if x >= 0 else 0

# Training (Perceptron learning rule)
learning_rate = 0.1
epochs = 10

for epoch in range(epochs):
    for i in range(len(X)):
        z = np.dot(w, X[i]) + b
        y_pred = step(z)
        error = y[i] - y_pred
        w += learning_rate * error * X[i]
        b += learning_rate * error

    # Plotting decision boundary
    plt.clf()
    for i in range(len(X)):
        color = 'blue' if y[i] == 0 else 'red'
        plt.scatter(X[i][0], X[i][1], c=color)

    # Calculate decision boundary
    x_vals = np.linspace(-0.5, 1.5, 100)
    if w[1] != 0:
        y_vals = -(w[0] * x_vals + b) / w[1]
        plt.plot(x_vals, y_vals, 'k--')

    plt.title(f'Epoch {epoch+1}')
    plt.xlim(-0.5, 1.5)
    plt.ylim(-0.5, 1.5)

plt.savefig(f"epoch_{epoch+1}.png")


