#' compound_selector UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_compound_selector_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' compound_selector Server Function
#'
#' @noRd 
mod_compound_selector_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_compound_selector_ui("compound_selector_ui_1")
    
## To be copied in the server
# callModule(mod_compound_selector_server, "compound_selector_ui_1")
 
