#!/bin/bash

#SBATCH -p a100q # partition (queue)
#SBATCH -t 0-15:00 # time limit (D-HH:MM)
#SBATCH -o slurm.%N.%j.out # STDOUT
#SBATCH -e slurm.%N.%j.err # STDERR
#SBATCH --gpus-per-node 1

export PATH=$PATH:/usr/local/cuda/bin

nvidia-smi

nvcc --version
make 

# Define the path to the directory containing the matrices
MATRIX_DIR="/global/D1/homes/santiago/reorderings/original/"

# List of input matrices
INPUT_MATRICES=(
"generator/1_column_16_1M.mtx.gz"
"generator/2_column_16_1M.mtx.gz"
"generator/3_column_16_1M.mtx.gz"
"generator/4_column_16_1M.mtx.gz"
"generator/5_column_16_1M.mtx.gz"
"generator/6_column_16_1M.mtx.gz"
"generator/7_column_16_1M.mtx.gz"
"generator/8_column_16_1M.mtx.gz"
"generator/9_column_16_1M.mtx.gz"
"generator/10_column_16_1M.mtx.gz"
"generator/11_column_16_1M.mtx.gz"
"generator/12_column_16_1M.mtx.gz"
"generator/13_column_16_1M.mtx.gz"
"generator/14_column_16_1M.mtx.gz"
"generator/15_column_16_1M.mtx.gz"
"generator/16_column_16_1M.mtx.gz"
"generator/17_column_16_1M.mtx.gz"
"generator/18_column_16_1M.mtx.gz"
"generator/19_column_16_1M.mtx.gz"
#"representative/YeastH.mtx.gz"
#"representative/OVCAR-8H.mtx.gz"
#"representative/Yeast.mtx.gz"
#"representative/DD.mtx.gz"
#"representative/web-BerkStan.mtx.gz"
#"representative/reddit.mtx.gz"
#"AMD/G3_circuit.mtx.gz"
#"Bodendiek/CurlCurl_4.mtx.gz"
#"DIMACS10/333SP.mtx.gz"
#"DIMACS10/adaptive.mtx.gz"
#"DIMACS10/AS365.mtx.gz"
#"DIMACS10/delaunay_n24.mtx.gz"
#"DIMACS10/asia_osm.mtx.gz"
#"DIMACS10/hugebubbles-00020.mtx.gz"
#"DIMACS10/hugetrace-00020.mtx.gz"
#"DIMACS10/hugetric-00020.mtx.gz"
#"DIMACS10/kron_g500-logn21.mtx.gz"
#"DIMACS10/M6.mtx.gz"
#"DIMACS10/NLR.mtx.gz"
#"DIMACS10/rgg_n_2_24_s0.mtx.gz"
#"DIMACS10/road_usa.mtx.gz"
#"DIMACS10/venturiLevel3.mtx.gz"
#"Fluorem/HV15R.mtx.gz"
#"Freescale/circuit5M.mtx.gz"
#"GAP/GAP-road.mtx.gz"
#"GenBank/kmer_V2a.mtx.gz"
#"Gleich/wb-edu.mtx.gz"
#"Janna/Queen_4147.mtx.gz"
#"LAW/uk-2002.mtx.gz"
#"MAWI/mawi_201512012345.mtx.gz"
#"Mycielski/mycielskian19.mtx.gz"
#"Pajek/patents.mtx.gz"
#"Rajat/rajat31.mtx.gz"
#"Schenk_AFE/af_shell10.mtx.gz"
#"Schenk/nlpkkt240.mtx.gz"
#"SNAP/soc-LiveJournal1.mtx.gz"
#"SNAP/com-LiveJournal.mtx.gz"
#"SNAP/cit-Patents.mtx.gz"
#"SNAP/sx-stackoverflow.mtx.gz"
#"SNAP/wiki-Talk.mtx.gz"
#"SNAP/roadNet-CA.mtx.gz"
#"SNAP/wiki-topcats.mtx.gz"
#"SNAP/as-Skitter.mtx.gz"
#"vanHeukelum/cage15.mtx.gz"
#"VLSI/stokes.mtx.gz"
#"Zaoui/kkt_power.mtx.gz"
) 

mkdir -p /work/$USER/tmp3      

for input_matrix in "${INPUT_MATRICES[@]}"; do

    # Extract the base file name (without path or extension)
    base_filename=$(basename "$input_matrix" .gz)

    # Concatenate path with matrix name
    path_to_input_matrix="$MATRIX_DIR$input_matrix"

    # Decompress the input matrix
    gunzip -c "$path_to_input_matrix" > "/work/santiago/tmp3/$base_filename"

    # Run the program with the input matrix
    srun ncu --launch-skip 0 --launch-count 1 --metrics sm__pipe_tensor_op_hmma_cycles_active.avg.pct_of_peak_sustained_elapsed ./spmm_blockedell_example  "/work/santiago/tmp3/$base_filename"

    # Clean up the temporary decompressed file
    rm "/work/santiago/tmp3/$base_filename"

done


