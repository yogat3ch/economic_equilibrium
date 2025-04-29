#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_about_ui <- function(id, session = shiny::getDefaultReactiveDomain()){
  ns <- NS(id)
  ud <- session$userData
  tagList(
    includeHTML(dirs$top("Readme.html"))
  )
}

#' about Server Functions
#'
#' @noRd
mod_about_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    input <- session$input
    output <- session$output
    ud <- session$userData

  })
}

## To be copied in the UI
# mod_about_ui("about_1")

## To be copied in the server
# mod_about_server("about_1")
