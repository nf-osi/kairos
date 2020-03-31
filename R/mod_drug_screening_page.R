# Module UI
  
#' @title   mod_drug_screening_page_ui and mod_drug_screening_page_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_drug_screening_page
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_drug_screening_page_ui <- function(id){
  ns <- NS(id)
  
  tagList(
    dashboardPage(
      dashboardHeader(disable = T),
      dashboardSidebar(sidebarMenu(
        id = "genomicstabs",
        menuItem("Intro",
                 tabName = "dashboard",
                 icon = icon("pills")
        ),
        menuItem("Select Cell Lines",
                 tabName = 'cell_lines',
                 icon = icon("wrench")
        ),
        menuItem("Select Compounds",
                 tabName = 'compounds',
                 icon = icon("wrench")
        ),
        menuItem("Dose-Response",
                   tabName = "dose_response",
                   icon = icon("cog")
                 ))),
      dashboardBody(
        tagList(
          tabItems(
            tabItem(
              tabName = "dashboard"
            ),
            tabItem(
              tabName = 'cell_lines',
              mod_cell_line_selector_ui(ns("cell_line_selector_ui_1"))
            ),
            tabItem(
              tabName = 'compounds',
              mod_compound_selector_ui(ns("compound_selector_ui_1"))
            ),
            tabItem(
              tabName = 'dose_response',
              mod_dose_response_ui(ns("dose_response_ui_1"))
            )
            )
          ))
      )
    )
}
    
# Module Server
    
#' @rdname mod_drug_screening_page
#' @export
#' @keywords internal
    
mod_drug_screening_page_server <- function(input, output, session){
  ns <- session$ns
  cell_lines <- callModule(mod_cell_line_selector_server, "cell_line_selector_ui_1")
  compounds <-callModule(mod_compound_selector_server, "compound_selector_ui_1")
  callModule(mod_dose_response_server, "dose_response_ui_1", cell_lines, compounds)
}
    
## To be copied in the UI
# mod_drug_screening_page_ui("drug_screening_page_ui_1")
    
## To be copied in the server
# callModule(mod_drug_screening_page_server, "drug_screening_page_ui_1")
 
