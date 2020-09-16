
#' Export all WAStD turtledata to CSV and GeoJSON.
#'
#' @param x An object of class `wastd_data` as returned by
#'   \code{\link{download_wastd_turtledata}}. This data can be filtered to
#'   an area_name (WAStD Area of type Locality).
#' @param area_name The name of a WAStD Area of type Locality to filter the
#'   data.
#' @param outdir The destination to write exported data to,
#'   default: \code{here::here()}.
#' @export
#' @examples
#' \dontrun{
#' data("wastd_data", package = "wastdr")
#' an <- "Ningaloo"
#' wastd_data %>%
#' filter_wastd_turtledata(area_name = an) %>%
#' export_wastd_turtledata(outdir = here::here("inst/export", urlize(an)))
#' }
export_wastd_turtledata <- function(x, outdir = here::here()){
    if (!fs::dir_exists(outdir)) fs::dir_create(outdir, recurse = TRUE)

    wastd_data$areas %>% geojsonio::geojson_write(file = fs::path(outdir, "areas.geojson"))
    wastd_data$sites %>% geojsonio::geojson_write(file = fs::path(outdir, "sites.geojson"))
    wastd_data$surveys %>% readr::write_csv(path = fs::path(outdir, "surveys.csv"))

    wastd_data$animals %>% dplyr::select(-obs) %>% readr::write_csv(path = fs::path(outdir, "animals.csv"))
    wastd_data$turtle_tags %>% ruODK::odata_submission_rectangle() %>%  readr::write_csv(path = fs::path(outdir, "turtle_tags.csv"))
    wastd_data$turtle_dmg %>%  readr::write_csv(path = fs::path(outdir, "turtle_dmg.csv"))
    wastd_data$turtle_morph %>%  readr::write_csv(path = fs::path(outdir, "turtle_morph.csv"))

    wastd_data$tracks %>% readr::write_csv(path = fs::path(outdir, "tracks.csv"))
    wastd_data$nest_dist %>% readr::write_csv(path = fs::path(outdir, "nest_dist.csv"))
    wastd_data$nest_tags %>% readr::write_csv(path = fs::path(outdir, "nest_tags.csv"))
    wastd_data$nest_excavations %>% readr::write_csv(path = fs::path(outdir, "nest_excavations.csv"))
    wastd_data$hatchling_morph %>% readr::write_csv(path = fs::path(outdir, "hatchling_morph.csv"))
    wastd_data$nest_fans %>% readr::write_csv(path = fs::path(outdir, "nest_fans.csv"))
    wastd_data$nest_fan_outliers %>% readr::write_csv(path = fs::path(outdir, "nest_fan_outliers.csv"))
    wastd_data$nest_lightsources %>% readr::write_csv(path = fs::path(outdir, "light_sources.csv"))

    if (nrow(wastd_data$linetx) > 0) wastd_data$linetx %>% sf::write_sf(fs::path(outdir, "line_transects.geojson"))
    wastd_data$track_tally %>% readr::write_csv(path = fs::path(outdir, "track_tally.csv"))
    wastd_data$disturbance_tally %>% readr::write_csv(path = fs::path(outdir, "disturbance_tally.csv"))

    wastd_data$loggers %>% ruODK::odata_submission_rectangle() %>% readr::write_csv(path = fs::path(outdir, "loggers.csv"))
    if (nrow(wastd_data$loggers) > 0) wastd_data$loggers %>% geojsonio::geojson_write(file = fs::path(outdir, "loggers.geojson"))

    zip("export.zip", fs::dir_ls(outdir))
}
















# use_test("export_wastd_turtledata")
