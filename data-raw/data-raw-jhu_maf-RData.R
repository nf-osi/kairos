## code to prepare `data-raw/jhu_maf.RData` dataset goes here

base::load("data-raw/jhu_maf.RData")
usethis::use_data(jhu_tumor_file)
