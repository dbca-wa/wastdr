#' Download all turtle data from WAStD
#'
#' \lifecycle{maturing}
#'
#' See also `??wastdr::export_wastd_turtledata` for a detailed explanation of
#' the data tables.
#'
#' Verbosity is governed by `wastdr::get_wastdr_verbose()`.
#'
#' @param max_records (int) The max number of records to retrieve,
#'   default: NULL (download all).
#' @param min_year (int) The earliest year to include.
#' @param save If supplied, the filepath to save the data object to.
#' @param compress The saveRDS compression parameter, default: "xz".
#'   Set to FALSE for faster writes and reads but larger filesize.
#'
#' @return An S3 class "wastd_data" with items:
#' \itemize{
#'   \item downloaded_on A UTC POSIXct timestamp of the data snapshot generated
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
#'   \item nest_loggers - Temperature loggers inside the nest. LoggerEncounters
#'         were migrated to become LoggerObservations.
#'   \item linetx LineTransects of Turtle Track Tally counts.
#'   \item track_tally Tally of track type/species, many per linetx.
#'   \item disturbance_tally Tally of dist/pred, many per linetx.
#' }
#' @export
#' @family api
download_wastd_turtledata <- function(max_records = NULL,
                                      min_year = 2016,
                                      save = NULL,
                                      compress = "xz") {
  # Areas ---------------------------------------------------------------------#
  wastdr_msg_info("Downloading Areas...")
  areas_sf <- wastdr::wastd_GET("area") %>% parse_area_sf()

  areas <- areas_sf %>%
    dplyr::filter(area_type == "Locality") %>%
    dplyr::transmute(area_id = pk, area_name = name)

  sites <- areas_sf %>%
    dplyr::filter(area_type == "Site") %>%
    dplyr::transmute(site_id = pk, site_name = name) %>%
    sf::st_join(areas)

  # Encounters ----------------------------------------------------------------#
  "Downloading Encounters {min_year} and on..." %>%
    glue::glue() %>%
    wastdr_msg_info()
  enc <- "encounters-fast" %>%
    wastdr::wastd_GET(
      query = list(when__year__gte = min_year),
      max_records = max_records
    ) %>%
    wastdr::wastd_parse()

  enc_subset <- enc %>%
    dplyr::select(
      -source, -encounter_type, -geometry,
      -area, -site, -survey, -observer, -reporter, -comments
    )

  obs2enc <- c("encounter_source_id" = "source_id")
  obs2enc_st <- c("encounter_source_id" = "source_id", "status" = "status")

  # AnimalEncounters ----------------------------------------------------------#
  "Downloading AnimalEncounters {min_year} and on..." %>%
    glue::glue() %>%
    wastdr_msg_info()
  animals <- "animal-encounters" %>%
    wastdr::wastd_GET(
      query = list(when__year__gte = min_year),
      max_records = max_records
    ) %>%
    wastdr::parse_animal_encounters()

  animals_subset <- animals %>%
    dplyr::select(
      source_id,
      taxon, species, health, maturity, activity, nesting_event, laparoscopy,
      checked_for_injuries, scanned_for_pit_tags, checked_for_flipper_tags,
      cause_of_death, cause_of_death_confidence, absolute_admin_url
    )

  wastdr_msg_info("Downloading turtle morphometrics...")
  turtle_morph <- "turtle-morphometrics" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  # tags
  # Tags are joined to Encounters, as they can be observed during inventory
  # while not associated to an AnimalEncounter.
  wastdr_msg_info("Downloading turtle tags...")
  turtle_tags <- "tag-observations" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(animals_subset, by = obs2enc)

  # damages
  wastdr_msg_info("Downloading turtle damages...")
  turtle_dmg <- "turtle-damage-observations" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  # TurtleNestEncounters ------------------------------------------------------#
  wastdr_msg_info("Downloading TurtleNestEncounters...")
  tracks <- "turtle-nest-encounters" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_turtle_nest_encounters()

  tracks_subset <-
    tracks %>% dplyr::select(
      # pk,
      # source,
      source_id,
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

  # Some Observations can link to either AE or TNE
  tracks_animals <- dplyr::bind_rows(tracks_subset, animals_subset)

  wastdr_msg_info("Downloading nest disturbances...")
  nest_dist <- "turtle-nest-disturbance-observations" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(tracks_subset, by = obs2enc)

  wastdr_msg_info("Downloading nest tags...")
  nest_tags <- "nest-tag-observations" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(tracks_animals, by = obs2enc)

  wastdr_msg_info("Downloading nest excavations...")
  nest_excavations <- "turtle-nest-excavations" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(tracks_animals, by = obs2enc)

  wastdr_msg_info("Downloading hatchling morph...")
  hatchling_morph <- "turtle-hatchling-morphometrics" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  wastdr_msg_info("Downloading hatchling fans...")
  nest_fans <- "turtle-nest-hatchling-emergences" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::rowwise() %>% # should use pmap instead
    dplyr::mutate(
      bearing_mean = mean_bearing(
        bearing_leftmost_track_degrees,
        bearing_rightmost_track_degrees
      ),
      bearing_mis_from = mis_bearing(
        bearing_leftmost_track_degrees,
        bearing_rightmost_track_degrees,
        bearing_to_water_degrees
      )[1],
      bearing_mis_to = mis_bearing(
        bearing_leftmost_track_degrees,
        bearing_rightmost_track_degrees,
        bearing_to_water_degrees
      )[2],
      misorientation_deg = absolute_angle(
        bearing_mis_from,
        bearing_mis_to
      )
    )


  wastdr_msg_info("Downloading hatchling fan outliers...")
  nest_fan_outliers <-
    "turtle-nest-hatchling-emergence-outliers" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  wastdr_msg_info("Downloading light sources...")
  nest_lightsources <-
    "turtle-nest-hatchling-emergence-light-sources" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  wastdr_msg_info("Downloading logger observations...")
  nest_loggers <- "logger-observations" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations() %>%
    dplyr::left_join(tracks_animals, by = obs2enc)

  # Track Tallies -------------------------------------------------------------#
  wastdr_msg_info("Downloading LineTransectEncounters...")
  linetx <- "line-transect-encounters" %>%
    wastd_GET(max_records = max_records) %>%
    wastd_parse() %>%
    tun("observer") %>%
    tun("reporter") %>%
    tun("area") %>%
    tun("site") %>%
    tun("survey") %>%
    tun("survey_reporter") %>%
    tun("survey_site") %>%
    tun("survey_area") %>%
    add_dates(date_col = "when")

  wastdr_msg_info("Downloading track tallies...")
  track_tally <- "track-tally" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  wastdr_msg_info("Downloading disturbance tallies...")
  disturbance_tally <- "turtle-nest-disturbance-tally" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_encounterobservations()

  # Surveys -------------------------------------------------------------------#
  wastdr_msg_info("Downloading surveys...")
  surveys <- "surveys" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::parse_surveys()

  survey_media <- "survey-media-attachments" %>%
    wastdr::wastd_GET(max_records = max_records) %>%
    wastdr::wastd_parse()

  x <- structure(
    list(
      downloaded_on = Sys.time(),
      areas = areas,
      sites = sites,
      surveys = surveys,
      survey_media = survey_media,
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
      nest_loggers = nest_loggers,
      linetx = linetx,
      track_tally = track_tally,
      disturbance_tally = disturbance_tally
    ),
    class = "wastd_data"
  )

  if (!is.null(save)) {
    "Saving WAStD turtledata to {save}..." %>%
      glue::glue() %>%
      wastdr::wastdr_msg_success()
    saveRDS(x, file = save, compress = compress)
    "Done. Open the saved file with\nwastd_data <- readRds({save})" %>%
      glue::glue() %>%
      wastdr::wastdr_msg_success()
  }

  x
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
      "Areas:   {nrow(x$areas)}\n",
      "Sites:   {nrow(x$sites)}\n",
      "Surveys: {nrow(x$surveys)}\n",
      "Animals (tags, incidents): {nrow(x$animals)}\n",
      "  Turtle Tags:             {nrow(x$turtle_tags)}\n",
      "  Turtle Damages:          {nrow(x$turtle_dmg)}\n",
      "  Turtle Morphometrics:    {nrow(x$turtle_morph)}\n",
      "Turtle Nest Encounters:    {nrow(x$tracks)}\n",
      "  Logger Observations:     {nrow(x$nest_loggers)}\n",
      "  Nest Tags:               {nrow(x$nest_tags)}\n",
      "  Nest Excavations:        {nrow(x$nest_excavations)}\n",
      "  Hatchling Morph:         {nrow(x$hatchling_morph)}\n",
      "  Hatchling Fans:          {nrow(x$nest_fans)}\n",
      "  Hatchling Outliers:      {nrow(x$nest_fan_outliers)}\n",
      "  Light Sources:           {nrow(x$nest_lightsources)}\n",
      "Line Transect Encounters:  {nrow(x$linetx)}\n",
      "  Track Tallies:           {nrow(x$track_tally)}\n",
      "  Disturbance Tallies:     {nrow(x$disturbance_tally)}\n",
      "Dist/Pred (nest/general):  {nrow(x$nest_dist)}\n"
    )
  )
  invisible(x)
}

# usethis::use_test("download_wastd_turtledata")
