#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    bslib::page_fillable(
      bslib::input_dark_mode(id = "dark_mode", mode = "light", class = "absolute top-2 right-2"),
      theme = bslib::bs_theme(
        preset = "united",
        bg = "#E8EEED",
        font_scale = NULL,
        fg = "#000",
        primary = "#7eb6ad",
        secondary = "#dbedff",
        base_font = bslib::font_collection(
          bslib::font_google("Mukta"),
          "-apple-system",
          "BlinkMacSystemFont",
          "Segoe UI"
        ),
        code_font = bslib::font_collection(
          bslib::font_google("Roboto"),
          "Helvetica Neue",
          "Arial",
          "sans-serif"
        ),
        heading_font = bslib::font_google("Ledger"),
        `enable-shadows` = TRUE
      ) |>
        bslib::bs_add_rules(sass::sass_file("inst/app/www/style.css")),
      bslib::navset_bar(
        title = tags$span(shiny::icon("scale-balanced"), " Tools for Economic Equity"),
        bslib::input_dark_mode(id = "dark_mode", mode = "light", class = "absolute top-2 right-2"),
        # Navigation
        header = bslib::page_navbar(
          bslib::nav_panel("Home", mod_about_ui("about")),
          bslib::nav_panel("Net Worth Percentile Calculator", mod_net_worth_percentile_calculator_ui("net_worth_percentile")),
          bslib::nav_panel("Sliding Scale", mod_sliding_scale_ui("sliding_scale")),
          bslib::nav_panel("Munging", mod_munging_ui("munging")),

          id = "nav",
          navbar_options = bslib::navbar_options(
          )
        ),
        footer = tags$footer(
          class = "max-h-fit",
          shinyVirga::copyright(
            copyright_holder = shiny::a(href = "https://www.themindful.life/",
                                      target =
                                        "_blank",
                                      `aria-label` = "Stephen Holsenbeck",
                                      tags$em("Stephen Holsenbeck"))
          ),
          tags$a(href = "", shiny::icon("github"))
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    shinyVirga::use_shinyVirga(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "netWorthSlidingScale"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
