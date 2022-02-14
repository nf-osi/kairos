#' dose_response UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_dose_response_ui <- function(id){
  ns <- NS(id)
  tagList(
    box(h4('Module Summary'), 
        p("This module provides a look at the selected cell lines responses to the selected drugs."),
        width = 12),
    box(title = "Drug AUCs",
        selectInput(ns("selected_dr_metric"), "Select response metric:",
                    choices = unique(kairos::drug_screening$response_type)),
        plotly::plotlyOutput(ns('drug_heatmap')),
        width = 12, 
        solidHeader = T,
        status = "primary"),
    box(title = "Dose-Response Curves",
        plotly::plotlyOutput(ns('dr_plot')),
        width = 12, 
        solidHeader = T,
        status = "success")
  )
}
    
#' dose_response Server Function
#'
#' @noRd 
mod_dose_response_server <- function(input, output, session, cell_lines, compounds){
  ns <- session$ns
  
 dr_data <- reactive({
   kairos::drug_raw %>% filter(DT_explorer_internal_id %in% compounds(),
                                        model_name %in% cell_lines()) %>% 
     dplyr::left_join(kairos::preferred_drug_names) %>% 
     select(-DT_explorer_internal_id)
 })
 
 output$drug_heatmap <- plotly::renderPlotly({
   
   mat <- kairos::drug_screening %>% dplyr::filter(DT_explorer_internal_id %in% compounds(),
                                            model_name %in% cell_lines()) %>% 
     dplyr::filter(response_type %in% input$selected_dr_metric) %>%
     dplyr::select(DT_explorer_internal_id, model_name, response) %>% 
     dplyr::group_by(DT_explorer_internal_id, model_name) %>% 
     dplyr::summarize(mean_resp = mean(response)) %>% 
     tidyr::spread(model_name, mean_resp, drop = F) %>% 
     dplyr::ungroup() %>% 
     dplyr::left_join(kairos::preferred_drug_names) %>% 
     select(-DT_explorer_internal_id) %>% 
     tibble::column_to_rownames('std_name') %>% 
     as.matrix() 
   
   heatmaply::heatmaply(mat, Rowv=F, Colv=F, dendrogram = NULL, colors=  viridis::viridis(n=256, alpha = 1, begin = 1, end = 0, option = "viridis") )
 })
 
 output$dr_plot <- plotly::renderPlotly({
   
 #   get_curves <- function(data){
 #     test <- dr_data %>% 
 #       dplyr::group_by(model_name, dosage, DT_explorer_internal_id) %>% 
 #       dplyr::summarize(response = mean(response), drug_screen_id) %>% 
 #       split(.$drug_screen_id)
 # 
 # res <- lapply(test, function(x){
 #   bar <- tryCatch({
 #     foo <- nplr::nplr(x$dosage, x$response, silent = T, useLog = T)
 #     x_curve <- nplr::getXcurve(foo)
 #     y_curve <- nplr::getYcurve(foo)
 #     return(c("x" = x_curve, "y" = y_curve))
 #   }, error = function(e) {
 #     return(c("x" = NA, "y" = NA))
 #   })
 #   
 #   })
 # 
 #   }
   
   p1 <- ggplot(dr_data() %>% 
                  dplyr::group_by(model_name, dosage, std_name) %>% 
                  dplyr::summarize(response = mean(response))) +
     geom_point(aes(x = log10(dosage), y = response, color = model_name)) +
     facet_wrap( ~ std_name)
   plotly::ggplotly(p1)
 })
 
}
    
## To be copied in the UI
# mod_dose_response_ui("dose_response_ui_1")
    
## To be copied in the server
# callModule(mod_dose_response_server, "dose_response_ui_1")
 
