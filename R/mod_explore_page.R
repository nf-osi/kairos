a# Module UI
  
#' @title   mod_explore_page_ui and mod_explore_page_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_explore_page
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_explore_page_ui <- function(id){
  ns <- NS(id)
  tagList(
      dashboardPage(
        dashboardHeader(disable = T),
        dashboardSidebar(
          id = "explorertabs",
          menuItem("Explore Home",
                   tabName = "dashboard",
                   icon = icon("dashboard")
          ),
          menuItem("Analysis Modules",
                   icon = icon("chart-area"), startExpanded = TRUE,
                   menuSubItem(
                     "Immune Infiltration",
                     tabName = "immune_infiltration",
                     icon = icon("cog")
                   ),
                   menuSubItem(
                     "Latent Variables",
                     tabName = "latent_variables",
                     icon = icon("cog")))),
        dashboardBody(
          tagList(
            tabItems(
              tabItem(
                tabName = "dashboard"
                ),
              tabItem(
                tabName = 'immune_infiltration'
                ),
              tabItem(
                tabName = "latent_variables",
                mod_latent_variables_ui(ns("latent_variables_ui_1"))
              )
              ))
        )
      )
  )
}
    
# Module Server
    
#' @rdname mod_explore_page
#' @export
#' @keywords internal
    
mod_explore_page_server <- function(input, output, session, specimens){
  ns <- session$ns
  
  callModule(mod_latent_variables_server, "latent_variables_ui_1", specimens)  
}
    
## To be copied in the UI
# mod_explore_page_ui("explore_page_ui_1")
    
## To be copied in the server
# callModule(mod_explore_page_server, "explore_page_ui_1")
 
