#!/bin/bash

##set working directory 
datadir="${1:"}

##define therapeutic strategies to search for 
strategies=(
    [antibodies]="antibodies", "antigen therapy", "monoclonal antibodies"
    [antimicrobial peptides]="antimicrobial peptides", "AMPs"
    [bactiophages]="bactiophages"
    [CRISPR]="CRISPR" AND "Cas" AND
    [bacteriocins]="bacteriosins"
    [probiotics]="probiotics"
    [antibacterial oligonucleotides]="antibacterial oligonucleotides"
    [vaccinations]="vaccinations" AND 
)

