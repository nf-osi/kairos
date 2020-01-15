
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kairos

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/allaway/kairos.svg?branch=master)](https://travis-ci.org/allaway/kairos)
<!-- badges: end -->

The goal of kairos is to …

## Installation

You can install the latest version of kairos from with:

``` r
devtools::install_github("allaway/kairos")
```


## Contributing 

This project is using `golem`, a principled framework for building Shiny apps. Read more about `golem` [here](https://thinkr-open.github.io/golem/index.html). The rtask blog posts and getting started articles are particularly helpful. In brief, `golem` treats a shiny app as an R package. Each component of the app should be built as a module (instantiated with `golem::add_module()`. Each module should represent a single chunk of the app, for example, a panel for selecting data, or a plot of a dataset. Add packages as you would with a typical R package: `usethis::use_package(<package>)` to add the package to DESCRIPTION file, and then explicitly referencing the package when using functions (eg. `purrr::pluck()`). Run the script in `dev/run_dev.R` to run the app locally. 
