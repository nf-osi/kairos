# Module UI
  
#' @title   mod_cohort_display_ui and mod_cohort_display_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_cohort_display
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_cohort_display_ui <- function(id){
  ns <- NS(id)
  tagList(
    box(width = 12, div(DT::DTOutput(ns('data_table'))))
  )
}
    
# Module Server
    
#' @rdname mod_cohort_display
#' @export
#' @keywords internal
    
mod_cohort_display_server <- function(input, output, session){
  ns <- session$ns
  output$data_table <- DT::renderDT({
    kairos::cohort
  })
}
    
## To be copied in the UI
# mod_cohort_display_ui("cohort_display_ui_1")
    
## To be copied in the server
# callModule(mod_cohort_display_server, "cohort_display_ui_1")
 
