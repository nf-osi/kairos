## code to prepare `drug_names.R` dataset goes here
library(synapser)
library(tidyverse)
synLogin()

drug_screening <- synGet("syn20700260")$path %>% readr::read_csv(
  col_types = "cccccdcdccccdcdccdc"
) %>% 
  select(DT_explorer_internal_id) %>% 
  distinct()

drug_info <- synTableQuery("SELECT * FROM syn17090820")$filepath %>% readr::read_csv()

drug_names <- drug_info %>% 
  select(internal_id, common_name) %>%
  rename(DT_explorer_internal_id = internal_id) %>% 
  inner_join(drug_screening)

usethis::use_data(drug_names)

preferred_drug_names <- synTableQuery("select internal_id, std_name from syn17090819")$filepath %>% 
  readr::read_csv() %>% 
  select(internal_id, std_name) %>% 
  rename(DT_explorer_internal_id = internal_id) %>% 
  inner_join(drug_screening)

usethis::use_data(preferred_drug_names,
                  # overwrite = T
                  )  
 