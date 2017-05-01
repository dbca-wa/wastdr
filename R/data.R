#' 300 animal encounters (taggings, strandings and others)
#'
#' A parsed \code{wastd_api_response} with 300 animal encounters from
#' \code{get_wastd("animal-encounters")}
#'
#' @source https://strandings.dpaw.wa.gov.au/api/1/animal-encounters/?taxon=Cheloniidae&limit=10&format=json
#'
#' @format A \code{tbl_df} with columns:
#' \itemize{
#'   \item datetime (dttm)
#'   \item longitude (dbl)
#'   \item latitude (dbl)
#'   \item crs (chr)
#'   \item location_accuracy (dbl)
#'   \item date (date)
#'   \item species (chr)
#'   \item health (chr)
#'   \item sex (chr)
#'   \item behaviour (chr)
#'   \item habitat (chr)
#'   \item activity (chr)
#'   \item nesting_event (chr)
#'   \item checked_for_injuries (chr)
#'   \item scanned_for_pit_tags (chr)
#'   \item checked_for_flipper_tags (chr)
#'   \item cause_of_death (chr)
#'   \item cause_of_death_confidence (chr)
#'   \item absolute_admin_url (chr)
#'   \item obs (list)
#'   \item source (chr)
#'   \item source_id (chr)
#'   \item encounter_type (chr)
#'   \item status (chr)
#' }
#' @examples
#'   head(tags)
"tags"

#' 300 turtle nest encounters (tracks and nests)
#'
#' A parsed \code{wastd_api_response} with 300 turtle nest encounters from
#' \code{get_wastd("turtle-nest-encounters")}
#'
#' @format A \code{tbl_df} with columns:
#' \itemize{
#'   \item datetime (dttm)
#'   \item longitude (dbl)
#'   \item latitude (dbl)
#'   \item crs (chr)
#'   \item location_accuracy (dbl)
#'   \item date (date)
#'   \item species (chr)
#'   \item nest_age (chr)
#'   \item nest_type (chr)
#'   \item habitat (chr)
#'   \item disturbance <chr>
#'   \item absolute_admin_url <chr>
#'   \item obs <list>
#'   \item hatching_success <dbl>
#'   \item emergence_success <dbl>
#'   \item clutch_size <dbl>
#'   \item source <chr>
#'   \item source_id <chr>
#'   \item encounter_type <chr>
#'   \item status <chr>
#' }
#' @source https://strandings.dpaw.wa.gov.au/api/1/turtle-nest-encounters/?taxon=Cheloniidae&limit=300&format=json
#' @examples
#'   head(tracks)
"tracks"

#' 300 turtle nest encounters (only nests, excluding tracks)
#'
#' A parsed \code{wastd_api_response} with 300 turtle nest encounters from
#' \code{get_wastd("turtle-nest-encounters")}
#'
#' @format A \code{tbl_df} with columns:
#' \itemize{
#'   \item datetime (dttm)
#'   \item longitude (dbl)
#'   \item latitude (dbl)
#'   \item crs (chr)
#'   \item location_accuracy (dbl)
#'   \item date (date)
#'   \item species (chr)
#'   \item nest_age (chr)
#'   \item nest_type (chr)
#'   \item habitat (chr)
#'   \item disturbance <chr>
#'   \item absolute_admin_url <chr>
#'   \item obs <list>
#'   \item hatching_success <dbl>
#'   \item emergence_success <dbl>
#'   \item clutch_size <dbl>
#'   \item source <chr>
#'   \item source_id <chr>
#'   \item encounter_type <chr>
#'   \item status <chr>
#' }
#' @source https://strandings.dpaw.wa.gov.au/api/1/turtle-nest-encounters/?taxon=Cheloniidae&limit=10&format=json&nest_type=hatched-nest
#' @examples
#'   data("nests")
#'   head(nests)
"nests"


#' AnimalEncounter WAStD API response
#'
#' This API response is parsed into wastr's data "tags"
#'
#' @source https://strandings.dpaw.wa.gov.au/api/1/animal-encounters/?taxon=Cheloniidae&limit=10&format=json
#' @examples
#' data(animal_encounters)
#' data(tags)
#' fresh_tags <- parse_animal_encounters(animal_encounters)
#' testthat::expect_equal(nrow(ta), nrow(tags))
#' # can't compare list columns like obs
#' deselect_obs <- . %>% dplyr::select(-obs)
#' testthat::expect_equal(fresh_tags %>% deselect_obs, tags %>% deselect_obs)
"animal_encounters"
