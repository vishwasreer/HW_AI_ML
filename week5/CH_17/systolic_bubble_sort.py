def systolic_bubble_sort_verbose(input_array):
    length = len(input_array)
    print("Initial array:", input_array)

    for step in range(length):
        phase = "Even" if step % 2 == 0 else "Odd"
        print(f"\n{phase} phase ? Step {step + 1}")

        # Choose starting index based on phase
        start_index = 0 if phase == "Even" else 1

        for i in range(start_index, length - 1, 2):
            if input_array[i] > input_array[i + 1]:
                # Swap if out of order
                input_array[i], input_array[i + 1] = input_array[i + 1], input_array[i]
        
        print("Array state:", input_array)

    print("\nSorted array:", input_array)

# Example usage
example_data = [5, 3, 8, 4, 2, 7, 1, 6]
systolic_bubble_sort_verbose(example_data)

