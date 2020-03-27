## code to prepare `drug_screening` dataset goes here
library(synapser)
library(tidyverse)
synLogin()

drug_screening <- synGet("syn20700260")$path %>% readr::read_csv(
  col_types = "cccccdcdccccdcdccdc"
) 

genotypes <- synTableQuery('select * from syn21830362', includeRowIdAndRowVersion = F)$filepath %>% 
  read_csv() %>% 
  rename(model_name = specimenID)

drug_screening <- left_join(drug_screening, genotypes)

usethis::use_data(drug_screening,
                  #overwrite = T
                  )
