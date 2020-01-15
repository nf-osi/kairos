## code to prepare `cohort` dataset goes here

cohort <- readr::read_csv("data-raw/cohort_metadata.csv")
usethis::use_data(cohort)
