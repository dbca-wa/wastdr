
#' Return multiple lists of int as chr as one list of int and discard NA.
#'
#' @param data One or several lists of integer numbers as character
#'
#' @return One list containing just the integer numbers
#' @export
chr2int <- function(data) {
  data %>%
    data.table::tstrsplit(",", type.convert = T) %>%
    unlist() %>%
    purrr::discard(., is.na) %>%
    purrr::map(as.integer)
}


# usethis::use_test("chr2int")
