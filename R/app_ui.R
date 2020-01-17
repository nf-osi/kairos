#' @import shiny
#' @import shinydashboard

app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    navbarPage(    
      title = strong("kairos"), selected = "Cohort Builder",	
      tabPanel("Cohort Builder",
               mod_cohort_page_ui("cohort_page_ui_1"),
               icon = icon("wrench")),
      tabPanel("Explore",
               mod_explore_page_ui("explore_page_ui_1"),
               icon = icon("chart-area")),	
      tabPanel("Documentation",
               mod_docs_page_ui("docs_page_ui_1"),
               icon = icon("book-reader")),	
      tabPanel("About",
               mod_about_page_ui("about_page_ui_1"),
               icon = icon("info-circle")),	
      tabPanel("Resources",
               mod_resources_page_ui("resources_page_ui_1"),
               icon = icon("external-link")),
      tabPanel("TestingPanel", mod_cohort_display_ui("cohort_display_ui_2")),
      collapsible = TRUE,	inverse = TRUE,
      windowTitle = "kairos")
  )
}

#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'kairos')
  )
 
  tags$head(
    golem::activate_js(),
    golem::favicon(),
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
