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
          mod_explore_menu_ui("explore_menu_ui_1")
        ),
        dashboardBody(
          mod_explore_body_ui("explore_body_ui_1")
        )
      )
  )
}
    
# Module Server
    
#' @rdname mod_explore_page
#' @export
#' @keywords internal
    
mod_explore_page_server <- function(input, output, session){
  ns <- session$ns
  callModule(mod_explore_menu_server, "explore_menu_ui_1")
  callModule(mod_explore_body_server, "explore_body_ui_1")
  
}
    
## To be copied in the UI
# mod_explore_page_ui("explore_page_ui_1")
    
## To be copied in the server
# callModule(mod_explore_page_server, "explore_page_ui_1")
 
