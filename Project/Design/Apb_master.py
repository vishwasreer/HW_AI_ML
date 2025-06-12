import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from apb_driver import SimpleApbMaster


def parse_mem_file(filename):
    """Parse a .mem file with space-separated hex bytes and return list of 32-bit ints."""
    data_words = []
    with open(filename, "r") as f:
        for line in f:
            tokens = line.strip().split()
            # Group every 4 hex bytes to form a 32-bit word (big-endian)
            for i in range(0, len(tokens), 4):
                word_hex = "".join(tokens[i:i+4])
                if len(word_hex) == 8:  # Only if full 32-bit
                    data_words.append(int(word_hex, 16))
    return data_words


@cocotb.test()
async def simple_test(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Reset
    dut.rst_n.value = 0
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    master = SimpleApbMaster(dut.apb, dut.clk)

    # Read and parse matrix files
    matrix_a = parse_mem_file("matrix_a.mem")
    matrix_b = parse_mem_file("matrix_b.mem")

    # Send weights (control = 1)
    for val in matrix_b:
        await master.write(0x08, val)
        await master.write(0x0C, 0x1)
        await RisingEdge(dut.clk)

    # Send data (control = 0)
    for val in matrix_a:
        await master.write(0x00, val)
        await master.write(0x0C, 0x0)
        await RisingEdge(dut.clk)

    # Trigger optional post-processing
    await master.write(0x10, 0x0)

    # Wait for output to settle
    for _ in range(10):
        await RisingEdge(dut.clk)

    result = await master.read(0x00)
    dut._log.info(f"Read acc_out = 0x{result:08X}")

