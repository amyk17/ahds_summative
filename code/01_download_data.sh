#!/bin/bash

#create the main search query 
BASE="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?" #base URL for esearch in PubMed
QUERY="antimicrobial resistance" AND "alternative therapeutics" #base query for the search
RETMAX=10000 #maximum number of records to retrieve
mindate=2016 
maxdate=2026
output= "data/raw/antimic_res_data.xml" ##output file path for downloaded data 

##transfer the data from pubmed to a local file 
curl -G 

