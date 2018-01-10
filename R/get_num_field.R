#' From a list of unnamed lists, or the data.frame equivalent, extract a field or -1
#'
#' @description The given list of lists is unlisted,
#'   \code{\link{extract_possibly}} extracts the value of the field or -1,
#'   another call to unlist deduplicates, and finally the result is cast to
#'   numeric.
#' @param lol (list) A list of lists
#' @param field (chr) The name of a field inside the list of lists
#' @return The field value or -1
#' @import magrittr
#' @export
#' @examples
#' \dontrun{
#' require(magrittr)
#' nest_json <- get_wastd("turtle-nest-encounters")
#' nest_hs <- nest_json$content %>% {
#'   tibble::tibble(
#'     obs = purrr::map(., c("properties", "observation_set")),
#'     hatching_success = obs %>%
#'       purrr::map(get_num_field, "hatching_success") %>% as.numeric)
#'  }
#' }
get_num_field <- function(lol, field) lol %>%
    unlist %>%
    extract_possibly(field) %>%
    unlist %>%
    as.numeric

get_chr_field <- function(lol, field) lol %>%
    unlist %>%
    purrr::possibly(magrittr::extract(., field), otherwise = NA)
    unlist %>%
    as.character
