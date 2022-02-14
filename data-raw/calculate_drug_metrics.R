## code to prepare `calculate_drug_metrics.R` dataset goes here
library(synapser)
library(tidyverse)
synLogin()
library(dtexbuilder)
library(dr4pl)


screen_data <- synGet("syn26532965")$path %>% 
  read_csv() %>% 
  select(drug_screen_id, dosage, response) 


dose_response <- function(dosage, response){
  if(min(response) > 90){
    res <- NA
  } else {
    res <- tryCatch({
      dr4pl(response ~ dosage) %>% 
        IC(c(50)) %>% 
        as_tibble()},
      error = function(e){
        res <-  NA
        })
  }
  res
}

# ress <-pbsapply(screen_data$drug_screen_id, function(x){
#   foo <- filter(screen_data, drug_screen_id == x)
#   dose_response(foo$dosage, foo$response)
# })


calculated_drug_metrics <- screen_data %>% 
  group_by(drug_screen_id) %>% 
  # filter(drug_screen_id < 201) %>% for testing
  summarize(dr = dose_response(dosage,response)) %>% 
  mutate(IC50 = dr$value, .keep = 'unused')

usethis::use_data(calculated_drug_metrics, overwrite = TRUE)


