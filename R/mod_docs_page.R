# Module UI
  
#' @title   mod_docs_page_ui and mod_docs_page_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_docs_page
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_docs_page_ui <- function(id){
  ns <- NS(id)
  tagList(
  
  )
}
    
# Module Server
    
#' @rdname mod_docs_page
#' @export
#' @keywords internal
    
mod_docs_page_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_docs_page_ui("docs_page_ui_1")
    
## To be copied in the server
# callModule(mod_docs_page_server, "docs_page_ui_1")
 
