#' Parse a \code{wastd_api_response} of \code{animal-encounters} to tbl_df
#'
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
#'   \item datetime <dttm>
#'   \item longitude <chr>
#'   \item latitude <chr>
#'   \item crs <chr>
#'   \item location_accuracy <dbl>
#'   \item date <date>
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
#' @import magrittr
#' @importFrom tibble tibble
#' @importFrom purrr map map_chr map_dbl
parse_animal_encounters <- function(wastd_api_response) {
  obs <- NULL # Make R CMD check happy
  . <- "Shut up Wesley"
  wastd_api_response$features %>% {
    tibble::tibble(
      area_name = map_chr_hack(., c("properties", "area", "name")),
      area_type = map_chr_hack(., c("properties", "area", "area_type")),
      area_id = map_chr_hack(., c("properties", "area", "pk")) %>% as.integer(),
      site_name = map_chr_hack(., c("properties", "site", "name")),
      site_type = map_chr_hack(., c("properties", "site", "area_type")),
      site_id = map_chr_hack(., c("properties", "site", "pk")) %>% as.integer(),
      datetime = purrr::map_chr(., c("properties", "when")) %>%
        httpdate_as_gmt08(),
      longitude = purrr::map_dbl(., c("properties", "longitude")),
      latitude = purrr::map_dbl(., c("properties", "latitude")),
      crs = purrr::map_chr(., c("properties", "crs")),
      location_accuracy = purrr::map_chr(
        ., c("properties", "location_accuracy")
      ) %>% as.integer(),
      date = purrr::map_chr(
        ., c("properties", "when")
      ) %>% httpdate_as_gmt08_turtle_date(),
      name = map_chr_hack(., c("properties", "name")),
      species = purrr::map_chr(., c("properties", "species")),
      health = purrr::map_chr(., c("properties", "health")),
      sex = purrr::map_chr(., c("properties", "sex")),
      maturity = purrr::map_chr(., c("properties", "maturity")),
      # behaviour = purrr::map_chr(., c("properties", "behaviour")),
      habitat = purrr::map_chr(., c("properties", "habitat")),
      activity = purrr::map_chr(., c("properties", "activity")),
      nesting_event = purrr::map_chr(., c("properties", "nesting_event")),
      checked_for_injuries = purrr::map_chr(
        ., c("properties", "checked_for_injuries")
      ),
      scanned_for_pit_tags = purrr::map_chr(
        ., c("properties", "scanned_for_pit_tags")
      ),
      checked_for_flipper_tags = purrr::map_chr(
        ., c("properties", "checked_for_flipper_tags")
      ),
      cause_of_death = purrr::map_chr(
        ., c("properties", "cause_of_death")
      ),
      cause_of_death_confidence = purrr::map_chr(
        ., c("properties", "cause_of_death_confidence")
      ),
      absolute_admin_url = purrr::map_chr(
        ., c("properties", "absolute_admin_url")
      ),
      obs = purrr::map(., c("properties", "observation_set")),
      source = purrr::map_chr(., c("properties", "source")),
      source_id = purrr::map_chr(., "id"),
      encounter_type = purrr::map_chr(
        ., c("properties", "encounter_type")
      ),
      status = purrr::map_chr(., c("properties", "status")),
      observer = map_chr_hack(., c("properties", "observer", "name")),
      reporter = map_chr_hack(., c("properties", "reporter", "name"))
    )
  }
}
