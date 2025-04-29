#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  ud <- session$userData
  ud$net_worth_models <- readRDS(dirs$inst("dependencies/net_worth_models.rds"))
  ud$people <- list()
  ud$nav <- shiny::reactiveVal()
  servers <- rlang::exprs(
    `Net Worth Percentile Calculator` = mod_net_worth_percentile_calculator_server("net_worth_percentile"),
    `Sliding Scale` = mod_sliding_scale_server("sliding_scale")
  )
  e <- environment()
  server_names <- names(servers)
  server_handler <- observeEvent(input$nav, {
    if (input$nav %in% server_names) {
      rlang::eval_bare(servers[[input$nav]], e)
      servers[[input$nav]] <<- NULL
      if (!length(servers)) {
        server_handler$destroy()
      }
    }
  })

  observeEvent(input$nav, {
    ud$nav(input$nav)
  })
}
