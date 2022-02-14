## code to prepare `latent_variables` dataset goes here
latent_var <- readr::read_csv("data-raw/latent_variables.csv")
usethis::use_data(latent_var)
