import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def load_data(filepath):
    """Load CSV file into a pandas DataFrame."""
    return pd.read_csv(filepath)

def extract_timing_data(df):
    """Extract timing data and problem sizes."""
    return {
        'N': df['N'],
        'Host malloc': df['HostMallocTime_ms'],
        'CUDA malloc': df['CudaMallocTime_ms'],
        'Memcpy H2D': df['MemcpyH2DTime_ms'],
        'Kernel Execution': df['KernelTime_ms'],
        'Memcpy D2H': df['MemcpyD2HTime_ms'],
        'Host free': df['HostFreeTime_ms']
    }

def plot_timings(timings, output_file):
    """Plot timing results against log2(N)."""
    N = timings['N']
    log2_N = np.log2(N)

    plt.figure(figsize=(12, 8))

    for label in ['Host malloc', 'CUDA malloc', 'Memcpy H2D', 'Kernel Execution', 'Memcpy D2H', 'Host free']:
        plt.plot(log2_N, timings[label], marker='o', label=f'{label} Time')

    # Set log-scaled x-axis labels
    plt.xticks(ticks=log2_N, labels=[f"$2^{{{int(exp)}}}$" for exp in log2_N])

    plt.xlabel('log2(N) (Exponent of 2)')
    plt.ylabel('Time (ms)')
    plt.title('CUDA SAXPY: Timing Breakdown vs log2(N)')
    plt.grid(True, linestyle='--', linewidth=0.5)
    plt.legend()
    plt.tight_layout()
    plt.savefig(output_file)
    plt.show()

# Main execution
if __name__ == "__main__":
    csv_file = 'timing_results.csv'
    output_image = 'all_timings_log2_N_graph.png'

    df = load_data(csv_file)
    timing_data = extract_timing_data(df)
    plot_timings(timing_data, output_image)

