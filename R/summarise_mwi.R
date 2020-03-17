#' Filter animal encounters to live outcomes: tagging, in water, and rescues
#'
#' \lifecycle{stable}
#'
#' @param data A dataframe with column indicating "health",
#'   e.g. \code{wastd_data$animals} with column \code{health} or
#'   \code{odkc_data$mwi} with column \code{health_status}.
#' @param health_col The column name of the column coding animal health,
#'   default: "health" (WAStD).
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
#'   filter_alive(health_col = "status_health") %>%
#'   head()
filter_alive <- function(data, health_col = "health") {
  data %>%
    dplyr::filter(!!rlang::sym(health_col) %in% c(
      "na",
      "other",
      "alive",
      "alive-injured"
    ))
}


#' Filter animal encounters to mortalities: strandings
#'
#' \lifecycle{stable}
#'
#' @param data A dataframe with column indicating "health",
#'   e.g. \code{wastd_data$animals} with column \code{health} or
#'   \code{odkc_data$mwi} with column \code{health_status}.
#' @param health_col The column name of the column coding animal health,
#'   default: "health" (WAStD).
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
#'   filter_dead(health_col = "status_health") %>%
#'   head()
filter_dead <- function(data, health_col = "health") {
  data %>%
    dplyr::filter(
      !!rlang::sym(health_col) %in% c(
        "alive-then-died",
        "dead-advanced",
        "dead-organs-intact",
        "dead-edible",
        "dead-mummified",
        "dead-disarticulated",
        "deadedible",
        "deadadvanced"
      )
    )
}

# usethis::use_test("summarise_mwi")
