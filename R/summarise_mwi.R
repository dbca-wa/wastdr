#' Filter strandings to live rescues
#'
#' @param data A dataframe with column "health", e.g. data from form
#' "Marine Wildlife Incident 0.6".
#'
#' @return The dataframe with rows matching live outcomes.
#' @export
filter_alive <- function(data) {
    data %>%
        dplyr::filter(health %in% c("na", "other", "alive", "alive-injured"))
}


#' Filter strandings to mortalities
#'
#' @param data A dataframe with column "health", e.g. data from form
#' "Marine Wildlife Incident 0.6".
#'
#' @return The dataframe with rows matching mortal outcomes.
#' @export
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
