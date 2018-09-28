#' Parse a \code{wastd_api_response} of \code{turtle-nest-encounters} to tbl_df
#'
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{turtle-nest-encounters}, e.g. \code{wastd_GET("turtle-nest-encounters")}
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
#'   \item longitude <dbl>
#'   \item latitude <dbl>
#'   \item crs <chr>
#'   \item location_accuracy <dbl>
#'   \item turtle_date <date>
#'   \item season <int>
#'   \item species <chr>
#'   \item nest_age <chr>
#'   \item nest_type <chr>
#'   \item name <chr>
#'   \item habitat <chr>
#'   \item disturbance <chr>
#'   \item comments <chr>
#'   \item absolute_admin_url <chr>
#'   \item obs <list>
#'   \item photos <list>
#'   \item hatching_success <dbl>
#'   \item emergence_success <dbl>
#'   \item clutch_size <dbl>
#'   \item source <chr>
#'   \item source_id <chr>
#'   \item encounter_type <chr>
#'   \item status <chr>
#'   \item observer <chr>
#'   \item reporter <chr>
#' }
#' @export
#' @import magrittr
#' @importFrom tibble tibble
#' @importFrom purrr map map_chr map_dbl
parse_turtle_nest_encounters <- function(wastd_api_response) {
  obs <- NULL # Make R CMD check happy
  . <- NULL
  wastd_api_response$features %>% {
    tibble::tibble(
      area_name = map_chr_hack(., c("properties", "area", "name")),
      area_type = map_chr_hack(., c("properties", "area", "area_type")),
      area_id = map_chr_hack(., c("properties", "area", "pk")) %>% as.integer(),
      site_name = map_chr_hack(., c("properties", "site", "name")),
      site_type = map_chr_hack(., c("properties", "site", "area_type")),
      site_id = map_chr_hack(., c("properties", "site", "pk")) %>% as.integer(),
      survey_id = map_chr_hack(., c("properties", "survey", "id")) %>% as.integer(),
      survey_start_time = map_chr_hack(., c("properties", "survey", "start_time")) %>% httpdate_as_gmt08(),
      survey_end_time = map_chr_hack(., c("properties", "survey", "end_time")) %>% httpdate_as_gmt08(),
      survey_start_comments = map_chr_hack(., c("properties", "survey", "start_comments")),
      survey_end_comments = map_chr_hack(., c("properties", "survey", "end_comments")),
      datetime = purrr::map_chr(., c("properties", "when")) %>% httpdate_as_gmt08(),
      longitude = purrr::map_dbl(., c("properties", "longitude")),
      latitude = purrr::map_dbl(., c("properties", "latitude")),
      crs = purrr::map_chr(., c("properties", "crs")),
      location_accuracy = purrr::map_chr(., c("properties", "location_accuracy")) %>% as.integer(),
      turtle_date = purrr::map_chr(., c("properties", "when")) %>% httpdate_as_gmt08_turtle_date(),
      season = purrr::map_chr(., c("properties", "when")) %>% httpdate_as_season(),
      species = purrr::map_chr(., c("properties", "species")),
      nest_age = purrr::map_chr(., c("properties", "nest_age")),
      nest_type = purrr::map_chr(., c("properties", "nest_type")),
      name = map_chr_hack(., c("properties", "name")),
      habitat = purrr::map_chr(., c("properties", "habitat")),
      disturbance = purrr::map_chr(., c("properties", "disturbance")),
      comments = map_chr_hack(., c("properties", "comments")),
      absolute_admin_url = purrr::map_chr(., c("properties", "absolute_admin_url")),
      obs = purrr::map(., c("properties", "observation_set")),
      photos = purrr::map(., c("properties", "photographs")),
      hatching_success = obs %>% purrr::map(get_num_field, "hatching_success") %>% as.numeric(),
      emergence_success = obs %>% purrr::map(get_num_field, "emergence_success") %>% as.numeric(),
      clutch_size = obs %>% purrr::map(get_num_field, "egg_count_calculated") %>% as.numeric(),
      source = purrr::map_chr(., c("properties", "source")),
      source_id = purrr::map_chr(., c("properties", "source_id")),
      encounter_type = purrr::map_chr(., c("properties", "encounter_type")),
      status = purrr::map_chr(., c("properties", "status")),
      observer = map_chr_hack(., c("properties", "observer", "name")),
      reporter = map_chr_hack(., c("properties", "reporter", "name"))
    )
  }
}
