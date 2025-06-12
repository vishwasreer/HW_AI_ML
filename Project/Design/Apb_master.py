import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from apb_driver import SimpleApbMaster  # Import from your local file

@cocotb.test()
async def simple_test(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    dut.rst_n.value = 0
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    master = SimpleApbMaster(dut.apb, dut.clk)
    await master.write(0x00, 0xDEADBEEF)
    await master.write(0x04, 0xCAFEBABE)
    await master.write(0x08, 0x11223344)
    await master.write(0x0C, 0x00000001)
    await master.write(0x10, 0x00000000)

    for _ in range(5):
        await RisingEdge(dut.clk)

    result = await master.read(0x00)
    dut._log.info(f"Read acc_out = 0x{result:08X}")

