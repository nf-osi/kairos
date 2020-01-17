#' @import shiny
#' @import shinydashboard

app_server <- function(input, output,session) {
  callModule(mod_cohort_page_server, "cohort_page_ui_1")
  callModule(mod_explore_page_server, "explore_page_ui_1")
  callModule(mod_docs_page_server, "docs_page_ui_1")
  callModule(mod_about_page_server, "about_page_ui_1")
  callModule(mod_resources_page_server, "resources_page_ui_1")
  
  ##module testing
  callModule(mod_cohort_display_server, "cohort_display_ui_2")
}
