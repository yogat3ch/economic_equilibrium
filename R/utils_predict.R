#' Predict the net worth of the p1 at a specific age
#'
#' @param p1 \code{list} with variables `age` and one of `net_worth` or `p` (the percentile)
#' @param age \code{num} Age at which to predict net worth based on percentile
#' @param net_worth_models \code{list} Bureau of Labor Statistics models made with ../SCF_Munging.qmd
#' @returns predicted net worth of p1 at the age specified
#' @export
#' @seealso [percentile_net_worth()]
#' @examples
#' predict_net_worth(percentile_net_worth(age = 39, net_worth = 113000), 42)
predict_net_worth <- function(p1, age, net_worth_models = shinyVirga::get_userData("net_worth_models")) {
  force(net_worth_models)
  # Desired percentile (e.g., 75th percentile)
  desired_percentile <- p1$p
  d <- net_worth_models[[as.character(age)]]
  net_worth <- d$data$net_worth
  # Sort the unique net worth values
  sorted_net_worth <- sort(unique(net_worth))

  #Find the index of the higher number
  h <- which(d$ecdf(sorted_net_worth) >= desired_percentile)[1]
  l <- h-1

  # Find the mean of the high & low bound
  value_at_percentile <- mean(c(sorted_net_worth[h], sorted_net_worth[l]))

  return(value_at_percentile)
}

#' Calculate the percentile of the net worth given age and net worth
#'
#' @param age \code{num} Age of the person
#' @param net_worth \code{num} Net worth of the person
#' @inheritParams predict_net_worth
#' @returns \code{list} with `age`, `net_worth`, and `p` (the percentile of the net worth)
#' @export
#'
#' @examples
#' percentile_net_worth(age = 39, net_worth = 126000)
percentile_net_worth <- function(age = NULL, net_worth = NULL, net_worth_models = shinyVirga::get_userData("net_worth_models")) {
  list(age = age,
       net_worth = net_worth,
       percentile = net_worth_models[[as.character(age)]]$ecdf(net_worth))
}

#' Derive the sliding scale multiplicative factor if p1 is paid by p2
#' @inheritParams predict_net_worth
#'
#' @returns \code{num} The multiplicative factor for the base rate
#' @export
#'
#' @examples
#' sliding_scale_factor(percentile_net_worth(age = 39, net_worth = 126000, net_worth_models), percentile_net_worth(age = 42, net_worth = 250000, net_worth_models))
sliding_scale_factor <- function(p1, p2, net_worth_models = shinyVirga::get_userData("net_worth_models")) {
  # Ensure both have percentile
  purrr::walk(list(p1,p2), \(.x) {
    stopifnot(`Both people must have net_worth` = !is.null(.x$percentile))
  })

  return(p1$net_worth / p2$net_worth)
}


