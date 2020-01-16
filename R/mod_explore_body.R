# Module UI
  
#' @title   mod_explore_body_ui and mod_explore_body_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_explore_body
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_explore_body_ui <- function(id){
  ns <- NS(id)
  tagList(
    tabItems(
      tabItem(
        tabName = "dashboard"
  )))
}
    
# Module Server
    
#' @rdname mod_explore_body
#' @export
#' @keywords internal
    
mod_explore_body_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_explore_body_ui("explore_body_ui_1")
    
## To be copied in the server
# callModule(mod_explore_body_server, "explore_body_ui_1")
 
