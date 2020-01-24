# Module UI

#' @title   mod_gene_variant_ui and mod_gene_variant_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_gene_variant
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_gene_variant_ui <- function(id){
  ns <- NS(id)
  
  dashboardBody(
    tagList(
      
      # selectizeInput(ns("studyName"), label = "Study Name", choices = unique(kairos::exome_data$study),
      #                selected = unique(kairos::exome_data$study), multiple = T),
      # 
      selectizeInput(ns("Genes"), label = "Genes", choices = unique(kairos::jhu_tumor_file@data$Hugo_Symbol),
                     selected = "NF1", multiple = F),
      
      box(title = "Positional information of variants in tumor samples", 
          status = "primary", solidHeader = TRUE,
          width = 1000,
          collapsible = FALSE,
          plotOutput(ns('lollipop_plot'))
      )
      
    )
  )
}

# Module Server

#' @rdname mod_gene_variant
#' @export
#' @keywords internal

mod_gene_variant_server <- function(input, output, session, specimens){
  ns <- session$ns
  
  output$lollipop_plot <- shiny::renderPlot({
    
    tumor_sample_bc <- as.vector(kairos::jhu_tumor_file@data$Tumor_Sample_Barcode[kairos::jhu_tumor_file@clinical.data$specimenID %in% specimens()])
    file_with_specimen <- maftools::subsetMaf(kairos::jhu_tumor_file, tsb = c(tumor_sample_bc))
    
    maftools::lollipopPlot(
      kairos::jhu_tumor_file,
      gene = input$Genes,
      AACol = NULL,
      labelPos = NULL,
      labPosSize = 0.9,
      showMutationRate = TRUE,
      showDomainLabel = TRUE,
      cBioPortal = FALSE,
      refSeqID = NULL,
      proteinID = NULL,
      repel = FALSE,
      collapsePosLabel = TRUE,
      legendTxtSize = 1.5,
      labPosAngle = 0,
      domainLabelSize = 1.5,
      axisTextSize = c(1, 1),
      printCount = FALSE,
      colors = NULL,
      domainColors = NULL,
      labelOnlyUniqueDoamins = TRUE,
      defaultYaxis = FALSE,
      titleSize = c(1.2, 1),
      pointSize = 2.5
    )
    
    # maftools::oncoplot(kairos::jhu_tumor_file, 
    #                    genes = c("NF1", "EGR2"),
    #                    drawRowBar = TRUE, drawColBar = TRUE,
    #                    clinicalFeatures = c("tumorType", "sampleType","individualID"),
    #                    #sortByAnnotation = TRUE, annotationColor = color_list, groupAnnotationBySize = FALSE, 
    #                    removeNonMutated = FALSE, logColBar = FALSE,
    #                    SampleNamefont = 5,annotationFontSize = 1.5, fontSize = 1,legendFontSize = 1.8,
    #                    titleFontSize = 1.0, keepGeneOrder = TRUE, GeneOrderSort = TRUE, bgCol = "white", borderCol = "white")
  })
  
}

## To be copied in the UI
# mod_gene_variant_ui("gene_variant_ui")

## To be copied in the server
# callModule(mod_gene_variant_server, "gene_variant_ui")

