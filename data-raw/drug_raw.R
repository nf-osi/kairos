## code to prepare `drug_raw` dataset goes here
library(synapser)
library(tidyverse)
synLogin()

drug_raw <- synTableQuery("SELECT * FROM syn20556247", includeRowIdAndRowVersion = F)$filepath %>% 
  read_csv(col_types = "cddccccccccddcdccccccc") %>% 
  select(drug_screen_id, model_name, DT_explorer_internal_id, dosage, response) 

usethis::use_data(drug_raw, 
                  #overwrite = T
                  )
o
