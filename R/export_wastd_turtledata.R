
#' Export all WAStD turtledata to CSV and GeoJSON files
#'
#' @param x An object of class `wastd_data` as returned by
#'   \code{\link{download_wastd_turtledata}}.
#'   This data can optionally be filtered to
#'   an area_name (WAStD Area of type Locality).
#' @param outdir The destination to write exported data to,
#'   default: \code{here::here()}.
#' @param filename The filename for the ZIP archive, default: `export`.
#' @param zip Whether to archive the files as ZIP or keep them separate.
#'   Default: FALSE (keep separate files).
#' @return A set of files in the folder `outdir`.
#'   GeoJSON files can be opened in any GIS, such as Quantum GIS or ESRI ArcGIS.
#'   CSV files can be opened in any spreadsheet program, such as MS Excel or
#'   LibreOffice Calc.
#'
#'   * `areas.geojson` WAStD Areas, or Localities.
#'     * Typically one locality per monitoring program.
#'   * `sites.geojson` WAStD Sites.
#'     * Each Survey and Encounter can be linked to one Site.
#'   * `surveys.csv` Surveys.
#'     * Each row is one Survey.
#'     * Training and duplicate Surveys are distinguished from production (real)
#'       Surveys by the column `production` (TRUE or FALSE).
#'   * `animals.csv` AnimalEncounters.
#'     * This includes encounters with animals during turtle tagging,
#'       as well as strandings and rescues. Mind that stranded turtles can be
#'       tagged, but are not always encountered during dedicated surveys.
#'     * Survey details are repeated for convenience.
#'     * One record can have several additional observations, which are included
#'       as separate CSVs.
#'   * `turtle_tags.csv` Tags recorded during an AnimalEncounter.
#'     * Each record concerns exactly one Tag.
#'     * One Animal can carry multiple Tags.
#'     * Details of the overarching AnimalEncounter are repeated for
#'       convenience.
#'   * `turtle_dmg.csv` Damages or distinguishing features observed during an
#'     AnimalEncounter.
#'     * Each record concerns exactly one Damage.
#'     * One Animal can show multiple Damages or distinguishing features.
#'     * Details of the overarching AnimalEncounter are repeated for
#'       convenience.
#'   * `turtle_morph.csv` Morphological measurements taken during an
#'     AnimalEncounter.
#'     * Each record concerns exactly one set of measurements.
#'     * One Animal could have multiple sets of measurements, although normally
#'       only one set of morphological measurements is taken.
#'     * Details of the overarching AnimalEncounter are repeated for
#'       convenience.
#'   * `tracks.csv` TurtleNestEncounters, which include turtle tracks without
#'     nests ("false crawls"), nests with tracks ("successful crawls"), and
#'     any shade of doubt or negligent data capture in between.
#'     * One record is exactly one Track or Nest.
#'     * Survey details are repeated for convenience.
#'     * One record can have several additional observations, which are included
#'       as separate CSVs.
#'  * `nest_dist.csv` TurtleNestDisturbanceObservations are recorded either
#'    linked to a nest (predated or damaged turtle nest), or standalone as
#'    general disturbance or predator presence.
#'    * Disturbed or predated nests are distinguished from general disturbance
#'      or predator presence through the column `encounter_type`
#'      ("nest" or "other").
#'     * Details of the overarching TurtleNestEncounter are repeated for
#'       convenience.
#'  * `nest_tags.csv` NestTagObservations.
#'    A stick with an ID scribbled on it stuck in the sand next to a nest.
#'    * Not to be confused with data loggers,
#'      which also carry an ID and are associated with a turtle nest for a while.
#'    * Details of the overarching TurtleNestEncounter are repeated for
#'      convenience.
#'  * `nest_excavations.csv` Excavations of a turtle nest, resulting in a count
#'    of eggs and leftovers grouped into categories, plus egg chamber details.
#'    * Details of the overarching TurtleNestEncounter are repeated for
#'      convenience.
#'  * `hatchling_morph.csv` Morphometric measurements of a single turtle
#'    hatchling.
#'    * There can be several per nest.
#'    * Details of the overarching TurtleNestEncounter are repeated for
#'      convenience.
#'  * `nest_fans.csv` Measurements of turtle hatchling emergence track fans.
#'    * Multiple measurements of fan angles per nest are possible, but not
#'      expected.
#'    * Details of the overarching TurtleNestEncounter are repeated for
#'      convenience.
#'  * `nest_fan_outliers.csv` Individual hatchling tracks outside of the main
#'    fan of hatchling tracks.
#'    * There can be several per nest.
#'    * Details of the overarching TurtleNestEncounter are repeated for
#'      convenience.
#'  * `nest_lightsources.csv` Individual known lightsources during hatching.
#'    * There can be several per nest.
#'    * Details of the overarching TurtleNestEncounter are repeated for
#'      convenience.
#'  * `nest_loggers.csv` Deployed or re-sighted data loggers in a turtle nest.
#'    * There can be several per nest.
#'    * Details of the overarching TurtleNestEncounter are repeated for
#'      convenience.
#'  * `line_transects.csv` Tallies turtle tracks along a transect,
#'    recorded during one LineTransectEncounter.
#'    * One record per transect.
#'    * Latitude and Longitude are extracted from the first waypoint of the line
#'      transect.
#'    * A transect can be crossed by many individual tracks.
#'  * `line_transects.geojson` Data from `line_transects.csv` as GeoJSON.
#'    Currently excluded.
#'  * `track_tally.csv` Tally of tracks by type and species crossing a transect.
#'    * There can be many tallies per transect.
#'    * Details of the overarching LineTransectEncounter are repeated for
#'      convenience.
#'  * `disturbance_tally.csv` Tally of general disturbances or predator presence
#'    encountered during one LineTransectEncounter.
#'    * There can be several per transect.
#'    * Details of the overarching LineTransectEncounter are repeated for
#'      convenience.
#'  * `wastd_data.rds` The given wastd_data object saved to file as `.rds`,
#'    ready to be loaded into R with `readRDS`.
#' @export
#' @family api
#' @examples
#' \dontrun{
#' data("wastd_data", package = "wastdr")
#' an <- "Ningaloo"
#' au <- urlize(an)
#' wastd_data %>%
#'   filter_wastd_turtledata(area_name = an) %>%
#'   export_wastd_turtledata(outdir = here::here(au), filename = au)
#' }
export_wastd_turtledata <- function(x,
                                    outdir = here::here(),
                                    filename = "export",
                                    zip = FALSE) {
  verify_wastd_data(x)

  if (!fs::dir_exists(outdir)) fs::dir_create(outdir, recurse = TRUE)

  x %>% saveRDS(file = fs::path(outdir, "wastd_data.rds"))

  x$areas %>% geojsonio::geojson_write(file = fs::path(outdir, "areas.geojson"))
  x$sites %>% geojsonio::geojson_write(file = fs::path(outdir, "sites.geojson"))
  x$surveys %>% readr::write_csv(file = fs::path(outdir, "surveys.csv"))

  x$animals %>% readr::write_csv(file = fs::path(outdir, "animals.csv"))
  x$turtle_tags %>% readr::write_csv(file = fs::path(outdir, "turtle_tags.csv"))
  x$turtle_dmg %>% readr::write_csv(file = fs::path(outdir, "turtle_dmg.csv"))
  x$turtle_morph %>% readr::write_csv(file = fs::path(outdir, "turtle_morph.csv"))

  x$tracks %>% readr::write_csv(file = fs::path(outdir, "tracks.csv"))
  x$nest_dist %>% readr::write_csv(file = fs::path(outdir, "nest_dist.csv"))
  x$nest_tags %>% readr::write_csv(file = fs::path(outdir, "nest_tags.csv"))
  x$nest_excavations %>% readr::write_csv(file = fs::path(outdir, "nest_excavations.csv"))
  x$hatchling_morph %>% readr::write_csv(file = fs::path(outdir, "hatchling_morph.csv"))
  x$nest_fans %>% readr::write_csv(file = fs::path(outdir, "nest_fans.csv"))
  x$nest_fan_outliers %>% readr::write_csv(file = fs::path(outdir, "nest_fan_outliers.csv"))
  x$nest_lightsources %>% readr::write_csv(file = fs::path(outdir, "light_sources.csv"))
  x$nest_loggers %>% readr::write_csv(file = fs::path(outdir, "nest_loggers.csv"))

  if (nrow(x$linetx) > 0) {
    x$linetx %>%
      dplyr::select(-geometry, -transect) %>%
      readr::write_csv(file = fs::path(outdir, "line_transects.csv"))
  }
  # if (nrow(x$linetx) > 0) x$linetx %>%
  #     geojsonio::as.json() %>%
  #     geojsonsf::geojson_sf() %>%
  #     sf::write_sf(fs::path(outdir, "line_transects.geojson"))
  # This works: sf::st_as_sf(odkc_ex$track_tally, wkt="tx")
  x$track_tally %>%
    dplyr::select(-encounter_transect) %>%
    readr::write_csv(file = fs::path(outdir, "track_tally.csv"))
  x$disturbance_tally %>%
    dplyr::select(-encounter_transect) %>%
    readr::write_csv(file = fs::path(outdir, "disturbance_tally.csv"))

  if (zip == TRUE) {
    zipfile <- paste0(filename, ".zip")
    utils::zip(zipfile, fs::dir_ls(outdir), flags = "-jr9X")
    fs::file_move(zipfile, new_path = outdir)
    # fs::dir_ls(outdir, glob=".zip", invert=TRUE) %>% fs::delete()
  }
}

# usethis::use_test("export_wastd_turtledata")
