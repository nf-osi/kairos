# Module UI
  
#' @title   mod_genomics_page_ui and mod_genomics_page_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_genomics_page
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_genomics_page_ui <- function(id){
  ns <- NS(id)
  tagList(
      dashboardPage(
        dashboardHeader(disable = T),
         dashboardSidebar(sidebarMenu(
          id = "genomicstabs",
          menuItem("Intro",
                   tabName = "dashboard",
                   icon = icon("dna")
                   ),
          menuItem("Build Cohort",
                   tabName = 'cohort',
                   icon = icon("wrench")
                   ),
          menuItem("Run Analyses",
                   icon = icon("chart-area"), startExpanded = TRUE,
                   menuSubItem(
                     "Immune Cell Deconvolution",
                     tabName = "immune_infiltration",
                     icon = icon("cog")
                   ),
                   menuSubItem(
                     "Gene Variants",
                     tabName = "gene_var",
                     icon = icon("cog")
                   ),
                   menuSubItem(
                     "Latent Variables",
                     tabName = "latent_variables",
                     icon = icon("cog"))
                   ))),
        dashboardBody(
          tagList(
            tabItems(
              tabItem(
                tabName = "dashboard"
                ),
              tabItem(
                tabName = 'cohort',
                mod_cohort_page_ui(ns("cohort_page_ui_1"))
              ),
              tabItem(
                tabName = 'immune_infiltration',
                mod_immune_signatures_ui(ns("immune_signatures_ui_1"))
                ),
              tabItem(
                tabName = "gene_var",
                mod_gene_variant_ui(ns("gene_variant_ui"))
              ),
              tabItem(
                tabName = "latent_variables",
                mod_latent_variables_ui(ns("latent_variables_ui_1"))
              )
              ))
        )
  )
)
}
    
# Module Server
    
#' @rdname mod_genomics_page
#' @export
#' @keywords internal
    
mod_genomics_page_server <- function(input, output, session){
  ns <- session$ns
  specimens <- callModule(mod_cohort_page_server, "cohort_page_ui_1")
  callModule(mod_gene_variant_server, "gene_variant_ui", specimens)
  callModule(mod_latent_variables_server, "latent_variables_ui_1", specimens)  
  callModule(mod_immune_signatures_server, "immune_signatures_ui_1", specimens)
}
    
## To be copied in the UI
# mod_genomics_page_ui("genomics_page_ui_1")
    
## To be copied in the server
# callModule(mod_genomics_page_server, "genomics_page_ui_1")
 
