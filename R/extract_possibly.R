#' Wrap magrittr::extract to return field value or -1
#'
#' \lifecycle{stable}
#'
#' @param ... A list and a field name
#' @seealso \url{https://rdrr.io/cran/purrr/man/safely.html}
#' @export
#' @family helpers
#' @examples
#' lol <- list(field1 = 1, field2 = 2, field3 = 3, field4 = 4, field5 = 5)
#' extract_possibly(lol, "field1")
#' extract_possibly(lol, "field8")
extract_possibly <- purrr::possibly(magrittr::extract, otherwise = -1)

# usethis::use_test("extract_possibly")
