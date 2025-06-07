import time
import numpy as np
import matplotlib.pyplot as plt

def systolic_bubble_sort(array):
    """Performs systolic-style bubble sort on a NumPy array."""
    num_elements = len(array)
    for cycle in range(num_elements):
        start_index = 0 if cycle % 2 == 0 else 1
        for idx in range(start_index, num_elements - 1, 2):
            if array[idx] > array[idx + 1]:
                array[idx], array[idx + 1] = array[idx + 1], array[idx]
    return array

# Input sizes to test
input_sizes = [10, 100, 1000, 2000]
execution_times = []

# Run sorting test for each input size
for size in input_sizes:
    unsorted_array = np.random.permutation(size)
    start_time = time.time()
    systolic_bubble_sort(unsorted_array.copy())  # Sort a copy to keep original unchanged
    end_time = time.time()
    sort_duration = end_time - start_time
    execution_times.append(sort_duration)
    print(f"Sorted array of size {size} in {sort_duration:.5f} seconds")

# Plot the execution time results
plt.figure(figsize=(8, 5))
plt.plot(input_sizes, execution_times, marker='o', linestyle='-', color='darkorange', label='Systolic Bubble Sort')
plt.title("Execution Time of Systolic Bubble Sort (NumPy)")
plt.xlabel("Input Size")
plt.ylabel("Time (seconds)")
plt.grid(True)
plt.xticks(input_sizes)
plt.legend()

# Save plot to file
plt.savefig("systolic_sort_times_numpy.png")
print("Plot saved as 'systolic_sort_times_numpy.png'")

