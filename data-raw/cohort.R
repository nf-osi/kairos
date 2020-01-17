#SELECT distinct modelSystemName, specimenID, studyName, tumorType, isCellLine, species FROM syn16858331 where specimenID is not null and tumorType is not null and specimenID not like '%,%' and isCellLine is not null and species is not null and studyName is not null
cohort <- readr::read_csv("data-raw/cohort_metadata.csv")
usethis::use_data(cohort)
