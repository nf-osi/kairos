#' @import shiny
#' @import shinydashboard

app_server <- function(input, output,session) {
  callModule(mod_home_page_server, "home_page_ui_1")
  callModule(mod_genomics_page_server, "genomics_page_ui_1")
  callModule(mod_drug_screening_page_server, "drug_screening_page_ui_1")
  callModule(mod_docs_page_server, "docs_page_ui_1")
  callModule(mod_about_page_server, "about_page_ui_1")
  # callModule(mod_resources_page_server, "resources_page_ui_1")
}
