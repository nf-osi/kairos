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
#' @import ggplot2
mod_latent_variables_ui <- function(id){
  ns <- NS(id)
  
  tagList(
    box(plotly::plotlyOutput(ns('top_lv') 
                             # %>% shinycssloaders::withSpinner(custom.css=T) ##throws an error that looks to be css related
                             ), width = 6) 
    )
  
}
    
# Module Server
    
#' @rdname mod_latent_variables
#' @export
#' @keywords internal
    
mod_latent_variables_server <- function(input, output, session, specimens){
  
  output$top_lv <- plotly::renderPlotly({
    
   foo <- kairos::latent_var %>% 
      dplyr::filter(specimenID %in% specimens()) %>% 
      dplyr::group_by(latent_var) %>%
      dplyr::summarize(sdev = sd(value)) %>% 
    dplyr::top_n(10, sdev) 
   
   foo2 <- dplyr::filter(kairos::latent_var,
                         latent_var %in% foo$latent_var) %>% 
     dplyr::mutate(latent_var = stringr::str_trunc(latent_var, 15))
      
   ggplot(foo2) +
    geom_boxplot(aes(x=forcats::fct_reorder(latent_var, value, .fun = sd, .desc = T), y=value)) +
     theme_minimal() +
     theme(axis.text.x = element_text(angle = 45)) +
     labs(x = 'Latent Variable', y = "Expression")
    
   plotly::ggplotly()
  })
    
  ns <- session$ns
}
    
## To be copied in the UI
# mod_latent_variables_ui("latent_variables_ui_1")
    
## To be copied in the server
# callModule(mod_latent_variables_server, "latent_variables_ui_1")
 
