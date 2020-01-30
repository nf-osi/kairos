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
      box(h4('Module Summary'), 
          p('This immune cell deconvolution module can be used to estimate the presence of different types of immune cells from RNA-Seq tumor data. Two algorithms, ', 
          a(href='https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5895181/', 'CIBERSORT', .noWS = "outside"), ' and ',
          a(href='https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-1070-5', 'MCPcounter', .noWS = "outside"),
          ', were used to estimate immune cell abundance in NF tumor samples. A rightward shift of the peak indicates that the group of samples is predicted to have more of a given cell type. Please note that cell lines and non-human models are not available; only patient samples and PDX models of human tumors are available for analysis.',
          .noWS = c("after-begin", "before-end")), 
          width = 12),
      box(title = "CIBERSORT", 
          status = "primary", solidHeader = TRUE,
          width = 12,
          collapsible = FALSE,
          plotOutput(ns('cibersort_ridgeplot'))
                               # %>% shinycssloaders::withSpinner(custom.css=T) ##throws an error that looks to be css related
          ),
      box(title = "MCPcounter", 
          status = "primary", solidHeader = TRUE,
          width = 12,
          collapsible = FALSE,
          plotOutput(ns('mcpcounter_ridgeplot')
                               # %>% shinycssloaders::withSpinner(custom.css=T) ##throws an error that looks to be css related
      ))
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
 
