#from lefdef import C_LefReader, C_DefReader

# Initialize readers
#lef_reader = C_LefReader()
#def_reader = C_DefReader()

# Read LEF and DEF files
#lef_data = lef_reader.read("/u/bcruik2/hacked_lefs/saed32nm_hvt_1p9m.lef")
#def_data = def_reader.read("/u/routh/HW_AI_ML/Project/fifo1_sram.dct.def")

# Optionally, print the parsed data
#lef_data.print()
#def_data.print()

import pydef
import numpy as np
import matplotlib.pyplot as plt

# Load DEF file
def_file = pydef.Def()
def_file.read_def("design.def")

# Extract die size and tracks
die_area = def_file.get_die_area()
nets = def_file.get_nets()
components = def_file.get_components()

# Grid size
GRID_SIZE = 100
grid = np.zeros((GRID_SIZE, GRID_SIZE))

def coord_to_bucket(x, y, die_area, grid_size):
    x_min, y_min = die_area[0]
    x_max, y_max = die_area[1]
    bucket_x = int(((x - x_min) / (x_max - x_min)) * (grid_size - 1))
    bucket_y = int(((y - y_min) / (y_max - y_min)) * (grid_size - 1))
    return bucket_x, bucket_y

# Estimate congestion from nets
for net in nets:
    pins = []
    for term in net.terminals:
        pin = term.pin
        loc = pin.get_location()
        pins.append(coord_to_bucket(loc[0], loc[1], die_area, GRID_SIZE))

    # Route each pair in MST (simplified to all pairs here)
    for i in range(len(pins)):
        for j in range(i + 1, len(pins)):
            (x1, y1), (x2, y2) = pins[i], pins[j]
            for x in range(min(x1, x2), max(x1, x2) + 1):
                grid[y1, x] += 1
            for y in range(min(y1, y2), max(y1, y2) + 1):
                grid[y, x2] += 1

# Display
plt.figure(figsize=(10, 8))
plt.imshow(grid, cmap="hot", interpolation="nearest")
plt.title("Congestion from DEF Routing")
plt.colorbar(label="Usage")
plt.xlabel("X Bucket")
plt.ylabel("Y Bucket")
plt.show()


