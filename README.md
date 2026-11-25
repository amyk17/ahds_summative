What methods are being used as an alternative to antibiotics to combat anti-micorbial resistance - over the last 10 years

This project aims to investigate what alternative strategies are being used instead of broad-spectrum antibiotics when treating bacterial infections in order to combat the growing threat of antimicrobial resistance (AMR). Here we will look at papers investigating such methods over the last 10 years to analyse how the field is adapting and changing, and what strategies appear to be the most widely accepted. 

Use the VS Code terminal to create the conda environment from "environment.yml", and activate the conda environment "env_2394435". 


01_PMID_derivation.sh
Creates a URL which uses the esearch command of the E-uilities programme to download a list of PubMed ID's (PMID) in a xml format. 

02_download_articles.sh
Uses the efetch command form the E-utilities programme to obtain the abstract and titles of papers to the corresponding PMID from the list produced in the previous script. 

03_check_data.sh
Checking for any duplicated
Checking that the number of titles, abstracts and publications dates equalled the total number of articles (incliding book articles)
Involved refomratting the batches of xml files so that awk could be used for extraction
43 articles were removed due to missing abstracts - xml batches were imported to the clean directory 

04_parsing_data.R
Imported cleaned batch xml files as a list which were then read and converted into a tibble containing PMID, Publication year, Title, and Abstract.
Tibble is saved as a .rsd file within the clean directory 