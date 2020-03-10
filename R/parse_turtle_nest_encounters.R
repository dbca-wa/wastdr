#' Parse a \code{wastd_api_response} of \code{turtle-nest-encounters} to tbl_df
#'
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{turtle-nest-encounters}, e.g.
#' \code{wastd_GET("turtle-nest-encounters")}
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
#'   \item turtle_date <date>
#'   \item season <int>
#'   \item season_week <int> Number of completed weeks since fiscal year start
#'   \item iso_week <int> Number of completed weeks since calendar year start
#'   \item longitude <dbl>
#'   \item latitude <dbl>
#'   \item crs <chr>
#'   \item location_accuracy <dbl>
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
#'   \item clutch_size <dbl> The calculated clutch size reconstructed from
#'   excavated eggs.
#'   \item clutch_size_fresh <dbl> The directly observed clutch size during
#'   tagging.
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
  wastd_api_response$data %>% {
    tibble::tibble(
      area_name = purrr::map_chr(
        ., c("properties", "area", "name"), .default = NA),
      area_type = purrr::map_chr(
        ., c("properties", "area", "area_type"), .default = NA),
      area_id = purrr::map_chr(
        ., c("properties", "area", "pk"), .default = NA) %>% as.integer(),

      site_name = purrr::map_chr(
        ., c("properties", "site", "name"), .default = NA),
      site_type = purrr::map_chr(
        ., c("properties", "site", "area_type"), .default = NA),
      site_id = purrr::map_chr(
        ., c("properties", "site", "pk"), .default = NA) %>% as.integer(),

      survey_id = purrr::map_chr(
        ., c("properties", "survey", "id"), .default = NA) %>% as.integer(),
      survey_start_time = purrr::map_chr(
        .,
        c("properties", "survey", "start_time"),
        .default = NA
      ) %>% httpdate_as_gmt08(),
      survey_end_time = purrr::map_chr(.,
        c("properties", "survey", "end_time"),
        .default = NA
      ) %>% httpdate_as_gmt08(),
      survey_start_comments = purrr::map_chr(.,
        c(
          "properties",
          "survey",
          "start_comments"
        ),
        .default = NA
      ),

      survey_end_comments = purrr::map_chr(., c(
        "properties", "survey", "end_comments"
      ), .default = NA),

      datetime = purrr::map_chr(
        ., c("properties", "when")) %>% httpdate_as_gmt08(),
      calendar_date_awst = datetime %>%
        lubridate::with_tz("Australia/Perth") %>%
        lubridate::floor_date(unit = "day") %>%
        as.character(),
      turtle_date = datetime %>% datetime_as_turtle_date(),
      season = datetime %>% datetime_as_season(),
      season_week = datetime %>% datetime_as_seasonweek(),
      iso_week = datetime %>% datetime_as_isoweek(),

      longitude = purrr::map_dbl(., c("properties", "longitude")),
      latitude = purrr::map_dbl(., c("properties", "latitude")),
      crs = purrr::map_chr(., c("properties", "crs")),
      location_accuracy = purrr::map_chr(
        ., c("properties", "location_accuracy")) %>% as.integer(),

      species = purrr::map_chr(., c("properties", "species")),
      nest_age = purrr::map_chr(., c("properties", "nest_age")),
      nest_type = purrr::map_chr(., c("properties", "nest_type")),
      name = map_chr_hack(., c("properties", "name")),
      habitat = purrr::map_chr(., c("properties", "habitat")),
      disturbance = purrr::map_chr(., c("properties", "disturbance")),
      comments = map_chr_hack(., c("properties", "comments")),

      absolute_admin_url = purrr::map_chr(
        ., c("properties", "absolute_admin_url")),
      obs = purrr::map(., c("properties", "observation_set")),
      photos = purrr::map(., c("properties", "photographs")),

      hatching_success = obs %>%
        purrr::map(get_num_field, "hatching_success") %>% as.numeric(),
      emergence_success = obs %>%
        purrr::map(get_num_field, "emergence_success") %>% as.numeric(),
      clutch_size = obs %>%
        purrr::map(get_num_field, "egg_count_calculated") %>% as.numeric(),
      clutch_size_fresh = obs %>%
        purrr::map(get_num_field, "egg_count") %>% as.numeric(),

      source = purrr::map_chr(., c("properties", "source")),
      source_id = purrr::map_chr(., c("properties", "source_id")),
      encounter_type = purrr::map_chr(., c("properties", "encounter_type")),
      status = purrr::map_chr(., c("properties", "status")),
      observer = map_chr_hack(., c("properties", "observer", "name")),
      reporter = map_chr_hack(., c("properties", "reporter", "name"))
    )
  }
}
