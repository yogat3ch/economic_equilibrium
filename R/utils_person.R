person_make <- R6::R6Class(
  "Person",
  public = list(
    initialize = function(name, definition) {
      self$definition(name, definition)
    },
    ui_definition = function(age = TRUE, percentile = TRUE, .ns = shinyVirga::ns_find()) {
      out <- list()
      if (age)
        out[[1]] <- ui_card_age()
      if (percentile)
        out[[2]] <-
      out <- purrr::modify(out, col_widths = 12 %/% length(out))
      out <- do.call(
        bslib::layout_columns,
        out
      )
      return(out)
    },
    percentile = function(p) {
      if (!missing(p))
        private$def$percentile <- p
      return(private$def$percentile)
    },
    net_worth = function(nw) {
      if (!missing(nw))
        private$def$net_worth <- nw
      return(private$def$net_worth)
    },
    definition = function(nm, definition) {
      if (!missing(nm)) {
        private$def$name <- nm
        private$.ns <- snakecase::to_snake_case(nm)
      }
      if (!missing(definition)) {
        private$def <- purrr::list_modify(private$def, !!!definition)
        private$def$percentile <- definition$percentile
        private$def$age <- definition$age
        private$def$net_worth <- definition$net_worth
      }
      return(private$def)
    },
    ns = function(id) glue::glue("{private$.ns}_{id}")
  ),
  private = list(
    .ns = NULL,
    def = list(
      name = NULL,
      age = NULL,
      percentile = NULL,
      net_worth = NULL
    )

  )
)
