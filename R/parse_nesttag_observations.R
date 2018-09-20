#' Parse a \code{wastd_api_response} of \code{nesttag_observations} to tbl_df
#'
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{nesttag_observations}, e.g. \code{wastd_GET("nesttag_observations")}
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
#'   \item datetime <dttm>
#'   \item date <date>
#'   \item longitude <dbl>
#'   \item latitude <dbl>
#'   \item crs <chr>
#'   \item location_accuracy <dbl>
#'   \item source <chr>
#'   \item source_id <chr>
#'   \item encounter_id <chr>
#'   \item absolute_admin_url <chr>
#'   \item observer <chr>
#'   \item reporter <chr>
#'   \item status <chr>
#'   \item photos <list>
#'   \item encounter_comments <chr>
#'   \item tag_status <chr>
#'   \item flipper_tag_id <chr>
#'   \item date_nest_laid <chr>
#'   \item tag_label <chr>
#' }
#' @export
#' @import magrittr
#' @importFrom tibble tibble
#' @importFrom purrr map map_chr map_dbl
parse_nesttag_observations <- function(wastd_api_response) {
  obs <- NULL # Make R CMD check happy
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

      datetime = purrr::map_chr(., c("properties", "encounter", "properties", "when")) %>% httpdate_as_gmt08(),
      date = purrr::map_chr(., c("properties", "encounter", "properties", "when")) %>% httpdate_as_gmt08_turtle_date(),
      longitude = purrr::map_dbl(., c("properties", "encounter", "properties", "longitude")),
      latitude = purrr::map_dbl(., c("properties", "encounter", "properties", "latitude")),
      crs = purrr::map_chr(., c("properties", "encounter", "properties", "crs")),
      location_accuracy = purrr::map_chr(., c("properties", "encounter", "properties", "location_accuracy")) %>% as.integer(),

      source = purrr::map_chr(., c("properties", "encounter", "properties", "source")),
      source_id = purrr::map_chr(., c("properties", "encounter", "id")),
      absolute_admin_url = map_chr_hack(., c("properties", "encounter", "properties", "absolute_admin_url")),
      observer = map_chr_hack(., c("properties", "encounter", "properties", "observer", "name")),
      reporter = map_chr_hack(., c("properties", "encounter", "properties", "reporter", "name")),
      status = purrr::map_chr(., c("properties", "encounter", "properties", "status")),

      photos = purrr::map(., c("properties", "encounter", "properties", "photographs")),
      encounter_comments = map_chr_hack(., c("properties", "encounter", "properties", "comments")),

      tag_status = purrr::map_chr(., c("properties", "status")),
      flipper_tag_id = map_chr_hack(., c("properties", "flipper_tag_id")),
      date_nest_laid = map_chr_hack(., c("properties", "date_nest_laid")) %>% httpdate_as_gmt08(),
      tag_label = map_chr_hack(., c("properties", "tag_label"))
    )
  }
}
