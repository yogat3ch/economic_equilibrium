
#' Create an Age input widget
#'
#' @inheritParams shinyWidgets::textInputIcon
#' @inheritDotParams shinyWidgets::noUiSliderInput
#' @param card_wrap \code{lgl} Wrap the input in a \code{\link[bslib]{card}}?
#'
#' @returns \code{shiny.tag}
#' @export
#'

ui_card_age <- function(inputId, ..., card_wrap = TRUE) {
  out <- shinyWidgets::noUiSliderInput(
    inputId,
    min = 18,
    max = 95,
    value = 25,
    step = 1,
    ...,
    # range = list(
    #   min = 0,
    #   `25%` = 30,
    #   `50%` = 50,
    #   `75%` = 70,
    #   `100%` = 95
    # ),
    pips = list(
      mode = "values",
      values = unlist(list(18, seq(30, 95, by = 10))),
      density = 4,
      format = shinyWidgets::wNumbFormat(decimals = 0)
    ),
    format = shinyWidgets::wNumbFormat(decimals = 0)
  )
  if (card_wrap)
    out <- bslib::card(
      bslib::card_header("Age"),
      bslib::card_body(
        out
      )
    )
  return(out)
}

#' Create a percentile input widget
#' @inheritParams shinyWidgets::textInputIcon
#' @inheritDotParams shinyWidgets::noUiSliderInput
#' @param card_wrap \code{lgl} Wrap the input in a \code{\link[bslib]{card}}?
#'
#' @returns \code{shiny.tag}
#' @export
#'
ui_percentile <- function(inputId, ..., card_wrap = TRUE) {
  out <- shinyWidgets::noUiSliderInput(
    inputId,
    min = 1,
    max = 100,
    value = 50,
    step = 1,
    ...,
    # range = list(
    #   min = 0,
    #   `25%` = 30,
    #   `50%` = 50,
    #   `75%` = 70,
    #   `100%` = 95
    # ),
    pips = list(
      mode = "values",
      values = as.list(seq(0, 100, by = 25)),
      density = 4,
      format = shinyWidgets::wNumbFormat(decimals = 0)
    ),
    format = shinyWidgets::wNumbFormat(decimals = 0)
  )
  if (card_wrap)
    out <- bslib::card(
      bslib::card_header("Net Worth Percentile"),
      bslib::card_body(
        out
      )
    )
  return(out)
}

ui_person_create <- function(.ns = shinyVirga::ns_find()) {


  tags$div(
    class = "flex flex-col", # Main container using flex column for rows
    # First row spanning two columns
    tags$div(
      class = "flex w-full", # Full width row
      tags$div(
        class = "w-full p-4 text-center", # Single element taking full width
        tags$h6("Create Person")
      )
    ),
    # Second row with two 50% columns
    tags$div(
      class = "row w-full", # Full width row with flex row for columns
      tags$div(
        class = "col-md-6 p-2", # First 50% column
        ui_card_age(inputId = .ns("age"), label = "Age", card_wrap = FALSE, inline = TRUE, width = "200px")
      ),
      tags$div(
        class = "col-md-6 p-2", # Second 50% column
        ui_percentile(.ns("percentile"), label = "Net Worth Percentile", inline = TRUE, card_wrap = FALSE, width = "200px")
      )
    )
  )
}

abttn <- function(
    inputId,
    label = NULL,
    icon = NULL,
    style = "material-flat",
    color = "default",
    size = "md",
    block = FALSE,
    no_outline = TRUE,
    class = "inline-block rounded-[8px]",
    ...
  ) {
  shinyWidgets::actionBttn(
    inputId = inputId,
    label = label,
    icon = icon,
    style = style,
    size = size,
    block = block,
    no_outline = no_outline,
    class = class,
    color = color,
    ...
  )
}



card_head <- function(x) {
  glue::glue("{snakecase::to_sentence_case(names(x))}: {x[[1]]$name}")
}
