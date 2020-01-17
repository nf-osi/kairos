# Module UI
  
#' @title   mod_cohort_selector_ui and mod_cohort_selector_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_cohort_selector
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_cohort_selector_ui <- function(id){
  ns <- NS(id)
  tagList(
    checkboxGroupInput(ns("isCellLine"), label = "Is Cell Line", choices = unique(cohort$isCellLine), 
                       selected = unique(cohort$isCellLine)),
    checkboxGroupInput(ns("tumorType"), label = "Tumor Type", choices = unique(cohort$tumorType),
                       selected =  unique(cohort$tumorType)),
    checkboxGroupInput(ns("species"), label = "Species", choices = unique(cohort$species), 
                       selected = unique(cohort$species)),
    selectizeInput(ns("modelSystemName"), label = "Model System Name", choices = unique(cohort$modelSystemName), 
                   selected = unique(cohort$modelSystemName), multiple = T),
    selectizeInput(ns("studyName"), label = "Study Name", choices = unique(cohort$studyName),
                   selected = unique(cohort$studyName), multiple = T)
  )
}
    
# Module Server
    
#' @rdname mod_cohort_selector
#' @export
#' @keywords internal
    
mod_cohort_selector_server <- function(input, output, session){
  ns <- session$ns
  
  samples <- reactive({
    
    cohort %>% 
    dplyr::filter(studyName %in% input$studyName,
                    modelSystemName %in% input$modelSystemName,
                    isCellLine %in% input$isCellLine,
                    tumorType %in% input$tumorType,
                    species %in% input$species) %>% 
      purrr::pluck("specimenID") %>% 
      unique()
    
    })
}
    
## To be copied in the UI
# mod_cohort_selector_ui("cohort_selector_ui_1")
    
## To be copied in the server
# callModule(mod_cohort_selector_server, "cohort_selector_ui_1")
 
