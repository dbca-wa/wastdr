#' Download all turtle data from WAStD
#'
#' \lifecycle{maturing}
#'
#' @param max_records <int> The max number of records to retrieve,
#'   default: NULL (all).
#' @template param-verbose
#'
#' @return An S3 class "wastd_data" with items:
#' \itemize{
#'   \item downloaded_on An UTC POSIXct timestamp of the data snapshot generated
#'         by \code{\link{Sys.time}}.
#'   \item sites An sf object of known WAStD sites.
#'   \item areas An sf object of known WAStD localities.
#'   \item surveys A tibble of surveys, reconstructed by WAStD from
#'         Site Visit Start and End records (where given) and
#'         (TurtleNest)Encounters.
#'   \item animals A tibble of AnimalEncounters, which includes live sightings,
#'         rescues, strandings, and other incidents, and turtle tagging.
#'         Data is included from 2016 and onwards.
#'   \item tracks Turtle tracks and nests.
#'   \item nest_dist Turtle Nest and General disturbance / predation.
#'   \item nest_tags Turtle Nest Tags.
#'   \item nest_excavations Turtle Nest Excavations - hatching and emergence
#'         success.
#'   \item hatchling_morph Hatchling morphometrics from next exacavations.
#'   \item nest_fans Hatchling emergence tracks - main fan.
#'   \item nest_fan_outliers Hatchling emergence tracks - individual outliers.
#'   \item nest_lightsources - Light sources present during hatchling emergence.
#' }
#' @export
#' @family included
download_wastd_turtledata <- function(max_records = NULL,
                                      verbose = get_wastdr_verbose()) {
  if (verbose == TRUE) {
    wastdr_msg_info("Downloading Areas...")
  }
  areas_sf <- wastdr::wastd_GET("area") %>% parse_area_sf()

  areas <- areas_sf %>%
    dplyr::filter(area_type == "Locality") %>%
    dplyr::transmute(area_id = pk, area_name = name)

  sites <- areas_sf %>%
    dplyr::filter(area_type == "Site") %>%
    dplyr::transmute(site_id = pk, site_name = name) %>%
    sf::st_join(areas)

  if (verbose == TRUE) {
    wastdr_msg_info("Downloading AnimalEncounters 2016 and on...")
  }
  animals <- "animal-encounters" %>%
    wastdr::wastd_GET(
      query = list(when__year__gte = 2016),
      max_records = max_records
    ) %>%
    wastdr::parse_animal_encounters()

  if (verbose == TRUE) {
    wastdr_msg_info("Downloading turtle morphometrics...")
  }
  turtle_morph <- "turtle-morphometrics" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  # tags
  if (verbose == TRUE) {
    wastdr_msg_info("Downloading turtle tags...")
  }
  turtle_tags <- "tag-observations" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  # damages
  if (verbose == TRUE) {
    wastdr_msg_info("Downloading turtle damages...")
  }
  turtle_dmg <- "turtle-damage-observations" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  if (verbose == TRUE) {
    wastdr_msg_info("Downloading TurtleNestEncounters...")
  }
  tracks <- "turtle-nest-encounters" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_turtle_nest_encounters()

  tracks_subset <-
    tracks %>% dplyr::select(
      pk,
      nest_age,
      nest_type,
      species,
      habitat,
      disturbance,
      nest_tagged,
      logger_found,
      eggs_counted,
      hatchlings_measured,
      fan_angles_measured,
      absolute_admin_url,
      species_colours,
      nest_type_text
    )

  if (verbose == TRUE) {
    wastdr_msg_info("Downloading nest disturbances...")
  }
  nest_dist <- "turtle-nest-disturbance-observations" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(tracks_subset, by = "pk")

  if (verbose == TRUE) {
    wastdr_msg_info("Downloading nest tags...")
  }
  nest_tags <- "nest-tag-observations" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(tracks_subset, by = "pk")

  if (verbose == TRUE) {
    wastdr_msg_info("Downloading nest excavations...")
  }
  nest_excavations <- "turtle-nest-excavations" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(tracks_subset, by = "pk")

  if (verbose == TRUE) {
    wastdr_msg_info("Downloading hatchling morph...")
  }
  hatchling_morph <- "turtle-hatchling-morphometrics" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(tracks_subset, by = "pk")

  if (verbose == TRUE) {
    wastdr_msg_info("Downloading hatchling fans...")
  }
  nest_fans <- "turtle-nest-hatchling-emergences" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(tracks_subset, by = "pk")

  if (verbose == TRUE) {
    wastdr_msg_info("Downloading hatchling fan outliers...")
  }
  nest_fan_outliers <- "turtle-nest-hatchling-emergence-outliers" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(tracks_subset, by = "pk")

  if (verbose == TRUE) {
    wastdr_msg_info("Downloading light sources...")
  }
  nest_lightsources <- "turtle-nest-hatchling-emergence-light-sources" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(tracks_subset, by = "pk")


  # Track Tallies -------------------------------------------------------------#
  if (verbose == TRUE) wastdr_msg_info("Downloading LineTransectEncounters...")
  linetx <- "line-transect-encounters" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::wastd_parse()

  if (verbose == TRUE) wastdr_msg_info("Downloading track tallies...")
  track_tally <- "track-tally" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  if (verbose == TRUE) wastdr_msg_info("Downloading disturbance tallies...")
  disturbance_tally <- "turtle-nest-disturbance-tally" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  # Surveys -------------------------------------------------------------------#
  if (verbose == TRUE) {
    wastdr_msg_info("Downloading surveys...")
  }
  surveys <- "surveys" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_surveys()

  if (verbose == TRUE) {
    wastdr_msg_info("Downloading LoggerEncounters...")
  }
  loggers <- "logger-encounters" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::wastd_parse()

  structure(
    list(
      downloaded_on = Sys.time(),
      areas = areas,
      sites = sites,
      surveys = surveys,
      animals = animals,
      turtle_tags = turtle_tags,
      turtle_dmg = turtle_dmg,
      turtle_morph = turtle_morph,
      tracks = tracks,
      nest_dist = nest_dist,
      nest_tags = nest_tags,
      nest_excavations = nest_excavations,
      hatchling_morph = hatchling_morph,
      nest_fans = nest_fans,
      nest_fan_outliers = nest_fan_outliers,
      nest_lightsources = nest_lightsources,
      linetx = linetx,
      track_tally = track_tally,
      disturbance_tally = disturbance_tally,
      loggers = loggers
    ),
    class = "wastd_data"
  )
}


#' @title S3 print method for 'wastd_data'.
#' @description Prints a short representation of data returned by
#' \code{\link{download_wastd_turtledata}}.
#' @param x An object of class `wastd_data` as returned by
#'   \code{\link{download_wastd_turtledata}}.
#' @param ... Extra parameters for `print`
#' @export
#' @family included
print.wastd_data <- function(x, ...) {
  print(
    glue::glue(
      "<WAStD Data> accessed on {x$downloaded_on}\n",
      "Areas: {nrow(x$areas)}\n",
      "Sites: {nrow(x$sites)}\n",
      "Surveys: {nrow(x$surveys)}\n",
      "Animal Encounters (tags, strandings): {nrow(x$animals)}\n",
      "Turtle Nest Encounters (tracks): {nrow(x$tracks)}\n",
      "Line Transect Encounters (track tallies) {nrow(x$linetx)}\n",
      "Logger Encounters {nrow(x$loggers)}\n"
    )
  )
  invisible(x)
}

# usethis::use_test("download_wastd_turtledata")
