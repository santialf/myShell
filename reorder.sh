#!/bin/bash

# Set the LDLIBRARY environment variable with the specified prefix
LD_LIBRARY_PATH="/home/shanti/local/lib"
export LD_LIBRARY_PATH

# Ensure the execute.out executable is in the same directory as this script
EXECUTABLE="./Gorder"
EXTRACT_DIR="./tmp"
MATRIX_DIR="./datasets" 
OUTPUT_DIR="./results_reorder"

if [ ! -x "$EXECUTABLE" ]; then
    echo "The 'execute.out' executable does not exist in the current directory or is not executable."
    exit 1
fi

# List of input matrices
INPUT_MATRICES=(
    "GenBank/kmer_V1r"
    "LAW/uk-2005"
    "MAWI/mawi_201512020330"
    "Schenk/nlpkkt240"
    "VLSI/stokes" 
)


for input_matrix in "${INPUT_MATRICES[@]}"; do
    # Extract the matrix name and the group name
    matrix_name=$(basename "${input_matrix}" .gz)
    group_name="${input_matrix%%/*}"

    echo "Processing $input_matrix ..."

    # Concatenate path with matrix name
    path_to_input_matrix="$MATRIX_DIR$input_matrix"

    # Decompress the .tar.gz file
    tar -xzvf "$MATRIX_DIR/$matrix_name.tar.gz" -C "$EXTRACT_DIR"

    # Run the program with the input matrix
    "$EXECUTABLE" "./tmp/$matrix_name/$matrix_name.mtx"

    # Create a folder with the group name if it doesn't exist
    mkdir -p "$OUTPUT_DIR/$group_name"

    # Rename the generated output to the desired name and desired folder
    mv "order.mtx" "$OUTPUT_DIR/$group_name/$matrix_name.mtx"

    # Compress the output file to a .gz file
    gzip -c "$OUTPUT_DIR/$group_name/$matrix_name.mtx" > "$OUTPUT_DIR/$group_name/$matrix_name.mtx.gz"

    # Remove the original .mtx file to free up space
    rm "$OUTPUT_DIR/$group_name/$matrix_name.mtx"
    # Remove the original folder to free up space
    rm -r "./tmp/$matrix_name"
    
    #echo "Processed $input_matrix and saved as $output_file"
done
