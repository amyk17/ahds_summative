#!/bin/bash

##set working directory
datadir="${1:-../data/raw/batches}"

#make directory for the cleaned data
mkdir -p "../data/cleaned"

##create loop to extract abstracts of IDs from each batch file
for f in "$datadir"/batch_??.xml; do
    echo "Processing $f"
