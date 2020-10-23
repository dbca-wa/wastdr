
#' Export all WAStD turtledata to a ZIP file of CSV and GeoJSON files.
#'
#' @param x An object of class `wastd_data` as returned by
#'   \code{\link{download_wastd_turtledata}}.
#'   This data can optionally be filtered to
#'   an area_name (WAStD Area of type Locality).
#' @param outdir The destination to write exported data to,
#'   default: \code{here::here()}.
#' @param filename The filename of the ZIP file, default: `export`.
#'   The extension `.zip` will be appended and should not be part of `filename`.
#' @export
#' @examples
#' \dontrun{
#' data("wastd_data", package = "wastdr")
#' an <- "Ningaloo"
#' au <- urlize(an)
#' wastd_data %>%
#' filter_wastd_turtledata(area_name = an) %>%
#' export_wastd_turtledata(outdir = here::here(au), filename = au)
#' }
export_wastd_turtledata <- function(x,
                                    outdir = here::here(),
                                    filename = "export"){
    if (class(x) != "wastd_data") wastdr_msg_abort(glue::glue(
        "The first argument needs to be an object of class \"wastd_data\", ",
        "e.g. the output of wastdr::download_wastd_turtledata."))

    if (!fs::dir_exists(outdir)) fs::dir_create(outdir, recurse = TRUE)

    x$areas %>% geojsonio::geojson_write(file = fs::path(outdir, "areas.geojson"))
    x$sites %>% geojsonio::geojson_write(file = fs::path(outdir, "sites.geojson"))
    x$surveys %>% readr::write_csv(file = fs::path(outdir, "surveys.csv"))

    x$animals %>% dplyr::select(-obs) %>% readr::write_csv(file = fs::path(outdir, "animals.csv"))
    x$turtle_tags %>% ruODK::odata_submission_rectangle() %>%  readr::write_csv(file = fs::path(outdir, "turtle_tags.csv"))
    x$turtle_dmg %>%  readr::write_csv(file = fs::path(outdir, "turtle_dmg.csv"))
    x$turtle_morph %>%  readr::write_csv(file = fs::path(outdir, "turtle_morph.csv"))

    x$tracks %>% readr::write_csv(file = fs::path(outdir, "tracks.csv"))
    x$nest_dist %>% readr::write_csv(file = fs::path(outdir, "nest_dist.csv"))
    x$nest_tags %>% readr::write_csv(file = fs::path(outdir, "nest_tags.csv"))
    x$nest_excavations %>% readr::write_csv(file = fs::path(outdir, "nest_excavations.csv"))
    x$hatchling_morph %>% readr::write_csv(file = fs::path(outdir, "hatchling_morph.csv"))
    x$nest_fans %>% readr::write_csv(file = fs::path(outdir, "nest_fans.csv"))
    x$nest_fan_outliers %>% readr::write_csv(file = fs::path(outdir, "nest_fan_outliers.csv"))
    x$nest_lightsources %>% readr::write_csv(file = fs::path(outdir, "light_sources.csv"))

    if (nrow(x$linetx) > 0) x$linetx %>% sf::write_sf(fs::path(outdir, "line_transects.geojson"))
    x$track_tally %>% readr::write_csv(file = fs::path(outdir, "track_tally.csv"))
    x$disturbance_tally %>% readr::write_csv(file = fs::path(outdir, "disturbance_tally.csv"))

    x$loggers %>% ruODK::odata_submission_rectangle() %>% readr::write_csv(file = fs::path(outdir, "loggers.csv"))
    if (nrow(x$loggers) > 0) x$loggers %>% geojsonio::geojson_write(file = fs::path(outdir, "loggers.geojson"))

    utils::zip(paste0(filename, ".zip"), fs::dir_ls(outdir), flags = "-jr9X")
}
















# use_test("export_wastd_turtledata")
