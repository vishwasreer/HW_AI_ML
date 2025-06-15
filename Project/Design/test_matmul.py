import cocotb
from cocotb.triggers import Timer
from apb import ApbMaster
import numpy as np


@cocotb.test()
async def run_matrix_multiply(dut):
    clock = dut.clk
    bus = dut.apb  # Update to match your APB wrapper signals

    apb = ApbMaster(bus, clock)

    # Prepare dummy data
    A = np.array([[1, 2], [3, 4]], dtype=np.int32)
    B = np.array([[5, 6], [7, 8]], dtype=np.int32)

    # Flatten and send A
    for i in range(A.shape[0]):
        for j in range(A.shape[1]):
            addr = 0x0000 + 4 * (i * A.shape[1] + j)
            await apb.write(addr, int(A[i, j]))

    # Flatten and send B
    for i in range(B.shape[0]):
        for j in range(B.shape[1]):
            addr = 0x1000 + 4 * (i * B.shape[1] + j)
            await apb.write(addr, int(B[i, j]))

    # Trigger multiplication
    await apb.write(0x2000, 1)

    # Poll for done
    done = 0
    while done == 0:
        done = await apb.read(0x2004)
        await Timer(10, units="ns")

    # Read result
    C_hw = np.zeros((A.shape[0], B.shape[1]), dtype=np.int32)
    for i in range(A.shape[0]):
        for j in range(B.shape[1]):
            addr = 0x3000 + 4 * (i * B.shape[1] + j)
            val = await apb.read(addr)
            C_hw[i, j] = val

    # Compare with numpy result
    C_sw = A @ B
    assert np.allclose(C_hw, C_sw), f"HW={C_hw}, SW={C_sw}"

