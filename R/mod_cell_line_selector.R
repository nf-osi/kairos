#' cell_line_selector UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_cell_line_selector_ui <- function(id){
  ns <- NS(id)
  tagList(
    box(
      column(checkboxGroupInput(ns("nf1_genotypes"),label = "NF1 Genotype", choices = unique(models$nf1Genotype),
                                selected =  unique(models$nf1Genotype)),
             width = 2),
      column(checkboxGroupInput(ns("nf2_genotypes"),label = "NF2 Genotype", choices = unique(models$nf2Genotype),
                                selected =  unique(models$nf2Genotype)),
             width = 2),
             checkboxGroupInput(ns("nf2_knockdowns"),label = "NF1 Knockdowns", choices = unique(models$nf1Knockdown),
                                selected =  unique(models$nf1Knockdown)),
             checkboxGroupInput(ns("nf2_knockdowns"),label = "NF2 Knockdowns", choices = unique(models$nf2Knockdown),
                                selected =  unique(models$nf2Knockdown)),
  width = 12),
  box("here are your cell-ected cells, haha",
    DT::dataTableOutput(ns("cell_lines_table")),
  width = 12)
  )
}
    
#' cell_line_selector Server Function
#'
#' @noRd 
mod_cell_line_selector_server <- function(input, output, session){
  ns <- session$ns
  
  models <- reactive({
    kairos::drug_screening %>% 
    dplyr::select(model_name, disease_name, symptom_name, nf1Genotype, nf2Genotype, nf1Knockdown, nf2Knockdown) %>% 
    dplyr::distinct()
  })
  
  output$cell_lines_table <- DT::renderDataTable({
    models() %>% dplyr::filter(nf1Genotype %in% input$nf1_genotypes,
                                  nf2Genotype %in% input$nf2_genotypes)
  })
  
  cell_lines <- reactive({models() %>% 
                                purrr::pluck('model_name') %>% 
                                unique()})
    
}
    
## To be copied in the UI
# mod_cell_line_selector_ui("cell_line_selector_ui_1")
    
## To be copied in the server
# callModule(mod_cell_line_selector_server, "cell_line_selector_ui_1")
 
