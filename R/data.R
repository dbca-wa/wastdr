#' AnimalEncounter WAStD API response
#'
#' This API response is parsed into wastr's data "tags"
#'
#' @source https://strandings.dpaw.wa.gov.au/api/1/animal-encounters/?taxon=Cheloniidae&limit=10&format=json
#' @examples
#' \dontrun{
#' # Generate animal_encounters ("observed" by author)
#' q = list(taxon = "Cheloniidae", limit = 10, format = "json", observer = 1)
#' animal_encounters <- get_wastd("animal-encounters", query = q)
#' animals <- parse_animal_encounters(animal_encounters)
#' devtools::use_data(animal_encounters, overwrite = TRUE)
#' devtools::use_data(animals, overwrite = TRUE)
#' }
#' # Prove that animal_encounters parses to animals
#' library(dplyr)
#' data(animal_encounters)
#' data(animals)
#' fresh_animals <- parse_animal_encounters(animal_encounters)
#' testthat::expect_equal(nrow(fresh_animals), nrow(animals))
#' # Compare pickled and fresh animals excluding list columns (like obs)
#' testthat::expect_equal(fresh_animals %>% dplyr::select(-obs),
#'                        animals %>% dplyr::select(-obs))
"animal_encounters"


#' 10 example animal encounters (taggings, strandings and others)
#'
#' A parsed \code{wastd_api_response} with 10 animal encounters from
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
#'   head(animals)
"animals"


#' TurtleNestEncounter (hatched nests) WAStD API response
#'
#' This API response is parsed into wastr's data "nests".
#'
#' @source https://strandings.dpaw.wa.gov.au/api/1/turtle-nest-encounters/?taxon=Cheloniidae&limit=10&format=json&nest_type__exact=hatched-nest
#' @examples
#' \dontrun{
#' # Generate turtle_nest_encounters_hatched
#' q = list(taxon = "Cheloniidae", limit = 10, format = "json", nest_type = "hatched-nest")
#' turtle_nest_encounters_hatched <- wastdr::get_wastd("turtle-nest-encounters", query = q)
#' anonymize <- function(dict){
#'     dummy = list(name = "Test Name",
#'              username = "test_name",
#'              email = "test@email.com",
#'              phone = "")
#'     dict$properties <- dict$properties %>%
#'         purrr::update_list(observer = dummy, reporter = dummy)
#'     dict
#' }
#' turtle_nest_encounters_hatched$content <- turtle_nest_encounters_hatched$content %>% map(anonymize)
#' listviewer::jsonedit(turtle_nest_encounters_hatched$content)
#' nests <- parse_turtle_nest_encounters(turtle_nest_encounters_hatched)
#' DT::datatable(nests)
#' devtools::use_data(turtle_nest_encounters_hatched, overwrite = TRUE)
#' devtools::use_data(nests, overwrite = TRUE)
#' }
#' # Prove that turtle_nest_encounters_hatched parses to nests
#' library(dplyr)
#' data(turtle_nest_encounters_hatched)
#' data(nests)
#' fresh_nests <- parse_turtle_nest_encounters(turtle_nest_encounters_hatched)
#' testthat::expect_equal(nrow(fresh_nests), nrow(nests))
#' # Compare pickled and fresh nests excluding list columns (like obs)
#' testthat::expect_equal(fresh_nests %>% dplyr::select(-obs),
#'                        nests %>% dplyr::select(-obs))
"turtle_nest_encounters_hatched"


#' 10 example turtle nest encounters (only nests, excluding tracks)
#'
#' A parsed \code{wastd_api_response} with 10 turtle nest encounters from
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


#' TurtleNestEncounter (tracks and nests) WAStD API response
#'
#' This API response is parsed into wastr's data "tracks".
#'
#' @source https://strandings.dpaw.wa.gov.au/api/1/turtle-nest-encounters/?taxon=Cheloniidae&limit=100&format=json
#' @examples
#' \dontrun{
#' # Generate turtle_nest_encounters_hatched
#' q = list(taxon = "Cheloniidae", limit = 100, format = "json")
#' turtle_nest_encounters <- wastdr::get_wastd("turtle-nest-encounters", query = q)
#' anonymize <- function(dict){
#'     dummy = list(name = "Test Name",
#'              username = "test_name",
#'              email = "test@email.com",
#'              phone = "")
#'     dict$properties <- dict$properties %>%
#'         purrr::update_list(observer = dummy, reporter = dummy)
#'     dict
#' }
#' turtle_nest_encounters$content <- turtle_nest_encounters$content %>% map(anonymize)
#' listviewer::jsonedit(turtle_nest_encounters$content)
#' tracks <- parse_turtle_nest_encounters(turtle_nest_encounters)
#' DT::datatable(tracks)
#' devtools::use_data(turtle_nest_encounters, overwrite = TRUE)
#' devtools::use_data(tracks, overwrite = TRUE)
#' }
#' # Prove that turtle_nest_encounters_hatched parses to nests
#' library(dplyr)
#' data(turtle_nest_encounters)
#' data(tracks)
#' fresh_tracks <- parse_turtle_nest_encounters(turtle_nest_encounters)
#' testthat::expect_equal(nrow(fresh_tracks), nrow(tracks))
#' # Compare pickled and fresh tracks excluding list columns (like obs)
#' testthat::expect_equal(fresh_tracks %>% dplyr::select(-obs),
#'                        tracks %>% dplyr::select(-obs))
"turtle_nest_encounters"

#' 100 example turtle nest encounters (tracks and nests)
#'
#' A parsed \code{wastd_api_response} with 100 turtle nest encounters from
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
#' @source https://strandings.dpaw.wa.gov.au/api/1/turtle-nest-encounters/?taxon=Cheloniidae&limit=100&format=json
#' @examples
#'   head(tracks)
"tracks"
