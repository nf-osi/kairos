#' dose_response 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#' @export 
#' @import dr4pl
#' @noRd

dose_response <- function(dosage, response){
  if(min(response) > 90){
    res <- NA
  } else {
    res <- tryCatch({
      dr4pl::dr4pl(response ~ dosage) %>% 
        dr4pl::IC(c(50)) %>% 
        as.numeric()
      }, error = function(e){
        res <-  NA
      })
  }
  res
}