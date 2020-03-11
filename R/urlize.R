#' Convert between url-safe dash-separated-names and Human Readable Title Case
#'
#' @param human_string (chr) A Human Readable Title Cased String
#' @return A url-safe-string
#' @import magrittr
#' @importFrom stringr str_to_lower str_replace_all
#' @export
#' @family helpers
#' @examples
#' urlize("file name 1")
#' urlize("Natator depressus")
urlize <- function(human_string) {
  . <- ""
  human_string %>%
    stringr::str_to_lower(.) %>%
    stringr::str_replace_all(" ", "-")
}

# usethis::use_test("urlize")
