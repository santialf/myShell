#!/bin/bash

# Ensure the execute.out executable is in the same directory as this script
DOWNLOAD_DIR="./datasets"

# URL of the matrix to download

MATRIX_URL=(    "https://suitesparse-collection-website.herokuapp.com/MM/Bodendiek/CurlCurl_4.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/333SP.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/adaptive.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/AS365.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/delaunay_n24.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/europe_osm.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/hugebubbles-00020.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/hugetrace-00020.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/hugetric-00020.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/kron_g500-logn21.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/M6.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/NLR.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/rgg_n_2_24_s0.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/road_usa.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/DIMACS10/venturiLevel3.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Fluorem/HV15R.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Freescale/circuit5M.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/GAP/GAP-road.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/GenBank/kmer_V1r.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Gleich/wb-edu.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Janna/Queen_4147.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/LAW/uk-2005.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/MAWI/mawi_201512020330.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Mycielski/mycielskian19.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Pajek/patents.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Rajat/rajat31.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Schenk_AFE/af_shell10.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Schenk/nlpkkt240.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/SNAP/soc-LiveJournal1.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/SNAP/com-LiveJournal.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/SNAP/cit-Patents.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/SNAP/sx-stackoverflow.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/SNAP/wiki-topcats.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/SNAP/as-Skitter.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/vanHeukelum/cage15.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/VLSI/stokes.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Zaoui/kkt_power.tar.gz"
)


for matrix_url in "${MATRIX_URL[@]}"; do
    # Extract the base file name (without path or extension)
    base_filename=$(basename "${matrix_url}" .tar.gz)

    # Download the file using wget
    wget -O "$DOWNLOAD_DIR/${base_filename}.tar.gz" "$matrix_url"

    # Check if the download was successful
    if [ -e "$DOWNLOAD_DIR/${base_filename}.tar.gz" ]; then
        echo "File downloaded successfully to $DOWNLOAD_DIR"
    else
        echo "Failed to download the file."
    fi

done

