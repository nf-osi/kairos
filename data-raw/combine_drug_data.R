## code to prepare `combine_drug_data` dataset goes here
library(reticulate)
use_condaenv("synapse250", required = T)
synapseclient <- reticulate::import('synapseclient')
syn <- synapseclient$Synapse()
library(tidyverse)
syn$login()

ids <- c(#"syn20555550",  ##Field Lab NF Drug Screens
  "syn12292394",  ##NF2 Synodos low-throughput screen
  "syn12292393",  ##NTAP pNF NCATS single agent
  # "syn12292585",  ##NTAP pNF 6x6 NCATS combination
  #"syn12292601",  ##NF2 Synodos 10x10 NCATS combination
  "syn12292395",  ##NF1 Synodos MN secondary screen
  #"syn12293222",  ##NF2 Synodos 6x6 NCATS combination
  "syn12296219",  ##NF2 Synodos NCATS single agent MIPE 4.0
  "syn12297785")  ##NF2 Synodos NCATS single agent MIPE 1.0 Syn5,Syn1 only

foo <- map(ids, function(x){
  readr::read_csv(syn$get(x)$path, col_types = "c")
}) %>% set_names(ids)

data <- dplyr::bind_rows(foo)  

cmpd_names <- data %>% 
  select(compoundName) %>% 
  distinct() %>% 
  filter(!is.na(compoundName))

##DTEX v4 name map
# name_map <- readr::read_csv(syn$get("syn25388380")$path)
# name_map_2 <- left_join(cmpd_names %>% mutate(join_col = tolower(compoundName)), 
#                         name_map %>%  mutate(join_col = tolower(synonym))) %>% 
#   select(-join_col)
# 
# unmapped_cmpds <- filter(name_map_2, is.na(inchikey)) %>% 
#   select(compoundName) %>% 
#   distinct()

##to avoid Error in the HTTP2 framing layer issue

httr::set_config(httr::config(http_version = 0))

inchikeys <- sapply(cmpd_names$compoundName, function(x){
  httr::set_config(httr::config(http_version = 0))
  foo <- dtexbuilder::.convert_id_to_structure_pubchem(x, id_type = 'name', output_type = 'InChIKey')
 })

cmpd_names$inchikey <- inchikeys

##retrieve prebaked compound maps for missing ids
synodos_nf1 <- syn$get("syn26532681")$path %>% readr::read_csv()
synodos_nf2 <- syn$get("syn26532683")$path %>% readr::read_csv()
synodos_nf2_extra <- syn$get("syn26532686")$path %>% readr::read_csv()

curated_cmpd_structures <- bind_rows(synodos_nf1, synodos_nf2, synodos_nf2_extra)

cmpd_structures <- filter(cmpd_names, !is.na(inchikey)) %>% 
  rename(screen_id = compoundName) %>% 
  bind_rows(curated_cmpd_structures)

unknown_structures <- cmpd_names %>% 
  rename(screen_id = compoundName) %>% 
  filter(!screen_id %in% cmpd_structures$screen_id)

structure_map <- cmpd_structures %>% 
  bind_rows(unknown_structures) 

##this is the standardized model name map
map <- syn$tableQuery("SELECT distinct * FROM syn16979992", includeRowIdAndRowVersion = FALSE)$filepath %>% 
  read_csv

map_2 <- tribble(
  ~modelSystemName, ~synonym,
  "ipnNF95.11C", "ipnNF95.11c",
  "ST8814", "ST88-14",
  "sNF02.2", "SNF02.2",
  "ST88-3", "st88-3",
  "MEF", "MEF WT",
  "MEF CAP2KO", "MEF CAP2KO"
)

map <- bind_rows(map, map_2)

cellosaurus <- syn$tableQuery("SELECT distinct name AS \"modelSystemName\", cellosaurus_id FROM syn18506933", includeRowIdAndRowVersion = F)$filepath %>% 
  read_csv

cellosaurus_2 <- tribble(
  ~modelSystemName, ~cellosaurus_id,
  "HCT116 p53-", "CVCL_HD97",
  "HCT116 p53+", "CVCL_0291",
  "HT1080", "CVCL_0317",
  "HFF", NA,
  "MTC", NA
)

cellosaurus <- bind_rows(cellosaurus, cellosaurus_2)

organism <- syn$tableQuery("select distinct name as \"modelSystemName\", organism as \"organism_name\" from syn18506936",includeRowIdAndRowVersion = FALSE)$filepath %>% 
  read_csv

organism_2 <- tribble(
  ~modelSystemName, ~organism_name,
  "HCT116 p53-", "human",
  "HCT116 p53+", "human",
  "HT1080", "human",
  "HFF", "human",
  "MTC", "mouse",
  "MEF", "mouse",
  "MEF CAP2KO", "mouse",
  "N5", "human",
  "N10", "human"
)

organism <- bind_rows(organism, organism_2)

