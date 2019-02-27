#' Parse a \code{wastd_api_response} of \code{area} to tbl_df
#'
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{area}, e.g. \code{get_wastd("area")}
#' @template param-wastd_url
#' @return A \code{tbl_df} with columns:
#' \itemize{
#'   \item area_name <chr>
#'   \item area_type <chr>
#'   \item area_id <int>
#'   \item northern_extent <num>
#'   \item length_surveyed_m <int>
#'   \item length_survey_roundtrip_m <int>
#' }
#' @export
#' @import magrittr
#' @importFrom tibble tibble
#' @importFrom purrr map map_chr map_dbl
#' @importFrom lubridate interval as.period
parse_surveys <- function(
                          wastd_api_response,
                          wastd_url = wastdr::get_wastd_url()) {
  . <- NULL

  wastd_api_response$features %>% {
    tibble::tibble(
      area_name = map_chr_hack(., c("properties", "name")),
      area_type = map_chr_hack(., c("properties", "area_type")),
      area_id = map_chr_hack(., c("properties", "pk")) %>% as.integer(),
      northern_extent = map_chr_hack(., c("properties", "northern_extent")) %>% as.numeric(),
      length_surveyed_m = map_chr_hack(., c("properties", "length_surveyed_m")) %>% as.integer(),
      length_survey_roundtrip_m = map_chr_hack(., c("properties", "length_survey_roundtrip_m")) %>% as.integer()
    )
  }
}
