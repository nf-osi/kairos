#' single_drug UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#' @export
#' @importFrom shiny NS tagList 
mod_single_drug_ui <- function(id){
  waiter::useWaiter()
  ns <- NS(id)
  tagList(
    box(title = "Select a molecule:",
      selectizeInput(inputId = ns("selected_single_compound"), 
                       label = "",
                       choices = unique(kairos::drug_names_2$synonym), 
                       multiple = FALSE,
                       selected = "SELUMETINIB"),
      height = 400,
      solidHeader = T,
      status = "success"),
    box(title = "Selected Molecule:", 
        column(12, align = 'center', uiOutput(ns('selected_compound_image'))),
        column(12, align = 'center', span(h6(em('image provided by PubChem.gov'))),style="color:gray"),
        height = 400,
        solidHeader = T,
        status = "success"),
    box(title = "Dose-Response Curves",
        plotly::plotlyOutput(ns('dr_plot_single')),
        width = 12, 
        solidHeader = T,
        status = "success")
  )
}
    
#' single_drug Server Functions
#' @export
#' @noRd 
mod_single_drug_server <- function(input, output, session){
  
    ns <- session$ns
    
    single_compound <- reactive({
    
      
     kairos::drug_names_2 %>% 
        dplyr::filter(synonym %in% input$selected_single_compound) %>% 
        dplyr::distinct()
    })
    
    output$selected_compound_image <- renderUI({
      
      validate(
        need(!is.na(single_compound()$screen_id), 'Please select a molecule.'),
      )
      
      validate(
        need(!is.na(single_compound()$inchikey[1]), 'No structural information available for this molecule.')
      )
      
      foo <- kairos::get_chemical_image(single_compound()$inchikey[1])
      tags$img(src = foo)
    })
    
    dr_data_single <- reactive({
      
      metrics <- kairos::drug_raw_2 %>%
        dplyr::filter(screen_id %in% single_compound()$screen_id) %>% 
        dplyr::select(drug_screen_id, dosage, response) %>%  
        dplyr::group_by(drug_screen_id) %>% 
        dplyr::summarize(dr = kairos::dose_response(dosage,response)) %>% 
        dplyr::mutate(IC50 = dr, .keep = 'unused') %>% 
        dplyr::ungroup()
      
      foo <- kairos::drug_raw_2 %>% 
        dplyr::filter(screen_id  %in% single_compound()$screen_id) %>% 
        dplyr::left_join(metrics) %>% 
        dplyr::mutate(IC50 =  dplyr::case_when(is.na(IC50) ~ "<10% impact on viability or noisy data.",
                                        !is.na(IC50) ~ paste0("IC50: ", round(IC50, 3)," µM")))
      
      foo
    })
    
    output$dr_plot_single <- plotly::renderPlotly({
      validate(
        need(!is.na(single_compound()$screen_id), 'Please select a molecule.'),
      )
      
      p1 <- ggplot(dr_data_single())+
        geom_point(aes(x = log10(dosage), y = response, color = model_name)) +
        facet_wrap( ~ model_name+IC50) +
        labs(x = "log10(dose) µM", y = "% viability (compared to control)")    

      plotly::ggplotly(p1)
    })
    
}
    
## To be copied in the UI
# mod_single_drug_ui("single_drug_ui_1")
    
## To be copied in the server
# mod_single_drug_server("single_drug_ui_1")
