#' Filter animal encounters to live outcomes: tagging, in water, and rescues
#'
#' \lifecycle{stable}
#'
#' @param data A dataframe with column indicating "health",
#'   e.g. \code{wastd_data$animals} with column \code{health} or
#'   \code{odkc_data$mwi} with column \code{health_status}.
#' @return The dataframe with rows matching live outcomes.
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' wastd_data$animals %>%
#'   filter_alive() %>%
#'   head()
#'
#' data("odkc_data")
#' odkc_data$mwi %>%
#'   sf_as_tbl() %>%
#'   filter_alive() %>%
#'   head()
filter_alive <- function(data) {
  flt_col <- dplyr::case_when(
    "status_health" %in% names(data) ~ "status_health",
    TRUE ~ "health"
  )

  flt_val <- c(
    "na",
    "other",
    "alive",
    "alive-injured"
  )

  data %>% dplyr::filter(!!rlang::sym(flt_col) %in% flt_val)
}


#' Filter animal encounters to mortalities: strandings
#'
#' \lifecycle{stable}
#'
#' @param data A dataframe with column indicating "health",
#'   e.g. \code{wastd_data$animals} with column \code{health} or
#'   \code{odkc_data$mwi} with column \code{health_status}.
#' @return The dataframe with rows matching mortal outcomes.
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' wastd_data$animals %>%
#'   filter_dead() %>%
#'   head()
#'
#' data("odkc_data")
#' odkc_data$mwi %>%
#'   sf_as_tbl() %>%
#'   filter_dead() %>%
#'   head()
filter_dead <- function(data) {
  flt_col <- dplyr::case_when(
    "status_health" %in% names(data) ~ "status_health",
    TRUE ~ "health"
  )

  flt_val <- c(
    "alive-then-died",
    "dead-advanced",
    "dead-organs-intact",
    "dead-edible",
    "dead-mummified",
    "dead-disarticulated",
    "deadedible",
    "deadadvanced"
  )

  data %>% dplyr::filter(!!rlang::sym(flt_col) %in% flt_val)
}

# usethis::use_test("summarise_mwi")
