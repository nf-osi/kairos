## code to prepare `immune_predictions` dataset goes here
library(synapser)
library(dplyr)
synLogin()
immune_predictions <- synTableQuery("SELECT * FROM syn21177277")$filepath %>% 
  readr::read_csv() %>% 
  select(method, cell_type, score, specimenID, tumorType, sex, diagnosis)

usethis::use_data(immune_predictions)
