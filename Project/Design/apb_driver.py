import cocotb
from cocotb.triggers import RisingEdge, Timer

class SimpleApbMaster:
    def __init__(self, apb_if, clk):
        self.apb = apb_if
        self.clk = clk

    async def write(self, addr, data):
        self.apb.paddr.value = addr
        self.apb.pwdata.value = data
        self.apb.pwrite.value = 1
        self.apb.psel.value = 1
        self.apb.penable.value = 0
        await RisingEdge(self.clk)
        self.apb.penable.value = 1
        await RisingEdge(self.clk)
        self.apb.pwrite.value = 0
        self.apb.psel.value = 0
        self.apb.penable.value = 0

    async def read(self, addr):
        self.apb.paddr.value = addr
        self.apb.pwrite.value = 0
        self.apb.psel.value = 1
        self.apb.penable.value = 0
        await RisingEdge(self.clk)
        self.apb.penable.value = 1
        await RisingEdge(self.clk)
        data = self.apb.prdata.value.integer
        self.apb.psel.value = 0
        self.apb.penable.value = 0
        return data

