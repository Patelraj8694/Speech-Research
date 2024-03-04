#!/bin/bash

# Base directory for input and output
input_base="C:/Work/speech-conversion-between-different-modalities/dataset/data/wtimit_16k/nist"
output_base="C:/Work/speech-conversion-between-different-modalities/dataset/data"

# Define input directories for Normal and Whisper types
types=("Normal" "Whisper")
modes=("TRAIN" "TEST")
locations=("SG" "US") # Include both SG and US locations

# Function to loop through directories and process files
process_files() {
    local type="$1"
    local mode="$2"
    local location="$3"
    local start_num="$4"
    local end_num="$5"

    input_dir="$input_base/$mode/$type/$location"
    output_dir="$output_base/$type"
    
    # Check and create output directory if not exists
    mkdir -p "$output_dir"
    
    # Loop through the numbered directories within the specified range
    for num in $(seq -f "%03g" $start_num $end_num); do
        current_dir="$input_dir/$num"
        echo "Processing directory: $current_dir"
        
        # Check if current directory exists
        if [ -d "$current_dir" ]; then
            # Loop through each WAV file in the directory
            for file in "$current_dir"/*.WAV; do
                filename=$(basename -- "$file")
                base=${filename%.WAV}

                # Prepare the output filename
                output_file="$output_dir/${base}_${mode}_${location}_16k.wav"

                # Skip processing if the output file already exists
                if [ -f "$output_file" ]; then
                    echo "Output file already exists, skipping: $output_file"
                    continue
                fi

                echo "Processing file: $file"
                
                # Perform the conversion
                sox "$file" -r 16000 -c 1 -b 16 "$output_file"
            done
        else
            echo "Directory does not exist, skipping: $current_dir"
        fi
    done
}

# Loop through each type, mode, and location to process files
for type in "${types[@]}"; do
    for mode in "${modes[@]}"; do
        for location in "${locations[@]}"; do
            if [ "$location" == "SG" ]; then
                process_files "$type" "$mode" "$location" 0 19
            elif [ "$location" == "US" ]; then
                process_files "$type" "$mode" "$location" 101 131
            fi
        done
    done
done

echo "Processing complete!"
