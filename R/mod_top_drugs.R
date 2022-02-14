#' top_drugs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_top_drugs_ui <- function(id){
  ns <- NS(id)
  tagList(
      box(h4('Module Summary'), 
          p("This module allows you to compare drug responses in two cell lines. To normalize the responses, we take the entire vector of data we have for each cell line and z-score them. We then calculate the difference in z-scores to identify the drugs that have the biggest difference in response between the two cell lines. The table below contains information about each cell line:"),
          DT::dataTableOutput(ns("cell_lines_table_all")),
          width = 12),
      box(selectInput(ns("cell_line_a"),
                      label = paste("Select cell line A:"),
                      choices = NULL),
          selectInput(ns("cell_line_b"),
                      label = paste("Select cell line B:"),
                      choices = NULL),
          sliderInput(ns("n_top_compounds"),
                      label = paste("Select number of compounds to display"),
                      value = 10,
                      min = 1,
                      max = 50),
          selectInput(ns("selected_dr_metric"), "Select response metric:",
                      choices = unique(kairos::drug_screening$response_type)),
          width = 12),
      box(title = "Drug Response",  
          p("Lower values (more yellow) indicate greater sensitivity to the compound"),
          plotly::plotlyOutput(ns('top_drug_heatmap')),
          width = 12, 
          solidHeader = T,
          status = "primary"),
      box(title = "Dose Responses",
          p("Click on heatmap to render dose responses."),
          plotly::plotlyOutput(ns('top_drugs_dose_response')),
          width = 12,
          solidHeader = T,
          status = "primary")
  )
  
}
    
#' top_drugs Server Function
#'
#' @noRd 
mod_top_drugs_server <- function(input, output, session, cell_lines){
  ns <- session$ns
  
  output$cell_lines_table_all <- DT::renderDataTable({
    kairos::drug_screening %>% 
      dplyr::select(model_name, organism_name, disease_name, symptom_name, nf1Genotype, nf2Genotype, nf1Knockdown, nf2Knockdown) %>% 
      dplyr::distinct()
  })
  
  observe({
    x <- cell_lines()
    
    updateSelectInput(session, "cell_line_a",
                      label = paste("Select cell line A:"),
                      choices = x,
                      selected = NULL
                      )
  
  })
  
  observe({
    x <- cell_lines()
    
    updateSelectInput(session, "cell_line_b",
                      label = paste("Select cell line B:"), 
                      choices = setdiff(x,input$cell_line_a),
                      selected = NULL
    )
    
  })
  
  top_drug_mat <- reactive({
    mat <- kairos::drug_screening %>% dplyr::filter(model_name %in% c(input$cell_line_a, input$cell_line_b)) %>% 
      dplyr::filter(response_type %in% input$selected_dr_metric) %>%
      dplyr::select(DT_explorer_internal_id, model_name, response) %>% 
      dplyr::group_by(DT_explorer_internal_id, model_name) %>% 
      dplyr::summarize(mean_resp = mean(response)) %>% 
      dplyr::ungroup() %>% 
      dplyr::group_by(model_name) %>% 
      dplyr::mutate(z_score = (mean_resp - mean(mean_resp)) / sd(mean_resp)) %>% 
      dplyr::select(-mean_resp) %>% 
      tidyr::spread(model_name, z_score, drop = T) %>% 
      dplyr::select(!!as.name(input$cell_line_a),(!!as.name(input$cell_line_b)),DT_explorer_internal_id) %>% 
      dplyr::ungroup() %>%
      dplyr::left_join(kairos::preferred_drug_names) %>% 
      dplyr::filter(!is.na(std_name)) %>% 
      select(-DT_explorer_internal_id) %>% 
      mutate(diff=(!!as.name(input$cell_line_b))-(!!as.name(input$cell_line_a))) %>% 
      dplyr::top_n(input$n_top_compounds, diff) %>% 
      dplyr::arrange(-diff) %>% 
      dplyr::select(-diff) %>% 
      dplyr::mutate(std_name = stringr::str_trunc(std_name, 30)) %>% 
      tibble::column_to_rownames('std_name') %>% 
      as.matrix() 
  })
  
  output$top_drug_heatmap <- plotly::renderPlotly({
    
    heatmaply::heatmaply(top_drug_mat(), Rowv=F, Colv=F, 
                         dendrogram = NULL,
                         colors=  viridis::viridis(n=256, alpha = 1, begin = 1, end = 0, option = "viridis"))
  })
  
##TODO: ckean up, this is duplicated in other modules, 
dr_data <- reactive({   
  kairos::drug_raw %>% 
      dplyr::left_join(kairos::preferred_drug_names) %>% 
      select(-DT_explorer_internal_id)
  })
  
output$top_drugs_dose_response <- plotly::renderPlotly({
  
    d <- event_data("plotly_click", source = 'A')
    
    validate(
      need(!is.null(d), "Click on heatmap to plot the dose-response values.")
    )
    
    mat <- top_drug_mat()
    
    cells <- colnames(mat)
    drug  <-rownames(mat)[nrow(mat)+1-d$y] ##invert y coordinate due to descending plotting.... 
    
  
    p1 <- ggplot(dr_data() %>% 
                   dplyr::mutate(std_name = stringr::str_trunc(std_name, 30)) %>% 
                   dplyr::filter(model_name %in% cells) %>% 
                   dplyr::filter(std_name %in% drug) %>% 
                   dplyr::group_by(model_name, dosage, std_name) %>% 
                   dplyr::summarize(response = mean(response))) +
      geom_point(aes(x = log10(dosage), y = response, color = model_name,
                     text = glue::glue("Dose: {dosage} µM "))) +
      facet_wrap( ~ std_name) +
      theme_bw() + 
      labs(x = "Log10 drug concentration (µM)", y = "Measured viability") 
    
      plotly::ggplotly(p1)
  })
  
}

## To be copied in the UI
# mod_top_drugs_ui("top_drugs_ui_1")
    
## To be copied in the server
# callModule(mod_top_drugs_server, "top_drugs_ui_1")
 
