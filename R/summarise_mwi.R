#' Filter strandings to live rescues
#'
#' \lifecycle{stable}
#'
#' @param data A dataframe with column "health", e.g. data from form
#' "Marine Wildlife Incident 0.6".
#'
#' @return The dataframe with rows matching live outcomes.
#' @export
#' @family wastd
filter_alive <- function(data) {
  data %>%
    dplyr::filter(health %in% c("na", "other", "alive", "alive-injured"))
}


#' Filter strandings to mortalities
#'
#' \lifecycle{stable}
#'
#' @param data A dataframe with column "health", e.g. data from form
#' "Marine Wildlife Incident 0.6".
#'
#' @return The dataframe with rows matching mortal outcomes.
#' @export
#' @family wastd
filter_dead <- function(data) {
  data %>%
    dplyr::filter(
      health %in% c(
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

#' Filter strandings to live rescues for ODKC data
#'
#' \lifecycle{stable}
#'
#' @param data A dataframe with column "health", e.g. data from form
#' "Marine Wildlife Incident 0.6".
#'
#' @return The dataframe with rows matching live outcomes.
#' @export
#' @family odkc
filter_alive_odkc <- function(data) {
  data %>%
    dplyr::filter(
      status_health %in% c(
        "na", "other", "alive", "alive-injured"
      )
    )
}


#' Filter strandings to mortalities for ODKC data
#'
#' \lifecycle{stable}
#'
#' @param data A dataframe with column "health", e.g. data from form
#' "Marine Wildlife Incident 0.6".
#'
#' @return The dataframe with rows matching mortal outcomes.
#' @export
#' @family odkc
filter_dead_odkc <- function(data) {
  data %>%
    dplyr::filter(
      status_health %in% c(
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
