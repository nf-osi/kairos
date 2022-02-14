## code to prepare `drug_names_2` dataset goes here
library(synapser)
library(tidyverse)
synLogin()


convert_inchikey_to_title <- function (input_id, output_type = c("Title")) {
  Sys.sleep(0.25)
  
  input <- URLencode(input_id)
  
  statement <- glue::glue("https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/inchikey/{input_id}/property/{output_type}/XML")
  
  res <- httr::with_config(httr::config(http_version = 0), httr::GET(statement), override = T)
  
  if (res$status_code == 200) {
    res_2 <- XML::xmlToList(rawToChar(res$content))
    response <- res_2$Properties$Title
    if (is.null(response)) {
      response <- NA
    }
  } else {
    message(glue::glue("input \"{input_id}\" appears to be invalid"))
    response <- NA
  }
  response
}

drug_screening <- synGet("syn26532965")$path %>% readr::read_csv(
  col_types = "cccccdcdccccdcdccdc"
) %>% 
  select(screen_id, inchikey) %>% 
  distinct()

drug_info <- synGet("syn25388380")$path %>% readr::read_csv()

drug_names <- drug_info %>% 
  right_join(drug_screening) %>% 
  mutate(synonym = case_when(!is.na(synonym) ~ synonym,
                             is.na(synonym) ~ screen_id))


missing_names <- filter(drug_names, is.na(pref_name) & !is.na(inchikey)) %>%
  distinct()

pc_names <- sapply(missing_names$inchikey, function(x){
  httr::set_config(httr::config(http_version = 0))
  convert_inchikey_to_title(x)
})

##can also grab synonyms at a later date.

missing_names$pref_name <- pc_names
                               
drug_names_2 <- filter(drug_names, !is.na(pref_name) | is.na(inchikey)) %>% 
  bind_rows(missing_names)


usethis::use_data(drug_names_2, overwrite = TRUE)
