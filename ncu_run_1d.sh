#!/bin/bash

#SBATCH -p a100q # partition (queue)
#SBATCH -t 0-15:00 # time limit (D-HH:MM)
#SBATCH -o slurm.%N.%j.out # STDOUT
#SBATCH -e slurm.%N.%j.err # STDERR
#SBATCH  --gpus-per-node 1

export PATH=$PATH:/usr/local/cuda/bin

nvidia-smi

nvcc --version
make 

# Define the path to the directory containing the matrices
MATRIX_DIR="/global/D1/homes/james/sparcity/suitesparse/mtx/amd/"

# List of input matrices
INPUT_MATRICES=("DIMACS10/hugebubbles-00020.mtx.gz"
    "DIMACS10/delaunay_n24.mtx.gz"
    "DIMACS10/hugetrace-00020.mtx.gz"
    "DIMACS10/europe_osm.mtx.gz"
    "DIMACS10/road_usa.mtx.gz"
    "DIMACS10/rgg_n_2_24_s0.mtx.gz"
    "GAP/GAP-road.mtx.gz"
    "GenBank/kmer_V1r.mtx.gz"
    "LAW/uk-2005.mtx.gz"
    "MAWI/mawi_201512020330.mtx.gz"
    "Schenk/nlpkkt240.mtx.gz"
    "VLSI/stokes.mtx.gz"
)    

mkdir -p /work/$USER/tmp1   

for input_matrix in "${INPUT_MATRICES[@]}"; do

    # Extract the base file name (without path or extension)
    base_filename=$(basename "$input_matrix" .gz)

    # Concatenate path with matrix name
    path_to_input_matrix="$MATRIX_DIR$input_matrix"

    # Decompress the input matrix
    gunzip -c "$path_to_input_matrix" > "/work/santiago/tmp1/$base_filename"

    # Run the program with the input matrix
    srun ncu -o report_1D_amd_$base_filename -k spmv_1D -c 1 --set full ./row_per_thread "/work/santiago/tmp1/$base_filename"

    # Clean up the temporary decompressed file
    rm "/work/santiago/tmp1/$base_filename"

done


