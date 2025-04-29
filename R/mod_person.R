#' person UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_person_ui <- function(id, session = shiny::getDefaultReactiveDomain()){
  ns <- NS(id)
  ud <- session$userData
  tagList(
    bslib::card(
      bslib::card_header(uiOutput(ns("header")), class = "text-center"),
      bslib::card_body(
        bslib::card_body(
          tags$div(
            class = "row", # Enable flexbox and set direction to row
            tags$div(
              class = "col-md-3 w-[45%]", # First column, 45% width, with padding
              tags$div(
                class = "flex flex-col", # Main container using flex column for rows
                # First row spanning two columns
                tags$div(
                  class = "flex w-full", # Full width row
                  tags$div(
                    class = "w-full p-4 text-center", # Single element taking full width
                    tags$h6("Choose Person")
                  )
                ),
                # Second row with two 50% columns
                tags$div(
                  class = "flex flex-col w-full", # Full width row with flex row for columns
                  shinyWidgets::slimSelectInput(
                    label = NULL,
                    ns("person"),
                    choices = c("Custom", if (length(ud$people)) {
                      purrr::map_chr(ud$people, \(.x) {
                        .x$name()
                      })
                    }),
                    width = "100%"
                  )
                )
              )
            ),
            tags$div(
              class = "col-md-1 w-[10%]", # Second column, 10% width, with padding
              tags$img(src = "www/or.png")
            ),
            tags$div(
              class = "col-md-8 w-[60%]",   # Third column, 4% width, with padding
              ui_person_create(.ns = ns)
            )
          )
        )
      )
    )

  )
}

#' person Server Functions
#'
#' @noRd
mod_person_server <- function(id, transaction){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    input <- session$input
    output <- session$output
    ud <- session$userData


    observeEvent(ud$nav(), {
      req(ud$nav() == "Sliding Scale")
      people_choices <- names(ud$people)
      shinyWidgets::updateSlimSelect(
        "person",
        choices = people_choices,
        selected = NULL
      )
    })

    observeEvent(input$age, {
      transaction[[id]]$age <- input$age
    })
    observeEvent(input$percentile, {
      transaction[[id]]$percentile <- input$percentile
    })


    observeEvent(input$person, {
      req(input$person != "Custom")
      person_def <- ud$people[[input$person]]$definition()
      shinyWidgets::updateNoUiSliderInput(
        inputId = "age",
        value = person_def$age
      )
      shinyWidgets::updateNoUiSliderInput(
        inputId = "percentile",
        value = round(person_def$percentile * 100,1)
      )
      transaction[[id]]$name <- input$person
    })


    #Instantiate a header for each
    output$header <- renderUI({
      tr <- shinyVirga::rv2l(transaction)
      tags$h4(card_head(tr[id]))
    })

  })
}

## To be copied in the UI
# mod_person_ui("person_1")

## To be copied in the server
# mod_person_server("person_1")
