#' Download and save Turtle data from ODK Central.
#'
#' @param datafile The target filename to save the final data to.
#' @template param-verbose
#'
#' @return A list of tibbles and sf objects:
#'
#'   * downloaded_on An UTC POSIXct timestamp of the data snapshot.
#'   * tracks The turtle tracks and nests from form "Turtle Track or Nest 1.0".
#'   * tracks_dist Individual disturbances recorded against tracks, one row per
#'     disturbance.
#'   * tracks_log Individual nest tags recorded against nests, one row per tag.
#'   * tracks_fan_outliser Individual hatchling track outliers recorded against
#'     hatched nests, one row per outlier.
#'   * dist The disturbance and predation records from form "Predator or
#'     Disturbance 1.1".
#'   * mwi Strandings and rescues from the form "Marine Wildlife Incident 0.6 ".
#'   * mwi_dmg Individual injuries recorded against mwi, one record per injury.
#'   * svs Survey start points from form "Site Visit Start 1.3".
#'   * sve Survey end points from form "Site Visit End 1.2".
#'   * sites An sf object of known TSC sites.
#'   * areas An sf object of known TSC localities.
#' @export
download_tsc_turtledata <- function(
    datafile = here::here("data_tsc.rda"),
    verbose = TRUE) {

        areas_sf <- wastdr::wastd_GET("area") %>%
            magrittr::extract2("features") %>%
            geojsonio::as.json() %>%
            geojsonsf::geojson_sf()

        areas <- areas_sf %>%
            dplyr::filter(area_type == "Locality") %>%
            dplyr::transmute(area_id = pk, area_name = name)

        sites <- areas_sf %>%
            dplyr::filter(area_type == "Site") %>%
            dplyr::transmute(site_id = pk, site_name = name) %>%
            sf::st_join(areas)

        mwi <- dplyr::bind_rows(mwi_prod, mwi_extra) %>%
            wastdr::join_tsc_sites(sites, prefix="incident_observed_at_") %>%
            wastdr::add_dates()

        mwi_dmg <- mwi_dmg_prod %>%
            wastdr::join_tsc_sites(sites, prefix="incident_observed_at_") %>%
            wastdr::add_dates()

        mwi_tag <- mwi_tag_prod %>%
            wastdr::join_tsc_sites(sites, prefix="incident_observed_at_") %>%
            wastdr::add_dates()

        svs <- dplyr::bind_rows(svs_prod, svs_extra) %>%
            wastdr::join_tsc_sites(sites, prefix = "site_visit_location_") %>%
            wastdr::add_dates_svs()

        sve <- dplyr::bind_rows(sve_prod, sve_extra) %>%
            wastdr::join_tsc_sites(sites, prefix = "site_visit_location_") %>%
            wastdr::add_dates_sve()

        dist <- dplyr::bind_rows(dist_prod, dist_extra) %>%
            wastdr::join_tsc_sites(sites,
                                   prefix = "disturbanceobservation_location_") %>%
            wastdr::add_dates()

        tracks <- dplyr::bind_rows(tracks_prod, tracks_extra) %>%
            wastdr::join_tsc_sites(sites, prefix="details_observed_at_") %>%
            wastdr::add_dates()

        tracks_dist <-
            dplyr::bind_rows(tracks_dist_prod, tracks_dist_extra) %>%
            wastdr::join_tsc_sites(sites, prefix="details_observed_at_") %>%
            wastdr::add_dates()

        tracks_log <- tracks_log_prod %>%
            wastdr::join_tsc_sites(sites, prefix="details_observed_at_") %>%
            wastdr::add_dates()

        tracks_egg <- tracks_egg_prod %>%
            wastdr::join_tsc_sites(sites, prefix="details_observed_at_") %>%
            wastdr::add_dates()

        tracks_hatch <- tracks_hatch_prod %>%
            wastdr::join_tsc_sites(sites, prefix="details_observed_at_") %>%
            wastdr::add_dates()

        tracks_fan_outlier <-
            tracks_fan_outlier_prod %>%
            wastdr::join_tsc_sites(sites, prefix="details_observed_at_") %>%
            wastdr::add_dates()

        turtledata <- list(
            downloaded_on = Sys.time(),
            tracks = tracks,
            tracks_dist = tracks_dist,
            tracks_egg = tracks_egg,
            tracks_log = tracks_log,
            tracks_hatch = tracks_hatch,
            tracks_fan_outlier = tracks_fan_outlier,
            dist = dist,
            mwi = mwi,
            mwi_dmg = mwi_dmg,
            mwi_tag = mwi_tag,
            svs = svs,
            sve = sve,
            sites = sites,
            areas = areas
        )

        save(turtledata, file = datafile, compress = "xz")

        turtledata
    }
