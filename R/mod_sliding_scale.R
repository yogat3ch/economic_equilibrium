#' sliding_scale UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sliding_scale_ui <- function(id, session = shiny::getDefaultReactiveDomain()){
  ns <- NS(id)
  ud <- session$userData
  tagList(tags$h3("Economic Equilibrium Sliding Scale"),
          tags$p("By providing a base rate for a donation or a service, the value will be scaled such that the amount offered is proportional to the net worth. This is done by using the youngest person's age as a reference range for net worth, the eldest person's percentile is used to calculate approximate net worth in the reference range. The net worth's are then divided by one another to derive the scale factor."),
          tags$p("If you saved people in the Net Worth Percentile Calculator, you can select them with the 'Choose person' dropdown, otherwise you can use the sliders to select the age and net worth percentile."),
          div(
            class = "row align-items-center",
            shinyVirga::col_6(
              mod_person_ui(ns("person_1"))
            ),
            shinyVirga::col_6(
              mod_person_ui(ns("person_2"))
            )
          ),
          div(
            class = "row",
            shinyVirga::col_4(
              uiOutput(ns("p1_pays_p2"))
            ),
            shinyVirga::col_4(
              class = "d-flex justify-content-center",
              shinyWidgets::textInputIcon(
                ns("base_rate"),
                label = "Base Rate",
                value = 50
              ) |> tagAppendAttributes(class = "inline-block"),
              shinyWidgets::actionBttn(
                ns("submit"),
                label = "Calculate",
                icon = shiny::icon("calculator"),
                style = "material-flat",
                size = "md",
                class = "inline-block mx-4 rounded-[8px]"
              )
            ),
            shinyVirga::col_4(
              uiOutput(ns("p2_pays_p1")),
            )
          )
  )

}

#' sliding_scale Server Functions
#'
#' @noRd
mod_sliding_scale_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    input <- session$input
    output <- session$output
    ud <- session$userData

    # Switch out the header for a named person if chosen

    transaction <- shinyVirga::rv(
      `person_1` = shinyVirga::rv(
        name = "Custom",
        age = NULL,
        percentile = NULL,
        net_worth = NULL
      ),
      `person_2` = shinyVirga::rv(
        name = "Custom",
        age = NULL,
        percentile = NULL,
        net_worth = NULL
      ))


    # Instantiate a server for each
    mod_person_server("person_1", transaction)
    mod_person_server("person_2", transaction)





    # Initialize rv for holding the values for the value boxes
    scaled_rates <- shinyVirga::rv(
      p1_pays_p2 = NULL,
      p2_pays_p1 = NULL
    )
    observeEvent(input$submit, {
      validate_base_rate$enable()
      req(validate_base_rate$is_valid())

      ps <- list(
        p1 = list(age = transaction$person_1$age, percentile = transaction$person_1$percentile / 100),
        p2 = list(age = transaction$person_2$age, percentile = transaction$person_2$percentile / 100)
      )
      # Use the younger person's age as the scale for net worth
      min_age <- min(purrr::map_dbl(ps, "age"))

      for (p in names(ps)) {
        self <- ps[[p]]
        if(is.null(ps[[p]]$net_worth))
          ps[[p]]$net_worth <- predict_net_worth(self, min_age)
      }
      br(as.numeric(input$base_rate))
      # If p1 is paid by p2
      scaled_rates$p1_pays_p2 <- round(sliding_scale_factor(ps$p1, ps$p2), 2)
      scaled_rates$p2_pays_p1 <- round(sliding_scale_factor(ps$p2, ps$p1), 2)

    })

    validate_base_rate <- shinyvalidate::InputValidator$new()
    validate_base_rate$add_rule("base_rate", shinyvalidate::sv_required())
    validate_base_rate$add_rule("base_rate", ~ {if(is.na(as.numeric(.))) "Must be a number"})
    br <- shiny::reactiveVal()
    output$p1_pays_p2 <- renderUI({
      req(scaled_rates$p1_pays_p2)

      bslib::value_box("If Person 1 Pays Person 2",
                       value = formattable::currency(scaled_rates$p1_pays_p2 * br()),
                       showcase = shiny::icon("arrow-right"),
                       showcase_layout = bslib::showcase_top_right(),
                       theme = bslib::value_box_theme("bg-success")
                       )
    })
    output$p2_pays_p1 <- renderUI({
      req(scaled_rates$p2_pays_p1)

      bslib::value_box("If Person 2 Pays Person 1",
                       value = formattable::currency(scaled_rates$p2_pays_p1 * br()),
                       showcase = shiny::icon("arrow-left"),
                       theme = bslib::value_box_theme("bg-success"))
    })


  })
}




## To be copied in the UI
# mod_sliding_scale_ui("sliding_scale_1")

## To be copied in the server
# mod_sliding_scale_server("sliding_scale_1")
