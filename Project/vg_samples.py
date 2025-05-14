import pandas as pd
import numpy as np

# Set random seed for reproducibility
np.random.seed(42)

# Number of synthetic samples
num_samples = 10000

# Generate synthetic data based on the observed range
data = {
    "design_label": np.arange(num_samples), 
    "design_size": np.random.randint(100, 30000, num_samples),
    "no_of_instances": np.random.randint(100, 50000, num_samples),
    "no_of_gates": np.random.randint(50, 20000, num_samples),
    "no_of_inputs": np.random.randint(5, 100, num_samples),
    "no_of_outputs": np.random.randint(5, 100, num_samples),
    "num_macros": np.random.randint(50, 20000, num_samples),
    "pin_density": np.round(np.random.uniform(0.2, 0.9, num_samples), 4),
    "congestion_risk_score": np.round(np.random.uniform(0.0, 1.0, num_samples), 2)
}

# Create DataFrame
df = pd.DataFrame(data)

# Save to CSV
df.to_csv("synthetic_design_stats.csv", index=False)
print("Synthetic dataset saved to 'synthetic_design_stats.csv'")

