# Module UI
  
#' @title   mod_drug_screening_ui and mod_drug_screening_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_drug_screening
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_drug_screening_ui <- function(id){
  ns <- NS(id)
  tagList(
    h2("Drug Screening Analysis"),
    box(h4('Module Summary'), 
        p("Altera inimicus sed no. Congue consul eripuit est in. Ut blandit interesset mea, hinc congue quo ex, qui ad laudem volumus. Ius at everti torquatos. Eum aeque verear ei, postea sensibus te his. Quo viderer epicuri postulant cu, essent appareat efficiantur nec eu. Libris lobortis vix no. Vim at elit quas ullum. Elaboraret dissentiet ius ei, vix verterem scriptorem intellegebat in, vix case inimicus ne. Ea mea tale clita. Ne oblique invenire ius, ubique laboramus est an, usu ad oblique tractatos maluisset. Vide facilisis definitiones ei vim, in viris salutatus philosophia sit."),
        width = 12)
  )
}
    
# Module Server
    
#' @rdname mod_drug_screening
#' @export
#' @keywords internal
    
mod_drug_screening_server <- function(input, output, session, specimens){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_drug_screening_ui("drug_screening_ui_1")
    
## To be copied in the server
# callModule(mod_drug_screening_server, "drug_screening_ui_1")
 
