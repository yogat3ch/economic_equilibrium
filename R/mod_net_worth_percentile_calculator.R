#' net_worth_percentile_calculator UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_net_worth_percentile_calculator_ui <- function(id, session = shiny::getDefaultReactiveDomain()){
  ns <- NS(id)
  ud <- session$userData
  tagList(
    tags$h3("Net Worth Percentile Calculator"),
      tags$p("Calculate the net worth percentile by answering the following questions. For any shared assets, include only the value of the person's share."),
      bslib::layout_columns(
        col_widths = 3,
        ui_card_age(ns("age")),
        bslib::card(
          bslib::card_header("Fluid Net Worth"),
          bslib::card_body(
            helpText("This is the sum total value of all fluid assets. This includes savings & checking accounts and the total value of all investments including: stocks, shares, CODs or bonds."),
            shinyWidgets::textInputIcon(
              ns("fluid_nw"),
              label = NULL,
              placeholder = 25500
            )
          )
        ),
        bslib::card(
          bslib::card_header("Fixed Net Worth"),
          bslib::card_body(
            helpText("This is the sum total value of all fixed assets. This includes the appraised value of homes, vehicles, properties, estimated value of possessions etc."),
            shinyWidgets::textInputIcon(
              ns("fixed_nw"),
              label = NULL,
              placeholder = 120000
            )
          )
        ),
        bslib::card(
          bslib::card_header("Debts & Liabilities"),
          bslib::card_body(
            helpText("This is the sum total of all debts & liabilities. This includes mortgages, loans, credit card debts, outstanding hospital bills etc. The number is input as a positive value."),
            shinyWidgets::textInputIcon(
              ns("debts"),
              label = NULL,
              placeholder = 0
            )
          )
        )
      ),
      div(
        class = "flex justify-center items-center text-center",
        div(
          class = "inline-block",
          abttn(
            ns("submit"),
            label = "Calculate",
            icon = shiny::icon("calculator")
          ),
          shinyjs::hidden(
            div(
              id = ns("hidden-save"),
              class = "inline-block",
              abttn(
                ns("save"),
                label = "Save Person",
                icon = shiny::icon("floppy-disk")
              ),
              shinyWidgets::textInputIcon(
                ns("name"),
                label = "Name",
                placeholder = "Person 1"
              ) |>
                shiny::tagAppendAttributes(class = "inline-block")
            )
          )
        )
      ),
      div(
        class = "flex justify-center items-center",
        uiOutput(
          ns("percentile"),
          fill = TRUE,
          class = "w-100"
        )
      )

    )

}

#' net_worth_percentile_calculator Server Functions
#'
#' @noRd
mod_net_worth_percentile_calculator_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    input <- session$input
    output <- session$output
    ud <- session$userData
    iv <- shinyvalidate::InputValidator$new()
    iv$add_rule("age", shinyvalidate::sv_between(18,95))
    req_and_non_zero <- function() {
      shinyvalidate::compose_rules(
        shinyvalidate::sv_required(),
        ~ {
          x <- as.numeric(.)
          if (is.na(x) || x < 0) "Must be a positive number"
        }
      )
    }
    iv$add_rule("fluid_nw", req_and_non_zero())
    iv$add_rule("fixed_nw", req_and_non_zero())
    iv$add_rule("debts", req_and_non_zero())
    # Init person list in parent environment
    person <- NULL


    percentile <- eventReactive(input$submit, {
      iv$enable()

      if (!iv$is_valid()) shinyVirga::js_after("submit", status = "danger", content = "Please correct errors in the form.")
      req(input$age, input$fluid_nw, input$fixed_nw, input$debts)
      shinyjs::show(id = "hidden-save")
      person <<- percentile_net_worth(age = input$age, net_worth = as.numeric(input$fluid_nw) + as.numeric(input$fixed_nw) - as.numeric(input$debts))
      bslib::layout_columns(
        col_widths = 4,
        bslib::value_box(
          title = "Age",
          value = person$age,
          showcase = shiny::icon("image-portrait")
        ),
        bslib::value_box(
          title = "Net Worth",
          value = paste("$",person$net_worth),
          showcase = shiny::icon("money-bill")
        ),
        bslib::value_box(
          title = "Net Worth Percentile",
          value = glue::glue(round(person$percentile * 100,1), "%"),
          showcase = shiny::icon("percent"),
          theme = "bg-success"
        )
      )

    })
    save_validate <- shinyvalidate::InputValidator$new()
    save_validate$add_rule("name", shinyvalidate::sv_required())
    observeEvent(input$save, {
      save_validate$enable()
      req(save_validate$is_valid())
      ud$people[[input$name]] <- person_make$new(name = input$name, definition = person)
      shinyVirga::js_after("name", "Person Saved", position = "right", delay = "5000", status = "success")

    })
    output$percentile <- renderUI({
      percentile()
    })

  })
}

## To be copied in the UI
# mod_net_worth_percentile_calculator_ui("net_worth_percentile_calculator_1")

## To be copied in the server
# mod_net_worth_percentile_calculator_server("net_worth_percentile_calculator_1")
