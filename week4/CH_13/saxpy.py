import numpy as np
from numba import cuda, float32
import math

# Define the SAXPY CUDA kernel
@cuda.jit
def saxpy(n, a, x, y):
    i = cuda.grid(1)
    if i < n:
        y[i] = a * x[i] + y[i]

# Problem size
N = 1 << 20

# Allocate host memory
x = np.ones(N, dtype=np.float32)
y = np.full(N, 2.0, dtype=np.float32)

# Allocate device memory
d_x = cuda.to_device(x)
d_y = cuda.to_device(y)

# Kernel launch configuration
threads_per_block = 256
blocks_per_grid = (N + threads_per_block - 1) // threads_per_block

# Launch kernel
saxpy[blocks_per_grid, threads_per_block](N, 2.0, d_x, d_y)

# Copy result back to host
y_result = d_y.copy_to_host()

# Check for correctness
max_error = np.max(np.abs(y_result - 4.0))
print("Max error:", max_error)

