
#' Return multiple lists of int as chr as one list of int and discard NA.
#'
#' \lifecycle{stable}
#'
#' @param data One or several lists of integer numbers as character
#'
#' @return One list containing just the integer numbers
#' @family helpers
#' @export
#' @examples
#' list("NA,2,234,NA", "NA", "NA,NA,1") %>% chr2int()
#' list("NA,2,234,NA", "NA", "5,NA,NA,1") %>% chr2int()
chr2int <- function(data) {
  suppressWarnings(
    data %>%
      data.table::tstrsplit(",", type.convert = TRUE) %>%
      t() %>%
      unlist() %>%
      purrr::discard(., is.na) %>%
      purrr::map(as.integer)
  )
}

# usethis::use_test("chr2int")
