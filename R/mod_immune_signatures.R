# Module UI
  
#' @title   mod_immune_signatures_ui and mod_immune_signatures_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_immune_signatures
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_immune_signatures_ui <- function(id){
    ns <- NS(id)
    
    tagList(
      h2("Immune Cell Deconvolution"),
      box(h4('Summary'), width = 12),
      box(plotOutput(ns('cibersort_ridgeplot')
                               # %>% shinycssloaders::withSpinner(custom.css=T) ##throws an error that looks to be css related
      ), width = 12),
      box(plotOutput(ns('mcpcounter_ridgeplot')
                               # %>% shinycssloaders::withSpinner(custom.css=T) ##throws an error that looks to be css related
      ), width = 12)
    )
    
}

# Module Server
    
#' @rdname mod_immune_signatures
#' @export
#' @keywords internal
    
mod_immune_signatures_server <- function(input, output, session, specimens){
  ns <- session$ns
  
  output$cibersort_ridgeplot <- renderPlot({
    
    foo <- kairos::immune_predictions %>% 
      dplyr::filter(specimenID %in% specimens() &
                      method == 'cibersort') 
    ggplot(foo) +
      ggridges::geom_density_ridges(aes(x = score, y=cell_type, fill = cell_type)) +
      facet_grid(cols = vars(tumorType)) +
      theme_minimal() + 
      theme(legend.position = 'none',
            text  = element_text(size = 12)) + 
      labs(x = 'Cell Type', y = "Density")

  })
  
  output$mcpcounter_ridgeplot <- renderPlot({
    
    foo <- kairos::immune_predictions %>% 
      dplyr::filter(specimenID %in% specimens() &
                      method == 'mcp_counter') 
    
    ggplot(foo) +
      ggridges::geom_density_ridges(aes(x = score, y=cell_type, fill = cell_type)) +
      facet_grid(cols = vars(tumorType)) +
      theme_minimal() + 
      theme(legend.position = 'none',
            text  = element_text(size = 12)) + 
      labs(x = 'Cell Type', y = "Density") 
    
  })

}
    
## To be copied in the UI
# mod_immune_signatures_ui("immune_signatures_ui_1")
    
## To be copied in the server
# callModule(mod_immune_signatures_server, "immune_signatures_ui_1")
 
