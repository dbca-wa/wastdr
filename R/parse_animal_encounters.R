#' Parse a \code{wastd_api_response} of \code{animal-encounters} to tbl_df
#'
#' \lifecycle{stable}
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{animal-encounters}, e.g. \code{get_wastd("animal-encounters")}
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
#'   \item longitude <chr>
#'   \item latitude <chr>
#'   \item crs <chr>
#'   \item location_accuracy <dbl>
#'   \item name <chr>
#'   \item species <chr>
#'   \item health <chr>
#'   \item sex <chr>
#'   \item maturity <chr>
#'   \item behaviour <chr>
#'   \item habitat <chr>
#'   \item activity <chr>
#'   \item nesting_event <chr>
#'   \item checked_for_injuries <chr>
#'   \item scanned_for_pit_tags <chr>
#'   \item checked_for_flipper_tags <chr>
#'   \item cause_of_death <chr>
#'   \item cause_of_death_confidence <chr>
#'   \item absolute_admin_url <chr>
#'   \item obs <list>
#'   \item source <chr>
#'   \item source_id <chr>
#'   \item encounter_type <chr>
#'   \item status <chr>
#' }
#' @export
#' @family wastd
parse_animal_encounters <- function(wastd_api_response) {
  obs <- NULL # Make R CMD check happy
  datetime <- NULL

  wastd_api_response$data %>% {
    tibble::tibble(
      area_name = purrr::map_chr(.,
        c("properties", "area", "name"),
        .default = NA
      ),
      area_type = purrr::map_chr(.,
        c("properties", "area", "area_type"),
        .default = NA
      ),
      area_id = purrr::map_int(.,
        c("properties", "area", "pk"),
        .default = NA_integer_
      ),
      site_name = purrr::map_chr(.,
        c("properties", "site", "name"),
        .default = NA
      ),
      site_type = purrr::map_chr(.,
        c("properties", "site", "area_type"),
        .default = NA
      ),
      site_id = purrr::map_int(.,
        c("properties", "site", "pk"),
        .default = NA_integer_
      ),
      survey_id = purrr::map_int(.,
        c("properties", "survey", "id"),
        .default = NA_integer_
      ),
      survey_start_time = purrr::map_chr(.,
        c(
          "properties",
          "survey",
          "start_time"
        ),
        .default = NA
      ) %>%
        httpdate_as_gmt08(),
      survey_end_time = purrr::map_chr(.,
        c("properties", "survey", "end_time"),
        .default = NA
      ) %>%
        httpdate_as_gmt08(),
      survey_start_comments = purrr::map_chr(.,
        c(
          "properties",
          "survey",
          "start_comments"
        ),
        .default = NA
      ),
      survey_end_comments = purrr::map_chr(.,
        c(
          "properties",
          "survey",
          "end_comments"
        ),
        .default = NA
      ),
      datetime = purrr::map_chr(.,
        c("properties", "when"),
        .default = NA
      ) %>%
        httpdate_as_gmt08(),
      calendar_date_awst = datetime %>%
        lubridate::with_tz("Australia/Perth") %>%
        lubridate::floor_date(unit = "day") %>%
        as.character(),
      turtle_date = datetime %>% datetime_as_turtle_date(),
      season = datetime %>% datetime_as_season(),
      season_week = datetime %>% datetime_as_seasonweek(),
      iso_week = datetime %>% datetime_as_isoweek(),
      longitude = purrr::map_dbl(
        ., c("properties", "longitude"),
        .default = NA_real_
      ),
      latitude = purrr::map_dbl(
        ., c("properties", "latitude"),
        .default = NA_real_
      ),
      crs = purrr::map_chr(., c("properties", "crs"), .default = NA),
      location_accuracy = purrr::map_chr(.,
        c("properties", "location_accuracy"),
        .default = NA
      ) %>% as.numeric(),
      taxon = purrr::map_chr(., c("properties", "taxon"), .default = NA),
      name = purrr::map_chr(., c("properties", "name"), .default = NA),
      species = purrr::map_chr(., c("properties", "species"), .default = NA),
      health = purrr::map_chr(., c("properties", "health"), .default = NA),
      sex = purrr::map_chr(., c("properties", "sex"), .default = NA),
      maturity = purrr::map_chr(., c("properties", "maturity"), .default = NA),
      # behaviour = purrr::map_chr(., c("properties", "behaviour")),
      habitat = purrr::map_chr(., c("properties", "habitat"), .default = NA),
      activity = purrr::map_chr(., c("properties", "activity"), .default = NA),
      nesting_event = purrr::map_chr(.,
        c("properties", "nesting_event"),
        .default = NA
      ),
      checked_for_injuries = purrr::map_chr(.,
        c(
          "properties",
          "checked_for_injuries"
        ),
        .default = NA
      ),
      scanned_for_pit_tags = purrr::map_chr(.,
        c(
          "properties",
          "scanned_for_pit_tags"
        ),
        .default = NA
      ),
      checked_for_flipper_tags = purrr::map_chr(.,
        c(
          "properties",
          "checked_for_flipper_tags"
        ),
        .default = NA
      ),
      cause_of_death = purrr::map_chr(.,
        c(
          "properties",
          "cause_of_death"
        ),
        .default = NA
      ),
      cause_of_death_confidence = purrr::map_chr(
        .,
        c(
          "properties",
          "cause_of_death_confidence"
        ),
        .default = NA
      ),
      absolute_admin_url = purrr::map_chr(.,
        c("properties", "absolute_admin_url"),
        .default = NA
      ),
      obs = purrr::map(., c("properties", "observation_set"), .default = NA),
      source = purrr::map_chr(., c("properties", "source"), .default = NA),
      source_id = purrr::map_chr(., "id", .default = NA),
      encounter_type = purrr::map_chr(.,
        c("properties", "encounter_type"),
        .default = NA
      ),
      status = purrr::map_chr(., c("properties", "status"), .default = NA),
      observer = purrr::map_chr(.,
        c("properties", "observer", "name"),
        .default = NA
      ),
      reporter = purrr::map_chr(.,
        c("properties", "reporter", "name"),
        .default = NA
      )
    )
  }
}
