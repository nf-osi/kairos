## code to prepare `analyses` dataset goes here
cohort <- kairos::cohort

library(dplyr)

jhu_tumor_file <- kairos::jhu_tumor_file@clinical.data %>% 
  dplyr::select(specimenID) %>% 
  dplyr::distinct() %>% 
  dplyr::mutate(variant = 1) 

latent_var <- kairos::latent_var %>% 
  dplyr::select(specimenID) %>% 
  dplyr::distinct() %>% 
  dplyr::mutate(latent_var = 1)

analyses <- dplyr::full_join(jhu_tumor_file, latent_var) %>% 
  dplyr::mutate_at(vars(-specimenID), funs(dplyr::case_when(. == 1 ~ 1, 
                                         is.na(.) ~ 0)))

usethis::use_data(analyses
                     # , overwrite = T
                  )
