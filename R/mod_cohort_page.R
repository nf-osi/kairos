# Module UI
  
#' @title   mod_cohort_page_ui and mod_cohort_page_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_cohort_page
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_cohort_page_ui <- function(id){
  ns <- NS(id)
  tagList(
    dashboardPage(
      dashboardHeader(disable = T),
      dashboardSidebar(
        mod_cohort_selector_ui("cohort_selector_ui_1")
      ),
      dashboardBody(
        h1('hello'), 
        mod_cohort_display_ui("cohort_display_ui_1")
    )))
}
    
# Module Server
    
#' @rdname mod_cohort_page
#' @export
#' @keywords internal
    
mod_cohort_page_server <- function(input, output, session){
  ns <- session$ns
  callModule(mod_cohort_selector_server, "cohort_selector_ui_1")
  callModule(mod_cohort_display_server, "cohort_display_ui_1")
}
    
## To be copied in the UI
# mod_cohort_page_ui("cohort_page_ui_1")
    
## To be copied in the server
# callModule(mod_cohort_page_server, "cohort_page_ui_1")
 
