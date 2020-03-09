#' Parse a \code{wastd_api_response} of \code{area} to tbl_df and sf
#'
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{area}, e.g. \code{get_wastd("area")}
#' @template param-wastd_url
#' @return A \code{tbl_df} and \code{sf} with columns:
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
parse_area_sf <- function(wastd_api_response,
                          wastd_url = wastdr::get_wastd_url()) {
  wastd_api_response %>%
    magrittr::extract2("data") %>%
    geojsonio::as.json() %>%
    geojsonsf::geojson_sf()
}


# usethis::use_test("parse_area_sf")
