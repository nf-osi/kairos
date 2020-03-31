#' dose_response UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_dose_response_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' dose_response Server Function
#'
#' @noRd 
mod_dose_response_server <- function(input, output, session, cell_lines, compounds){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_dose_response_ui("dose_response_ui_1")
    
## To be copied in the server
# callModule(mod_dose_response_server, "dose_response_ui_1")
 
