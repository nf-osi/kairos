#' @import shiny
#' @import shinydashboard

app_server <- function(input, output,session) {
  ###test data read in here
  ##SELECT distinct modelSystemName, specimenID, studyName, tumorType, isCellLine, species FROM syn16858331 where specimenID is not null and tumorType is not null and specimenID not like '%,%' and isCellLine is not null and species is not null and studyName is not null
  callModule(mod_cohort_server, "cohort_ui_1")
}
