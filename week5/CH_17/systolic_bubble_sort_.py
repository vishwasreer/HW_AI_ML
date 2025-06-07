import time
import random
import numpy as np
import matplotlib.pyplot as plt

# --- Systolic Bubble Sort Implementations ---
def systolic_bubble_sort_python(input_array):
    length = len(input_array)
    for cycle in range(length):
        for idx in range(cycle % 2, length - 1, 2):
            if input_array[idx] > input_array[idx + 1]:
                input_array[idx], input_array[idx + 1] = input_array[idx + 1], input_array[idx]
    return input_array

def systolic_bubble_sort_numpy(input_array):
    length = len(input_array)
    for cycle in range(length):
        for idx in range(cycle % 2, length - 1, 2):
            if input_array[idx] > input_array[idx + 1]:
                input_array[idx], input_array[idx + 1] = input_array[idx + 1], input_array[idx]
    return input_array

# --- Configuration ---
input_sizes = [10, 100, 500, 1000, 1500, 10000, 15000]
execution_times_python = []
execution_times_numpy = []

# --- Performance Measurement ---
for size in input_sizes:
    python_input = random.sample(range(size * 2), size)
    numpy_input = np.random.permutation(size * 2)[:size]

    start_time = time.time()
    systolic_bubble_sort_python(python_input.copy())
    execution_times_python.append(time.time() - start_time)

    start_time = time.time()
    systolic_bubble_sort_numpy(numpy_input.copy())
    execution_times_numpy.append(time.time() - start_time)

    print(f"Size {size}: Python = {execution_times_python[-1]:.5e}s, NumPy = {execution_times_numpy[-1]:.5e}s")

# --- Plotting Execution Time Histogram (Log Scale) ---
bar_width = 0.35
x_indices = np.arange(len(input_sizes))

plt.figure(figsize=(10, 6))
bars_python = plt.bar(x_indices - bar_width / 2, execution_times_python, width=bar_width, color='steelblue', label='Pure Python')
bars_numpy = plt.bar(x_indices + bar_width / 2, execution_times_numpy, width=bar_width, color='orange', label='NumPy')

plt.yscale('log')

# Annotate bar values
for bar in bars_python + bars_numpy:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width() / 2, height, f"{height:.1e}", ha='center', va='bottom', fontsize=8)

# Labels and layout
plt.xlabel("Input Size", fontsize=12)
plt.ylabel("Execution Time (seconds, log scale)", fontsize=12)
plt.title("Systolic Bubble Sort: Python vs NumPy", fontsize=14)
plt.xticks(x_indices, input_sizes)
plt.legend()
plt.grid(axis='y', linestyle='--', alpha=0.6, which='both')
plt.tight_layout()

# Save the figure
plt.savefig("systolic_sort_histogram_logscale.png")
print("Histogram with log scale saved as 'systolic_sort_histogram_logscale.png'")

