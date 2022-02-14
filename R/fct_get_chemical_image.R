#' get_chemical_image 
#'
#' @description Takes an InChIKey and queries the PUG-REST PubChem API for a PNG of the image.
#' 
#' @param  inchikey An InChIKey 
#'
#' @return Returns a URL to a PNG image. 
#'
#' @export
#' @noRd

get_chemical_image <- function(inchikey) {
  Sys.sleep(0.25)
  
  input <- URLencode(inchikey)
  
  statement <- glue::glue("https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/inchikey/{inchikey}/PNG")
  
  res <- httr::with_config(httr::config(http_version = 0), httr::GET(statement), override = T)
  
  res$url
}

