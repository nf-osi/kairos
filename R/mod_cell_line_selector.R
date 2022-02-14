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
      h3("Select cell lines with characteristics:"), 
      shinyWidgets::prettyCheckboxGroup(ns("nf1_genotypes"),label = "NF1 Genotype", choices = unique(kairos::drug_screening$nf1Genotype),
                                selected =  unique(kairos::drug_screening$nf1Genotype), inline = T, icon = icon('check-square')),
      shinyWidgets::prettyCheckboxGroup(ns("nf2_genotypes"),label = "NF2 Genotype", choices = unique(kairos::drug_screening$nf2Genotype),
                                selected =  unique(kairos::drug_screening$nf2Genotype), inline = T, icon = icon('check-square')),
      shinyWidgets::prettyCheckboxGroup(ns("nf1_knockdowns"),label = "NF1 Knockdowns", choices = unique(kairos::drug_screening$nf1Knockdown),
                                selected =  unique(kairos::drug_screening$nf1Knockdown), inline = T, icon = icon('check-square')),
      shinyWidgets::prettyCheckboxGroup(ns("nf2_knockdowns"),label = "NF2 Knockdowns", choices = unique(kairos::drug_screening$nf2Knockdown),
                                selected =  unique(kairos::drug_screening$nf2Knockdown), inline = T, icon = icon('check-square')),
      shinyWidgets::prettyCheckboxGroup(ns("disease_name"),label = "Disease", choices = unique(kairos::drug_screening$disease_name),
                         selected =  unique(kairos::drug_screening$disease_name), inline = T, icon = icon('check-square')),
      shinyWidgets::prettyCheckboxGroup(ns("symptom_name"),label = "Disease Manifestation", choices = unique(kairos::drug_screening$symptom_name),
                         selected =  unique(kairos::drug_screening$symptom_name), inline = T, icon = icon('check-square')),
      shinyWidgets::prettyCheckboxGroup(ns("organism_name"),label = "Species", choices = unique(kairos::drug_screening$organism_name),
                         selected =  unique(kairos::drug_screening$organism_name), inline = T, icon = icon('check-square')),
  width = 12),
  box("Selected Cell Lines:",
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
    dplyr::select(model_name, organism_name, disease_name, symptom_name, nf1Genotype, nf2Genotype, nf1Knockdown, nf2Knockdown) %>% 
    dplyr::distinct()
  })
  
  output$cell_lines_table <- DT::renderDataTable({
    models() %>% 
      dplyr::filter(nf1Genotype %in% input$nf1_genotypes &
                    nf2Genotype %in% input$nf2_genotypes &
                    nf1Knockdown %in% input$nf1_knockdowns &
                    nf2Knockdown %in% input$nf2_knockdowns &
                    organism_name %in% input$organism_name &
                    disease_name %in% input$disease_name &
                    symptom_name %in% input$symptom_name)
  })
  
  cell_lines <- reactive({
    models() %>% 
      dplyr::filter(nf1Genotype %in% input$nf1_genotypes &
                      nf2Genotype %in% input$nf2_genotypes &
                      nf1Knockdown %in% input$nf1_knockdowns &
                      nf2Knockdown %in% input$nf2_knockdowns &
                      organism_name %in% input$organism_name &
                      disease_name %in% input$disease_name &
                      symptom_name %in% input$symptom_name) %>% 
      purrr::pluck('model_name') %>% 
      unique()
    })
}
    
## To be copied in the UI
# mod_cell_line_selector_ui("cell_line_selector_ui_1")
    
## To be copied in the server
# callModule(mod_cell_line_selector_server, "cell_line_selector_ui_1")
 
