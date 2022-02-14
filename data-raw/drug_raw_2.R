## code to prepare `drug_raw_2` dataset goes here
library(synapser)
library(tidyverse)
synLogin()

drug_raw_2 <- synGet("syn26532965")$path %>% 
  read_csv() %>% 
  select(drug_screen_id, screen_id, model_name, dosage, response)


usethis::use_data(drug_raw_2, overwrite = TRUE)
