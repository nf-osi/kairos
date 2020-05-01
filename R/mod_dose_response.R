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
    # DT::dataTableOutput(ns("dr_table")),
    plotly::plotlyOutput(ns('drug_heatmap')),
    plotly::plotlyOutput(ns('dr_plot'))
    
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

 # output$dr_table <- DT::renderDataTable({
 #   dr_data()
 # })
 
 output$drug_heatmap <- plotly::renderPlotly({
   
   mat <- kairos::drug_screening %>% dplyr::filter(DT_explorer_internal_id %in% compounds(),
                                            model_name %in% cell_lines()) %>% 
     dplyr::filter(response_type == 'IC50_abs') %>%
     dplyr::select(DT_explorer_internal_id, model_name, response) %>% 
     dplyr::group_by(DT_explorer_internal_id, model_name) %>% 
     dplyr::summarize(mean_resp = mean(response)) %>% 
     tidyr::spread(model_name, mean_resp, drop = F) %>% 
     dplyr::ungroup() %>% 
     dplyr::left_join(kairos::preferred_drug_names) %>% 
     select(-DT_explorer_internal_id) %>% 
     tibble::column_to_rownames('std_name') %>% 
     as.matrix() 
   
   plot_ly(x=colnames(mat),y=rownames(mat),z=mat,type="heatmap",colors=colorRamp(c("darkblue","white","darkred")),colorbar=list(title="Score",len=0.4),hoverinfo='text') %>%
     layout(yaxis=list(title="Condition"),xaxis=list(title="Gene"))
 })
 
 output$dr_plot <- plotly::renderPlotly({
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
 
