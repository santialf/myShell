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
MATRIX_DIR="/global/D1/homes/james/sparcity/suitesparse/mtx/original/"

# List of input matrices
INPUT_MATRICES=("Bodendiek/CurlCurl_4.mtx.gz"
"DIMACS10/333SP.mtx.gz"
"DIMACS10/adaptive.mtx.gz"
"DIMACS10/AS365.mtx.gz"
"DIMACS10/delaunay_n24.mtx.gz"
"DIMACS10/europe_osm.mtx.gz"
"DIMACS10/hugebubbles-00020.mtx.gz"
"DIMACS10/hugetrace-00020.mtx.gz"
"DIMACS10/hugetric-00020.mtx.gz"
"DIMACS10/M6.mtx.gz"
"DIMACS10/NLR.mtx.gz"
"DIMACS10/rgg_n_2_24_s0.mtx.gz"
"DIMACS10/road_usa.mtx.gz"
"DIMACS10/venturiLevel3.mtx.gz"
"Fluorem/HV15R.mtx.gz"
"GAP/GAP-road.mtx.gz"
"Janna/Queen_4147.mtx.gz"
"Pajek/patents.mtx.gz"
"Rajat/rajat31.mtx.gz"
"Schenk_AFE/af_shell10.mtx.gz"
"Schenk/nlpkkt240.mtx.gz"
"SNAP/cit-Patents.mtx.gz"
"vanHeukelum/cage15.mtx.gz"
"Zaoui/kkt_power.mtx.gz"
)         

mkdir -p /work/$USER/tmp

for input_matrix in "${INPUT_MATRICES[@]}"; do

    # Extract the base file name (without path or extension)
    base_filename=$(basename "$input_matrix" .gz)

    # Concatenate path with matrix name
    path_to_input_matrix="$MATRIX_DIR$input_matrix"

    # Decompress the input matrix
    gunzip -c "$path_to_input_matrix" > "/work/santiago/tmp/$base_filename"

    # Run the program with the input matrix
    srun ncu -o "reports/report_spmm_blockedell_roofline_8_original_$base_filename" --set roofline ./spmm_blockedell_example "/work/santiago/tmp/$base_filename"

    # Clean up the temporary decompressed file
    rm "/work/santiago/tmp/$base_filename"

done


