#' Convert between url-safe dash-separated-strings and Human Readable Title Case
#'
#' \lifecycle{stable}
#'
#' @param urlsafe_string (chr) A url-safe-string
#' @return a Human Readable Title Cased String
#' @export
#' @family helpers
#' @examples
#' humanize("chelonia-mydas")
#' humanize("natator-depressus")
#' humanize("successful-crawl")
humanize <- function(urlsafe_string) {
  urlsafe_string %>%
    stringr::str_to_title(.) %>%
    stringr::str_replace_all("-", " ")
}

#' Convert between url-safe dash-separated-strings and Human readable sentence case
#'
#' \lifecycle{stable}
#'
#' @param urlsafe_string (chr) A url-safe-string
#' @return a Human readable sentence cased string
#' @export
#' @family helpers
#' @examples
#' sentencecase("chelonia-mydas")
#' sentencecase("natator-depressus")
#' sentencecase("successful-crawl")
sentencecase <- function(urlsafe_string) {
  urlsafe_string %>%
    stringr::str_to_sentence(.) %>%
    stringr::str_replace_all("-", " ")
}


# usethis::use_test("humanize")
