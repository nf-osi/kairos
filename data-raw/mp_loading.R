## code to prepare `mp_loading` dataset goes here
library(synapser)
synLogin()

model <- synGet("syn18689545")$path %>% readr::read_rds()
mp_loading <- model$Z 
colnames(mp_loading) <- rownames(model$B)

mp_loading <- mp_loading %>% 
  as.data.frame() %>% 
  tibble::rownames_to_column("hugo_gene") %>% 
  tidyr::gather("latent_var","loading", -hugo_gene) %>% 
  dplyr::filter(loading > 0) %>% 
  dplyr::group_by(latent_var) %>% 
  dplyr::top_n(50, loading) %>% 
  ungroup()

usethis::use_data(mp_loading)
