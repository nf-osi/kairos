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
    box(selectizeInput(ns("selected_compounds"), "Select up to 5 compounds",
                            choices = kairos::drug_names$common_name,  options = list(maxItems = 5))),
  
  box(DT::DTOutput(ns('drug_table'))))
}
    
#' compound_selector Server Function
#'
#' @noRd 
mod_compound_selector_server <- function(input, output, session){
  ns <- session$ns

  output$drug_table <- DT::renderDataTable({
    kairos::drug_names %>% dplyr::filter(common_name %in% input$selected_compounds)
  })
  
  compounds <- reactive({
      kairos::drug_names %>% 
      dplyr::filter(common_name %in% input$selected_compounds) %>% 
      dplyr::distinct() %>%  
      purrr::pluck('DT_explorer_internal_id')
    })
 
}
    
## To be copied in the UI
# mod_compound_selector_ui("compound_selector_ui_1")
    
## To be copied in the server
# callModule(mod_compound_selector_server, "compound_selector_ui_1")
 
