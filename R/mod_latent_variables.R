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
#' @import plotly
mod_latent_variables_ui <- function(id){
  ns <- NS(id)
  
  tagList(
    box(plotly::plotlyOutput(ns('top_lv')
                             # %>% shinycssloaders::withSpinner(custom.css=T) ##throws an error that looks to be css related
                             ), width = 6),
    box(plotly::plotlyOutput(ns('individual_lv_plot')
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
     dplyr::mutate(latent_var = stringr::str_trunc(latent_var, 15)) %>% 
     mutate(x = latent_var, y = value)
      
   # print(foo2)
   # 
   # ggplot(foo2) +
   #  geom_boxplot(aes(x=, y=value)) +
   #   theme_minimal() +
   #   theme(axis.text.x = element_text(angle = 45)) +
   #   labs(x = 'Latent Variable', y = "Expression")
   # 
   #  plotly::ggplotly(source = 'lv_overview', tooltip = 'x')
     kairos::create_boxplot(foo2, 
                            source_name = "lv_overview", 
                            color_col = NA
                            # ,reorder_fun = sd #work in progress...
                            ) %>% 
       remove_legend() 
  })
  
  output$individual_lv_plot <- renderPlotly({
    d <- event_data("plotly_click", source = 'lv_overview')
    lv <- unique(d$x)
    
    validate(need(length(lv)==1, "Click a box on the left plot to examine individual latent variables."))
    
    foo2 <- kairos::latent_var %>% 
      dplyr::mutate(latent_var = stringr::str_trunc(latent_var, 15)) %>% 
      dplyr::filter(latent_var == lv)  %>% 
      mutate(x = modelOf, y = value)
    
    kairos::create_boxplot(foo2, 
                           source_name = "lv_overview", 
                           color_col = NA
                           # ,reorder_fun = sd #work in progress...
    ) %>% 
      remove_legend() 
    
  })
  
  output$lv_loadings <- renderPlotly({
    d <- event_data("plotly_click", source = 'lv_overview')
    lv <- unique(d$x)
    
    validate(need(length(lv)==1, "Click a box on the left plot to see latent variable genes."))
    
    foo2 <- kairos::latent_var %>% 
      dplyr::mutate(latent_var = stringr::str_trunc(latent_var, 15)) %>% 
      dplyr::filter(latent_var == lv)  %>% 
      mutate(x = modelOf, y = value)
    
    kairos::create_boxplot(foo2, 
                           source_name = "lv_overview", 
                           color_col = NA
                           # ,reorder_fun = sd #work in progress...
    ) %>% 
      remove_legend() 
    
  })
  
    
  ns <- session$ns
}
    
## To be copied in the UI
# mod_latent_variables_ui("latent_variables_ui_1")
    
## To be copied in the server
# callModule(mod_latent_variables_server, "latent_variables_ui_1")
 
