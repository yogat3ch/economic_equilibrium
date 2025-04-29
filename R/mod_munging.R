#' munging UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_munging_ui <- function(id, session = shiny::getDefaultReactiveDomain()){
  ns <- NS(id)
  ud <- session$userData
  tagList(
    tags$div(
      id = "qmd",
      tags$iframe(
        src = "www/SCF_Munging.html", # Replace with the path to your HTML
        width = "100%", # Adjust as needed
        height = "600px", # Adjust as needed
        seamless = "seamless" # Optional, for smoother rendering
      )
    )
  )
}

#' munging Server Functions
#'
#' @noRd
mod_munging_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    input <- session$input
    output <- session$output
    ud <- session$userData

  })
}

## To be copied in the UI
# mod_munging_ui("munging_1")

## To be copied in the server
# mod_munging_server("munging_1")