disease <- tribble(
  ~model_name, ~disease_name, ~disease_efo_id,
  "ST8814", "NF1", NA,
  "90-8", "NF1", NA,
  "STS26T", "NF1", NA,
  "T265", "NF1", NA,
  "HCT116 p53+", "cancer", 0000311,
  "HCT116 p53-", "cancer", 0000311,          
  "HEI193", "NF2", NA,
  "HT1080", "cancer", 0000311,
  "RT4", "NF2", NA,
  "S462TY", "NF1", NA,
  "ST88-3", "NF1", NA,
  "Syn1", "no disease", NA,
  "Syn10", "NF2", NA,
  "Syn12", "NF2", NA,
  "Syn2", "no disease", NA,
  "Syn3", "NF2", NA,
  "Syn4", "NF2", NA,
  "Syn5", "NF2", NA,                  
  "Ben-Men-1", "NF2", NA,
  "Syn7", "NF2", NA,
  "HS01", "NF2", NA,
  "HS11", "no disease", NA,
  "MS01", "NF2", NA,
  "MS02", "NF2", NA,
  "MS03", "NF2", NA,
  "MS12", "no disease", NA,
  "MS11", "no disease", NA,
  "ipn02.3", "no disease", NA,            
  "ipn02.8", "no disease", NA,
  "ipNF05.5 (mixed clone)", "NF1", NA,
  "ipNF05.5 (single clone)", "NF1", NA,
  "ipNF06.2A", "NF1", NA,
  "ipNF95.11b C/T", "NF1", NA,        
  "ipnNF95.11C", "NF1", NA,
  "ipNF95.6", "NF1", NA,
  "HFF", "no disease", NA,                   
  "MTC", "no disease", NA,
  "ipNF95.11b C", "NF1", NA,
  "N5", "NF1", NA,
  "N10", "no disease", NA) 

symptom <- tribble(
  ~model_name, ~symptom_name, ~symptom_efo_id,
  "ST8814", "MPNST", 0000760,
  "90-8", "MPNST", 0000760,
  "STS26T", "MPNST", 0000760,
  "T265", "MPNST", 0000760,
  "HCT116 p53+", "colorectal carcinoma", 1001951,
  "HCT116 p53-", "colorectal carcinoma", 1001951,          
  "HEI193", "schwannoma", 0000693,
  "HT1080", "fibrosarcoma", 0002087,
  "RT4", "schwannoma", 0000693,
  "S462TY", "MPNST", 0000760,
  "ST88-3", "MPNST", 0000760,
  "Syn1", "no symptom", NA,
  "Syn10", "meningioma", NA,
  "Syn12", "meningioma", NA,
  "Syn2", "no symptom", NA,
  "Syn3", "no symptom", NA,
  "Syn4", "no symptom", NA,
  "Syn5", "no symptom", NA,                  
  "Ben-Men-1", "meningioma", NA,
  "Syn7", "meningioma", NA,
  "HS01", "no symptom", 0000693,
  "HS11", "no symptom", NA,
  "MS01", "schwannoma", 0000693,
  "MS02", "schwannoma", 0000693,
  "MS03", "schwannoma", 0000693,
  "MS12", "no symptom", NA,
  "MS11", "no symptom", NA,
  "ipn02.3", "no symptom", NA,              
  "ipn02.8", "no symptom", NA,
  "ipNF05.5 (mixed clone)", "pNF", 0000658,
  "ipNF05.5 (single clone)", "pNF", 0000658,
  "ipNF06.2A", "pNF", 0000658,
  "ipNF95.11b C/T", "pNF", 0000658,        
  "ipnNF95.11C", "pNF", 0000658,
  "ipNF95.6", "pNF", 0000658,
  "HFF", "no symptom", NA,                   
  "MTC", "no symptom", NA,
  "ipNF95.11b C", "pNF", 0000658,
  "N5", "no symptom", NA,
  "N10", "no symptom", NA) 

data <- bind_rows(foo) %>%
  group_by(experimentSynapseId,compoundName,individualId) %>%
  add_column("drug_screen_id" = group_indices(.)) %>%
  ungroup() %>%
  rename(screen_id = compoundName) %>% 
  filter(stdCompoundConcentration != 0) %>% 
  group_by(drug_screen_id, individualId, experimentSynapseId, studySynapseId, funder, recordId, percentViability, screen_id, stdCompoundConcentrationUnit) %>% 
  summarize(stdCompoundConcentration=sum(as.numeric(stdCompoundConcentration))) %>% 
  ungroup() %>% 
  filter(stdCompoundConcentration != 0) %>% 
  left_join(structure_map %>% select(screen_id, inchikey))

data <- data %>%    
  mutate(synonym = individualId) %>%
  left_join(distinct(map)) %>%
  left_join(distinct(cellosaurus)) %>%
  left_join(distinct(organism)) %>% 
  select(drug_screen_id, recordId, experimentSynapseId, studySynapseId, funder, modelSystemName, cellosaurus_id, organism_name, screen_id, inchikey, stdCompoundConcentration, stdCompoundConcentrationUnit, percentViability) %>%
  set_names(c("drug_screen_id", "drug_assay_id", "experiment_synapse_id", "study_synapse_id", "funder", "model_name", "cellosaurus_id", "organism_name", "screen_id", "inchikey", "dosage", "dosage_unit", "response")) %>%
  mutate(response_type = "percent viability", response_unit = "%", model_type = "cell line") %>% 
  left_join(distinct(disease)) %>% 
  left_join(distinct(symptom))

write.csv(data, "combined_NF_screening_data_December_2021_release.csv", row.names = F, na = "")

syn$store(synapseclient$File("combined_NF_screening_data_December_2021_release.csv", parentId = "syn12292355",
              "resourceType" = "experimentalData",
              "dataType" = "drugScreen",
              "drugScreenType" = "smallMoleculeLibraryScreen",
              "assay" = "cellViabilityAssay"),
         used = c(ids,"syn17090820","syn16979992","syn26532681","syn26532683", "syn26532686"))


##remove old outdated data
tableId <- "syn20556247"
results <- synTableQuery(sprintf("select * from %s", tableId))
deleted <- synDelete(results)

##add new data
table <- Table(tableId, data)
table <- synStore(table)




# 
usethis::use_data(combine_drug_data, overwrite = TRUE)
