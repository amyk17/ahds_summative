rule all: ##might need to be profile
    input:


rule derive_PMID:
    input: ###make file to prompt script 01 for downloading the data or could make a precursor that makes a generic README to be the input 

    output:
        "data/raw/PMID_amr.xml"
    shell:
    """
    cd code
    bash 01_PMID_derivation.sh 
    """

rule download_articles:
    input:

    output:
        
    shell:
        """
        cd code
        bash 02_download_articles.sh
        """

rule check_data:
    input:

    output:

    shell:
        """
        cd code
        bash 03_checking_data.sh
        """

rule parse_data:
    input:

    output:
        "data/clean/article_information.rds"
    shell:
        """
        cd code
        Rscript 04_parsing_data.R
        """

rule LDA_preparation:
    input:
        "data/clean/article_information.rds"
    output:
        "data/clean/article_search.rds"
    shell:
        """
        cd code
        Rscript 05_prep_LDA.R
        """

rule LDA:
    input:
        "data/clean/article_search.rds"
    output:
        "data/clean/top_terms.rds"
    shell:
        """
        cd code
        Rscript 06_LDA.R
        """

rule visualisation:
    input:
        "data/clean/top_terms.rds"
    output:
        "results/therapy_wordcloud.png"
    shell:
        """
        cd code
        Rscript 07_data_visualisation.R
        """

rule clean:
    input:



