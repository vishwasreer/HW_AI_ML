import numpy as np
import matplotlib.pyplot as plt

# Simulation parameters
dt = 0.001  # time step
T = 2       # total time (s)
t = np.arange(0, T, dt)
f = 1       # frequency of input voltage (Hz)
V = np.sin(2 * np.pi * f * t)  # sinusoidal voltage input

# Memristor parameters
R_on = 100      # minimum resistance
R_off = 16000   # maximum resistance
D = 10e-9       # thickness of the device
mu_v = 10e-14   # mobility
x = 0.1         # initial state variable (between 0 and 1)

# Lists to store results
I = []
X = []

for v in V:
    R = R_on * x + R_off * (1 - x)  # memristance
    i = v / R
    dx = mu_v * R_on * i / D**2     # Biolek model state equation
    x += dx * dt
    x = np.clip(x, 0, 1)            # bound x between 0 and 1

    I.append(i)
    X.append(x)

# Plot I-V curve
plt.figure(figsize=(6, 5))
plt.plot(V, I, linewidth=1)
plt.title("Memristor I-V Pinched Hysteresis Loop")
plt.xlabel("Voltage (V)")
plt.ylabel("Current (A)")
plt.grid(True)
plt.tight_layout()
plt.show()

