#' Map given function, handle null as NA and flatten_chr()
#'
#' @details Use this function to extract elements with NAs from a list of lists
#' into a tibble.
#'
#' @param .x An interable data object
#' @param .f A function to map over the data
#' @param ... Extra arguments to `map()`
#' @author Jennifer Bryan https://github.com/jennybc/
#' @export
#' @examples
#' data(animal_encounters)
#' nn <- map_chr_hack(animal_encounters$features, c("properties", "name"))
#' testthat::expect_true(is.na(nn[[1]]))
#' testthat::expect_equal(nn[[2]], animal_encounters$features[[2]]$properties$name)
map_chr_hack <- function(.x, .f, ...) {
    map(.x, .f, ...) %>%
        purrr::map_if(is.null, ~ NA_character_) %>%
        purrr::flatten_chr()
}
