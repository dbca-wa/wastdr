#' AnimalEncounter WAStD API response
#'
#' This API response is parsed into wastr's data "tags"
#'
#' @source https://strandings.dpaw.wa.gov.au/api/1/animal-encounters/?taxon=Cheloniidae&format=json
#' @examples
#' # Prove that animal_encounters parses to animals
#'
#' library(dplyr)
#' data("animal_encounters")
#' data("animals")
#' fresh_animals <- parse_animal_encounters(animal_encounters)
"animal_encounters"


#' Example animal encounters (taggings, strandings and others)
#'
#' A parsed \code{wastd_api_response} with 10 animal encounters from
#' \code{get_wastd("animal-encounters")}
#'
#' @source https://strandings.dpaw.wa.gov.au/api/1/animal-encounters/?taxon=Cheloniidae&format=json
#'
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
#' @examples
#' head(animals)
"animals"


#' Example turtle nest encounters (only nests, excluding tracks)
#'
#' A parsed \code{wastd_api_response} with 10 turtle nest encounters from
#' \code{get_wastd("turtle-nest-encounters")}
#'
#' @format A \code{tbl_df} with columns:
#' \itemize{
#'   \item area_name <chr>
#'   \item area_type <chr>
#'   \item area_id <int>
#'   \item site_name <chr>
#'   \item site_type <chr>
#'   \item site_id <int>
#'   \item datetime <dttm>
#'   \item longitude <dbl>
#'   \item latitude <dbl>
#'   \item crs <chr>
#'   \item location_accuracy <dbl>
#'   \item date <date>
#'   \item species <chr>
#'   \item nest_age <chr>
#'   \item nest_type <chr>
#'   \item name <chr>
#'   \item habitat <chr>
#'   \item disturbance <chr>
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
#' @source https://strandings.dpaw.wa.gov.au/api/1/turtle-nest-encounters/?taxon=Cheloniidae&limit=10&format=json&nest_type=hatched-nest
#' @examples
#' data("nests")
#' head(nests)
"nests"


#' TurtleNestEncounter (tracks and nests) WAStD API response
#'
#' This API response is parsed into wastr's data "nests".
#'
#' @source https://strandings.dpaw.wa.gov.au/api/1/turtle-nest-encounters/?taxon=Cheloniidae&limit=100&format=json
#' @examples
#' # Prove that turtle_nest_encounters_hatched parses to nests
#' library(dplyr)
#' data(tne)
#' data(nests)
#' parsed_nests <- parse_turtle_nest_encounters(tne)
"tne"

#' Example turtle nest encounters (tracks and nests)
#'
#' A parsed \code{wastd_api_response} with 100 turtle nest encounters from
#' \code{get_wastd("turtle-nest-encounters")}
#'
#' @format A \code{tbl_df} with columns:
#' \itemize{
#'   \item area_name <chr>
#'   \item area_type <chr>
#'   \item area_id <int>
#'   \item site_name <chr>
#'   \item site_type <chr>
#'   \item site_id <int>
#'   \item datetime <dttm>
#'   \item longitude <dbl>
#'   \item latitude <dbl>
#'   \item crs <chr>
#'   \item location_accuracy <dbl>
#'   \item date <date>
#'   \item species <chr>
#'   \item nest_age <chr>
#'   \item nest_type <chr>
#'   \item name <chr>
#'   \item habitat <chr>
#'   \item disturbance <chr>
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
#' @source https://strandings.dpaw.wa.gov.au/api/1/turtle-nest-encounters/?taxon=Cheloniidae&limit=100&format=json
#' @examples
#' head(nests)
"nests"

utils::globalVariables(".")
