# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file


# For some reason 'markdown' fails to install into ShinyApps
# so let's install it upon app' start up
.onLoad <- function(libname, pkgname) {
  if (Sys.getenv("R_CONFIG_ACTIVE") == "shinyapps") {
  	if (nchar(system.file("", package="markdown"))==0) { # if package is not available...
  		message("Installing 'markdown'")
  		install.packages("markdown", repos = "http://cran.fhcrc.org") # ...then install it
  	}
  }
}


pkgload::load_all(export_all = FALSE,helpers = FALSE,attach_testthat = FALSE)
options( "golem.app.prod" = TRUE)
kairos::run_app() # add parameters here (if any)
