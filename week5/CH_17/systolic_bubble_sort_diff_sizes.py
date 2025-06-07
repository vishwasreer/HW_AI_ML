import time
import random
import matplotlib.pyplot as plt

def systolic_bubble_sort(input_list):
    """Basic systolic bubble sort implementation."""
    num_elements = len(input_list)
    for phase in range(num_elements):
        start_index = 0 if phase % 2 == 0 else 1
        for i in range(start_index, num_elements - 1, 2):
            if input_list[i] > input_list[i + 1]:
                input_list[i], input_list[i + 1] = input_list[i + 1], input_list[i]
    return input_list

# List of input sizes to benchmark
input_sizes = [10, 100, 500, 1000, 2000, 5000]
execution_times = []

for size in input_sizes:
    test_data = random.sample(range(size * 10), size)
    start_time = time.time()
    systolic_bubble_sort(test_data)
    end_time = time.time()
    elapsed_time = end_time - start_time
    execution_times.append(elapsed_time)
    print(f"Input Size: {size}, Execution Time: {elapsed_time:.5f}s")

# Plotting the execution times
plt.figure(figsize=(8, 5))
plt.plot(input_sizes, execution_times, marker='o', linestyle='-', color='blue')
plt.title("Systolic Bubble Sort Execution Time (O(n²))")
plt.xlabel("Input Size")
plt.ylabel("Time (seconds)")
plt.grid(True)
plt.tight_layout()
plt.savefig("systolic_sort_times.png")
print("Plot saved as 'systolic_sort_times.png'")

