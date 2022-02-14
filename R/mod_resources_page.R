# Module UI
  
#' @title   mod_resources_page_ui and mod_resources_page_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_resources_page
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_resources_page_ui <- function(id){
  ns <- NS(id)
  tagList(
  
  )
}
    
# Module Server
    
#' @rdname mod_resources_page
#' @export
#' @keywords internal
    
mod_resources_page_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_resources_page_ui("resources_page_ui_1")
    
## To be copied in the server
# callModule(mod_resources_page_server, "resources_page_ui_1")
 
