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
          p("Globally remove or add groups with these selectors:"),
          checkboxGroupInput(ns("tumorType"), label = "Tumor Type", choices = unique(cohort$tumorType),
                              selected =  unique(cohort$tumorType)),
          checkboxGroupInput(ns('isCellLine'), label = "Is Cell Line", choices = unique(cohort$isCellLine), 
                             selected = unique(cohort$isCellLine)),
          checkboxGroupInput(ns("species"), label = "Species", choices = unique(cohort$species), 
                              selected = unique(cohort$species)),
          selectizeInput(ns("studyName"), label = "Study Name", choices = unique(cohort$studyName),
                          selected = unique(cohort$studyName), multiple = T)),
      dashboardBody(
        h2("Select a Cohort"),
        box(p("The first step to any kairos analysis is building a cohort. The selector on the left allows you 
              to add or remove biological specimens based on metadata such as tumor type, species, and the study it comes from.
              A graphical summary (below) indicates the analyses that are available for the cohort you've selected, and below that,
              a downloadable table shows which specimens you've selected."),
            width = 12),
        box(width = 12,
            solidHeader = T,
            status = "primary",
            title = "Available Analyses", 
            p("Not all samples have compatible data for all analyses. Here's a summary of analyses available for each sample (pink)."),
            plotly::plotlyOutput(ns("sample_heatmap"))),
        box(width = 12, 
            solidHeader = T,
            status = "primary",
            title = "Cohort Data Table", 
            p(""),
            DT::dataTableOutput(ns("data_table"))))
    ))
}
    
# Module Server
    
#' @rdname mod_cohort_page
#' @export
#' @keywords internal
    
mod_cohort_page_server <- function(input, output, session){
  ns <- session$ns

  specs <- reactive({
    kairos::cohort %>%
      dplyr::filter(studyName %in% input$studyName,
                    isCellLine %in% input$isCellLine,
                    tumorType %in% input$tumorType,
                    species %in% input$species) %>%
      purrr::pluck("specimenID") %>%
      unique()
  })

  output$sample_heatmap <- renderPlotly({
    kairos::analyses %>%
      dplyr::filter(specimenID %in% specs()) %>%
      tibble::column_to_rownames("specimenID") %>%
      as.matrix() %>%
      plot_ly(z = . ,
            x = colnames(.),
            y = rownames(.),
            colors = colorRamp(c("#FFFFFF","#C94281")),
            type= "heatmap")
  })

  output$data_table <- DT::renderDataTable({
    kairos::cohort %>%
      dplyr::filter(specimenID %in% specs())
  })
  
  specimens <- reactive({ specs() })
  
}
    
## To be copied in the UI
# mod_cohort_page_ui("cohort_page_ui_1")
    
## To be copied in the server
# callModule(mod_cohort_page_server, "cohort_page_ui_1")
 
