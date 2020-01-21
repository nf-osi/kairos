#' @import shiny
#' @import shinydashboard

app_server <- function(input, output,session) {
  specimens <- callModule(mod_cohort_page_server, "cohort_page_ui_1")
  callModule(mod_explore_page_server, "explore_page_ui_1", specimens)
  callModule(mod_docs_page_server, "docs_page_ui_1")
  callModule(mod_about_page_server, "about_page_ui_1")
  callModule(mod_resources_page_server, "resources_page_ui_1")
}
