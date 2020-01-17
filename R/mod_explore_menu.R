# Module UI
  
#' @title   mod_explore_menu_ui and mod_explore_menu_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_explore_menu
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_explore_menu_ui <- function(id){
  ns <- NS(id)
  tagList(
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
               icon = icon("cog")
  )))
}
    
# Module Server
    
#' @rdname mod_explore_menu
#' @export
#' @keywords internal
    
mod_explore_menu_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_explore_menu_ui("explore_menu_ui_1")
    
## To be copied in the server
# callModule(mod_explore_menu_server, "explore_menu_ui_1")
 
