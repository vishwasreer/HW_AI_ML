from sklearn.preprocessing import LabelEncoder
import os
import csv
import re

# Function to analyze the VG netlist and extract the necessary metrics
def analyze_vg_netlist(vg_path):
    with open(vg_path, 'r') as f:
        content = f.read()

    # Extracting module I/O ports
    module_io = re.search(r'module\s+\w+\s*\((.*?)\);', content, re.DOTALL)
    io_ports = module_io.group(1).replace('\n', '').split(',') if module_io else []
    io_ports = [p.strip() for p in io_ports]

    # Extracting inputs and outputs
    inputs = re.findall(r'input\s+[\[\]\w\s,:]*\s*([\w,\s]+);', content)
    outputs = re.findall(r'output\s+[\[\]\w\s,:]*\s*([\w,\s]+);', content)

    input_ports = sum(len(re.findall(r'\w+', x)) for x in inputs)
    output_ports = sum(len(re.findall(r'\w+', x)) for x in outputs)

    # Extracting instances from the VG file
    instance_pattern = re.compile(r'(\w+)\s+(\w+)\s*\(([^;]+)\);', re.MULTILINE)
    instances = instance_pattern.findall(content)

    # Gate keywords to classify gates
    gate_keywords = {'AND', 'OR', 'INV', 'NAND', 'NOR', 'XOR', 'XNOR', 'BUF', 'MUX', 'AOI', 'OAI'}
    no_of_gates = 0
    num_macros = 0
    pin_count = 0
    nets = set()

    # Loop through instances to calculate metrics
    for gate_type, instance_name, port_connections in instances:
        pins = re.findall(r'\.\w+\((\w+)\)', port_connections)
        pin_count += len(pins)
        nets.update(pins)

        if any(gate in gate_type.upper() for gate in gate_keywords):
            no_of_gates += 1
        else:
            num_macros += 1

    # Metrics for the design
    no_of_instances = len(instances)
    design_size = len(nets)

    # Estimate area based on design size
    estimated_area = design_size * 10
    pin_density = pin_count / estimated_area if estimated_area else 0

    # Assign a congestion risk score based on pin density
    if pin_density > 0.5:
        congestion_score = 0.9
    elif pin_density > 0.2:
        congestion_score = 0.7
    else:
        congestion_score = 0.3

    return [
        design_size, no_of_instances, no_of_gates,
        input_ports, output_ports, num_macros,
        round(pin_density, 4), congestion_score
    ]

# Function to process all VG files in the folder and write the results to CSV
def process_all_vg_files(folder_path, output_csv):
    header = [
        'design_label', 'design_name', 'design_size', 'no_of_instances',
        'no_of_gates', 'no_of_inputs', 'no_of_outputs',
        'num_macros', 'pin_density', 'congestion_risk_score'
    ]

    raw_data = []

    # Loop through files in the specified folder
    for filename in os.listdir(folder_path):
        if filename.endswith('.vg'):
            vg_path = os.path.join(folder_path, filename)
            print(f"Processing {filename}...")
            metrics = analyze_vg_netlist(vg_path)  # Extract metrics from VG file
            raw_data.append([filename] + metrics)

    # Apply Label Encoding to the design names
    design_names = [row[0] for row in raw_data]
    label_encoder = LabelEncoder()
    labels = label_encoder.fit_transform(design_names)

    # Prepare the rows with the encoded design labels
    rows = [[label] + row[1:] for label, row in zip(labels, raw_data)]

    # Write the results to the CSV file
    with open(output_csv, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerows(rows)

    print(f"\n All metrics saved to '{output_csv}' with label encoding applied.")

# --- Run the script ---
# Replace the paths below as needed
if __name__ == "__main__":
    input_folder = "/u/routh/HW_AI_ML/Project/vg_files"  # Folder containing .vg files
    output_csv = "/u/routh/HW_AI_ML/Project/design_stats.csv"
    process_all_vg_files(input_folder, output_csv)

