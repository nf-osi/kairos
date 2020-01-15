#' @import shiny
#' @import shinydashboard

app_server <- function(input, output,session) {
  callModule(mod_cohort_server, "cohort_ui_1")
}
