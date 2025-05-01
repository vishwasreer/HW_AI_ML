import numpy as np
import matplotlib
matplotlib.use('Agg')  # Headless backend for saving plots
import matplotlib.pyplot as plt
import imageio
import os

# Create directory to store frames
os.makedirs("frames", exist_ok=True)

# AND gate data
X = np.array([[0,0],[0,1],[1,0],[1,1]])
y = np.array([0, 0, 0, 1])

# Initialize weights and bias
w = np.random.randn(2)
b = np.random.randn()

def step(x):
    return 1 if x >= 0 else 0

learning_rate = 0.1
epochs = 15
frame_paths = []

for epoch in range(epochs):
    for i in range(len(X)):
        z = np.dot(w, X[i]) + b
        y_pred = step(z)
        error = y[i] - y_pred
        w += learning_rate * error * X[i]
        b += learning_rate * error

    # Plotting
    plt.clf()
    for i in range(len(X)):
        color = 'red' if y[i] == 1 else 'blue'
        plt.scatter(X[i][0], X[i][1], c=color)

    # Decision boundary line
    x_vals = np.linspace(-0.5, 1.5, 100)
    if w[1] != 0:
        y_vals = -(w[0] * x_vals + b) / w[1]
        plt.plot(x_vals, y_vals, 'k--', label=f'Epoch {epoch+1}')
    
    plt.title(f'Perceptron Learning (Epoch {epoch+1})')
    plt.xlim(-0.5, 1.5)
    plt.ylim(-0.5, 1.5)
    plt.legend()
    frame_path = f'frames/epoch_{epoch+1}.png'
    frame_paths.append(frame_path)
    plt.savefig(frame_path)

# Create GIF
images = [imageio.imread(path) for path in frame_paths]

imageio.mimsave('perceptron_learning.gif', images, duration=0.8)

# Optional: Clean up image files
# for path in frame_paths:
#     os.remove(path)
# os.rmdir("frames")

print("GIF saved as perceptron_learning.gif")

