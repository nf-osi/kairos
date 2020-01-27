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
#' @import ggplot2
#' @import plotly
mod_cohort_page_ui <- function(id){
  ns <- NS(id)
  tagList(
    dashboardPage(
      dashboardHeader(disable = T),
      dashboardSidebar(
          h5("Globally remove or add groups with these selectors:"),
          checkboxGroupInput(ns('isCellLine'), label = "Is Cell Line", choices = unique(cohort$isCellLine), 
                             selected = unique(cohort$isCellLine)),
          checkboxGroupInput(ns("tumorType"), label = "Tumor Type", choices = unique(cohort$tumorType),
                              selected =  unique(cohort$tumorType)),
          checkboxGroupInput(ns("species"), label = "Species", choices = unique(cohort$species), 
                              selected = unique(cohort$species)),
          selectizeInput(ns("studyName"), label = "Study Name", choices = unique(cohort$studyName),
                          selected = unique(cohort$studyName), multiple = T)),
      dashboardBody(
        box(width = 12, plotly::plotlyOutput(ns("sample_plot_1"))))
    ))
}
    
# Module Server
    
#' @rdname mod_cohort_page
#' @export
#' @keywords internal
    
mod_cohort_page_server <- function(input, output, session){
  ns <- session$ns

  specimens <- reactive({
    kairos::cohort %>%
      dplyr::filter(studyName %in% input$studyName,
                    isCellLine %in% input$isCellLine,
                    tumorType %in% input$tumorType,
                    species %in% input$species) %>% 
      purrr::pluck("specimenID") %>% 
      unique()
  })
  
  output$specimens <- reactive(specimens())
  
  output$sample_plot_1 <- renderPlotly({
    kairos::analyses %>% 
      dplyr::filter(specimenID %in% specimens()) %>% 
      tibble::column_to_rownames("specimenID") %>% 
      as.matrix() %>% 
      plot_ly(z = . ,
            x = colnames(.), 
            y = rownames(.),
            colors = colorRamp(c("#FFFFFF","#C94281")), 
            type= "heatmap")
  })

  # output$sample_plot_2 <- renderPlotly({
  #   
  #   
  # })

  # output$data_table <- DT::renderDataTable({
  #   kairos::cohort %>%
  #     dplyr::filter(studyName %in% input$studyName,
  #                   isCellLine %in% input$isCellLine,
  #                   tumorType %in% input$tumorType,
  #                   species %in% input$species) 
  # })
  
}
    
## To be copied in the UI
# mod_cohort_page_ui("cohort_page_ui_1")
    
## To be copied in the server
# callModule(mod_cohort_page_server, "cohort_page_ui_1")
 
