# apb.py
import cocotb
from cocotb.handle import ModifiableObject
from cocotb.triggers import RisingEdge, ReadOnly
from cocotb.utils import get_sim_time
from cocotb.binary import BinaryValue


class ApbMaster:
    def __init__(self, bus, clock, name=None):
        self.bus = bus
        self.clock = clock
        self.name = name

    async def write(self, addr, data, strb=0xF, verbose=False):
        self.bus.paddr.value = addr
        self.bus.pwrite.value = 1
        self.bus.psel.value = 1
        self.bus.penable.value = 0
        self.bus.pwdata.value = data
        self.bus.pstrb.value = strb

        await RisingEdge(self.clock)
        self.bus.penable.value = 1

        await RisingEdge(self.clock)
        while not self.bus.pready.value:
            await RisingEdge(self.clock)

        self.bus.psel.value = 0
        self.bus.penable.value = 0
        if verbose:
            cocotb.log.info(f"[{get_sim_time()}] APB WRITE: Addr={hex(addr)}, Data={hex(data)}")

    async def read(self, addr, verbose=False):
        self.bus.paddr.value = addr
        self.bus.pwrite.value = 0
        self.bus.psel.value = 1
        self.bus.penable.value = 0

        await RisingEdge(self.clock)
        self.bus.penable.value = 1

        await RisingEdge(self.clock)
        while not self.bus.pready.value:
            await RisingEdge(self.clock)

        val = self.bus.prdata.value.integer
        self.bus.psel.value = 0
        self.bus.penable.value = 0

        if verbose:
            cocotb.log.info(f"[{get_sim_time()}] APB READ: Addr={hex(addr)}, Data={hex(val)}")
        return val

