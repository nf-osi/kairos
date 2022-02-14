#SELECT distinct modelSystemName, specimenID, studyName, tumorType, isCellLine, species FROM syn16858331 where specimenID is not null and tumorType is not null and specimenID not like '%,%' and isCellLine is not null and species is not null and studyName is not null
library(synapser)
synLogin()

cohort <- synTableQuery("SELECT distinct modelSystemName, specimenID, studyName, tumorType, isCellLine, species, assay FROM syn16858331 where specimenID is not null and tumorType is not null and specimenID not like '%,%' and isCellLine is not null and species is not null and studyName is not null")$filepath %>% 
  readr::read_csv() 

print(cohort$assay %>% unique())

## At present, only have visualizations that support wholeGenomeSeq, rnaSeq, exomeSeq, wholeExomeSeq, so let's filter just for those

cohort <- filter(cohort, 
                 assay %in% c("wholeGenomeSeq", "rnaSeq", "exomeSeq", "wholeExomeSeq"))
                 
usethis::use_data(cohort
                  # ,overwrite = T
                  )
