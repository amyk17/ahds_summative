#!/bin/bash

#make new directory
mkdir -p ../data/raw

#set working directory
datadir="${1:-../data/raw}"

#create the main search query 
ESEARCH="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?"
DATABASE="pubmed" #database
QUERY='"antimicrobial resistance"[Title/Abstract] AND "therapy"[Title/Abstract]' #base query for the search
RETMAX=10000 #maximum number of records to retrieve
FORMAT="xml" #download in xml format
MINYEAR=2017 
MAXYEAR=2026
OUTPUT="$datadir/PMID_amr.xml" ##output file path for PMID xml file 

##transfer the data from pubmed to a local file 
curl -G -sS "$ESEARCH" \
    --data-urlencode "db=$DATABASE" \
    --data-urlencode "term=$QUERY" \
    --data-urlencode "retmax=$RETMAX" \
    --data-urlencode "retmode=$FORMAT" \
    --data-urlencode "datetype=pdat" \
    --data-urlencode "mindate=$MINYEAR" \
    --data-urlencode "maxdate=$MAXYEAR" \
    -o $OUTPUT 


