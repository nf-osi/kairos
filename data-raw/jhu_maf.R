#Prep Maf file for plotting
load("data-raw/jhu_maf_updated.RData")
jhu_tumor_file <- kairos_file
usethis::use_data(jhu_tumor_file, overwrite = TRUE)