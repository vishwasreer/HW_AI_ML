# Apb_master.py
import cocotb
import numpy as np
from cocotb.triggers import RisingEdge
from apb import ApbMaster

@cocotb.test()
async def run_hw_test(dut):
    clk = dut.clk
    bus = dut  # Assuming APB signals are top-level
    master = ApbMaster(bus, clk)

    A = np.load("matrix_A.npy")  # Shape (10, 10)
    B = np.load("matrix_B.npy")  # Shape (10, m)
    result = np.zeros((10, B.shape[1]))

    for col in range(B.shape[1]):
        for row in range(10):
            acc = 0
            for k in range(10):
                # You must implement logic to feed A[row][k] and B[k][col]
                # Here's pseudocode assuming address mapping
                await master.write(0x00, int(A[row, k]))  # A value
                await master.write(0x04, int(B[k, col]))  # B value
                await master.write(0x08, 1)               # Start signal
                await RisingEdge(clk)
                val = await master.read(0x0C)             # Read result
                acc += val  # or accumulate in hardware
            result[row, col] = acc  # Replace with val if done in HW

    np.save("matmul_result.npy", result)

