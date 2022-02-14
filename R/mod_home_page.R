# Module UI
  
#' @title   mod_home_page_ui and mod_home_page_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_home_page
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_home_page_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(align = 'center',
   box(width = 12,
       h1("kairos", align = 'center'),
       column(width = 8, offset = 2, h4("kairos provides the NF community with analytical tools to enable high-level exploration of experimental results. Currently, we support exploration of genomics data, transfer learning on gene expression data, and dose response data. Have an idea, or want to see an analysis? Email us at nf-osi@sagebionetworks.org.", align = "center")),
       # column(width = 12, offset = 3,
       #        box(h2("read the docs"), 
       #            width = 2),
       #        box(h2("explore drug screening"),
       #            width = 2),
       #        box(h2("explore genomics"),
       #            width = 2))mat <
   )
    )
  )
}
    
# Module Server
    
#' @rdname mod_home_page
#' @export
#' @keywords internal
    
mod_home_page_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_home_page_ui("home_page_ui_1")
    
## To be copied in the server
# callModule(mod_home_page_server, "home_page_ui_1")
 
