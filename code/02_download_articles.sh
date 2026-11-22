#!/bin/bash 

##set working directory
datadir="${1:-../data/raw}"

#search criteria for search
EFETCH="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
INPUT="$datadir/PMID_amr.xml" 
DATABASE="pubmed"
BATCHSIZE=250

#searching and extracting PMID's from xml file
grep -o '<Id>[0-9]*</Id>' "$INPUT" | sed 's/<[^>]*>//g' > "$datadir/articles.txt"
num_articles=$(wc -l <"$datadir/articles.txt") #counting the number of articles found
echo "Number of articles found: $num_articles"

#make directories for batches to send to efetch
mkdir -p "$datadir/batches"

##splitting the list into batches of 250 articles 
split -l $BATCHSIZE -a 2 "$datadir/articles.txt" "$datadir/batches/batch_"

#creating efetch request loop for batches
for f in "$datadir"/batches/batch_??; do ##loops through each batch file
    echo "Processing $f"
    [ -s "$f.xml" ] && continue ##skips if the file already exists
    curl -sS "$EFETCH" \
        --data-urlencode "db=$DATABASE" \
        --data-urlencode "id=$(paste -sd , "$f")" \
        --data-urlencode "rettype=abstract" \
        --data-urlencode "retmode=xml" \
        -o "$f.xml"
        sleep 0.4 #prevents overloading NCBI servers with efetch requests
done



