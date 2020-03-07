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
parse_area <- function(wastd_api_response,
                       wastd_url = wastdr::get_wastd_url()) {
  wastd_api_response$data %>% {
    tibble::tibble(
      area_name = purrr::map_chr(
        ., c("properties", "name"),
        .default = NA_character_
      ),
      area_type = purrr::map_chr(
        ., c("properties", "area_type"),
        .default = NA_character_
      ),
      area_id = purrr::map_int(
        ., c("properties", "pk"),
        .default = NA_real_
      ),
      northern_extent = purrr::map_dbl(
        ., c("properties", "northern_extent"),
        .default = NA_real_
      ),
      length_surveyed_m = purrr::map_chr(
        ., c("properties", "length_surveyed_m"),
        .default = NA
      ) %>% as.integer(),
      length_survey_roundtrip_m = purrr::map_chr(
        ., c("properties", "length_survey_roundtrip_m"),
        .default = NA
      ) %>% as.integer()
    )
  }
}

# usethis::use_test("parse_area")
