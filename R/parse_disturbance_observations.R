#' Parse a \code{wastd_api_response} of \code{disturbance-observations} to tbl_df
#'
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{disturbance-observations}, e.g. \code{wastd_GET("disturbance-observations")}
#' @return A \code{tbl_df} with columns:
#' \itemize{
#'   \item area_name <chr>
#'   \item area_type <chr>
#'   \item area_id <int>
#'   \item site_name <chr>
#'   \item site_type <chr>
#'   \item site_id <int>
#'   \item survey_id <int>
#'   \item survey_start_time <dttm>
#'   \item survey_end_time <dttm>
#'   \item survey_start_comments <chr>
#'   \item survey_end_comments <chr>
#'   \item encounter_id <chr>
#'   \item datetime <dttm>
#'   \item longitude <dbl>
#'   \item latitude <dbl>
#'   \item crs <chr>
#'   \item location_accuracy <dbl>
#'   \item turtle_date <date>
#'   \item season <int>
#'   \item comments <chr>
#'   \item absolute_admin_url <chr>
#'   \item photos <list>
#'   \item source <chr>
#'   \item source_id <chr>
#'   \item encounter_type <chr>
#'   \item status <chr>
#'   \item observer <chr>
#'   \item reporter <chr>
#'   \item disturbance_cause <chr>
#'   \item disturbance_cause_confidence <chr>
#'   \item disturbance_severity <chr>
#'   \item disturbance_comments <chr>
#' }
#' @export
#' @import magrittr
#' @importFrom tibble tibble
#' @importFrom purrr map map_chr map_dbl
parse_disturbance_observations <- function(wastd_api_response) {
  obs <- NULL # Silence spurious R CMD check warning
  . <- NULL
  wastd_api_response$features %>% {
    tibble::tibble(
      area_name = map_chr_hack(., c("properties", "encounter", "properties", "area", "name")),
      area_type = map_chr_hack(., c("properties", "encounter", "properties", "area", "area_type")),
      area_id = map_chr_hack(., c("properties", "encounter", "properties", "area", "pk")) %>% as.integer(),
      site_name = map_chr_hack(., c("properties", "encounter", "properties", "site", "name")),
      site_type = map_chr_hack(., c("properties", "encounter", "properties", "site", "area_type")),
      site_id = map_chr_hack(., c("properties", "encounter", "properties", "site", "pk")) %>% as.integer(),
      survey_id = map_chr_hack(., c("properties", "encounter", "properties", "survey", "id")) %>% as.integer(),
      survey_start_time = map_chr_hack(., c("properties", "encounter", "properties", "survey", "start_time")) %>% httpdate_as_gmt08(),
      survey_end_time = map_chr_hack(., c("properties", "encounter", "properties", "survey", "end_time")) %>% httpdate_as_gmt08(),
      survey_start_comments = map_chr_hack(., c("properties", "encounter", "properties", "survey", "start_comments")),
      survey_end_comments = map_chr_hack(., c("properties", "encounter", "properties", "survey", "end_comments")),
      encounter_id = purrr::map_chr(., c("properties", "encounter", "id")),
      datetime = purrr::map_chr(., c("properties", "encounter", "properties", "when")) %>% httpdate_as_gmt08(),
      longitude = purrr::map_dbl(., c("properties", "encounter", "properties", "longitude")),
      latitude = purrr::map_dbl(., c("properties", "encounter", "properties", "latitude")),
      crs = purrr::map_chr(., c("properties", "encounter", "properties", "crs")),
      location_accuracy = purrr::map_chr(., c("properties", "encounter", "properties", "location_accuracy")) %>% as.integer(),
      turtle_date = purrr::map_chr(., c("properties", "encounter", "properties", "when")) %>% httpdate_as_gmt08_turtle_date(),
      season = purrr::map_chr(., c("properties", "encounter", "properties", "when")) %>% httpdate_as_season(),
      comments = map_chr_hack(., c("properties", "encounter", "properties", "comments")),
      absolute_admin_url = purrr::map_chr(., c("properties", "encounter", "properties", "absolute_admin_url")),
      photos = purrr::map(., c("properties", "encounter", "properties", "photographs")),
      source = purrr::map_chr(., c("properties", "encounter", "properties", "source")),
      # source_id = purrr::map_chr(., c("properties", "encounter", "properties", "source_id")),
      encounter_type = purrr::map_chr(., c("properties", "encounter", "properties", "encounter_type")),
      status = purrr::map_chr(., c("properties", "encounter", "properties", "status")),
      observer = map_chr_hack(., c("properties", "encounter", "properties", "observer", "name")),
      reporter = map_chr_hack(., c("properties", "encounter", "properties", "reporter", "name")),
      disturbance_cause = purrr::map_chr(., c("properties", "disturbance_cause")),
      disturbance_cause_confidence = purrr::map_chr(., c("properties", "disturbance_cause_confidence")),
      disturbance_severity = purrr::map_chr(., c("properties", "disturbance_severity")),
      disturbance_comments = map_chr_hack(., c("properties", "comments"))
    )
  }
}
