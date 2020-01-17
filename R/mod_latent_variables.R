# Module UI
  
#' @title   mod_latent_variables_ui and mod_latent_variables_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_latent_variables
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_latent_variables_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotly::renderPlotly(
      ggplot(kairos::latent_var) +
        geom_l
    )
    
  )
}
    
# Module Server
    
#' @rdname mod_latent_variables
#' @export
#' @keywords internal
    
mod_latent_variables_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_latent_variables_ui("latent_variables_ui_1")
    
## To be copied in the server
# callModule(mod_latent_variables_server, "latent_variables_ui_1")
 
