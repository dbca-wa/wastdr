#' Download all turtle data from DBCA's ODK Central
#'
#' @param local_dir A local directory to which to save the attachment files.
#'   Attachment filepaths will be relative to the directory.
#'   The directory and its parent folders will be created if not existing.
#' @param prod The ODKC PROD server,
#' default: "https://odkcentral.dbca.wa.gov.au".
#' @param uat The ODKC UAT server,
#' default: "https://odkcentral-uat.dbca.wa.gov.au".
#' @template param-tz
#' @param download <lgl> Whether to download attachments to `local_dir` or not,
#' @template param-verbose
#'
#' @return An S3 class "odkc_turtledata" with items:
#' \itemize{
#'   \item downloaded_on An UTC POSIXct timestamp of the data snapshot.
#'   \item tracks The turtle tracks and nests from form
#'         "Turtle Track or Nest 1.0".
#'   \item tracks_dist Individual disturbances recorded against tracks,
#'         one row per disturbance.
#'   \item tracks_log Individual nest tags recorded against nests,
#'         one row per tag.
#'   \item tracks_egg Next excavation photos, one row per photo.
#'   \item tracks_hatch Turtle hatchling morphometrics, one row per measured
#'         hatchling.
#'   \item tracks_fan_outlier Individual hatchling track outliers recorded
#'         against hatched nests, one row per outlier.
#'   \item tracks_light Individual light sources known at hatchling emergence,
#'         one row per light source.
#'   \item track_tally A line transect tally of turtle tracks from form
#'         "Track Tally 0.6".
#'   \item dist The disturbance and predation records from form
#'         "Predator or Disturbance 1.1".
#'   \item mwi Strandings and rescues from the form
#'         "Marine Wildlife Incident 0.6 ".
#'   \item mwi_dmg Individual injuries recorded against mwi,
#'         one record per injury.
#'   \item tsi Turtle Sightings from form "Turtle Sighting 0.1/0.2",
#'         one row per sighted turtle.
#'   \item svs Survey start points from form "Site Visit Start 1.3".
#'   \item sve Survey end points from form "Site Visit End 1.2".
#'   \item sites An sf object of known TSC sites.
#'   \item areas An sf object of known TSC localities.
#'  }
#' @export
download_odkc_turtledata_2019 <-
  function(local_dir = here::here("media"),
           prod = "https://odkcentral.dbca.wa.gov.au",
           uat = "https://odkcentral-uat.dbca.wa.gov.au",
           tz = "Australia/Perth",
           download = TRUE,
           verbose = TRUE) {
    fs::dir_create(local_dir, recurse = TRUE)
    ruODK::ru_setup(
      pid = 1,
      url = prod,
      un = ruODK::get_default_un(),
      pw = ruODK::get_default_pw()
    )
    pl <- ruODK::project_list()
    # pl

    fl <- ruODK::form_list()
    # fl

    # SV start
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Site-Visit-Start-0-3_1559789550",
      url = prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    svs_prod <-
      ruODK::odata_submission_get(
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      )

    # SV end
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Site-Visit-End-0-2_1559789512",
      url = prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    sve_prod <-
      ruODK::odata_submission_get(
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      )

    # MWI
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Marine-Wildlife-Incident-0-6_1559789189",
      url = prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    ft <- ruODK::odata_service_get()

    mwi_prod <- ft$url[[1]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      )

    mwi_dmg_prod <- ft$url[[2]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      ) %>%
      dplyr::left_join(mwi_prod, by = c("submissions_id" = "id"))

    mwi_tag_prod <- ft$url[[3]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      ) %>%
      dplyr::left_join(mwi_prod, by = c("submissions_id" = "id"))

    # Turtle Sighting
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Turtle-Sighting-0-1_1559790020",
      url = prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    ft <- ruODK::odata_service_get()
    tsi01 <- ft$url[[1]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      )

    ruODK::ru_setup(
      pid = 1,
      fid = "build_Turtle-Sighting-0-2_1581567844",
      url = prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    ft <- ruODK::odata_service_get()
    tsi02 <- ft$url[[1]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      )

    # Dist
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Predator-or-Disturbance-1-1_1559789410",
      url = prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    dist_prod <-
      ruODK::odata_submission_get(
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      )

    # Tracks
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Turtle-Track-or-Nest-1-0_1559789920",
      url = prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    ft <- ruODK::odata_service_get()

    tracks_prod <- ft$url[1] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      ) %>%
      wastdr::exclude_training_species_odkc() %>%
      wastdr::add_nest_labels_odkc()

    tracks_dist_prod <- ft$url[2] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_egg_prod <- ft$url[3] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_log_prod <- ft$url[4] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_hatch_prod <- ft$url[5] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_fan_outlier_prod <- ft$url[6] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_light_prod <- ft$url[7] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))



    ruODK::ru_setup(
      pid = 1,
      fid = "build_Turtle-Track-Tally-0-6_1564387009",
      url = prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    tracktally_prod <-
      ruODK::odata_submission_get(
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      )

    #--------------------------------------------------------------------------#
    # Fix error: PROD used UAT db for a week - what's in UAT but not in PROD?

    # SV start
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Site-Visit-Start-0-3_1559789550",
      url = uat
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    svs_uat <-
      ruODK::odata_submission_get(
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      )
    svs_extra <-
      dplyr::anti_join(svs_uat, svs_prod, by = "meta_instance_id")

    # SV end
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Site-Visit-End-0-2_1559789512",
      url = uat
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    sve_uat <-
      ruODK::odata_submission_get(
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      )
    sve_extra <-
      dplyr::anti_join(sve_uat, sve_prod, by = "meta_instance_id")

    # MWI
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Marine-Wildlife-Incident-0-6_1559789189",
      url = uat
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    mwi_uat <-
      ruODK::odata_submission_get(
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      )
    mwi_extra <-
      dplyr::anti_join(mwi_uat, mwi_prod, by = "meta_instance_id")

    # Dist
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Predator-or-Disturbance-1-1_1559789410",
      url = uat
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    dist_uat <-
      ruODK::odata_submission_get(
        wkt = TRUE,
        verbose = verbose,
        local_dir = local_dir,
        download = download
      )
    dist_extra <-
      dplyr::anti_join(dist_uat, dist_prod, by = "meta_instance_id")

    # Tracks
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Turtle-Track-or-Nest-1-0_1559789920",
      url = uat
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    ft <- ruODK::odata_service_get()
    tracks_uat <- ft$url[1] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      ) %>%
      wastdr::exclude_training_species_odkc() %>%
      wastdr::add_nest_labels_odkc()
    tracks_extra <-
      dplyr::anti_join(tracks_uat, tracks_prod, by = "meta_instance_id")

    tracks_dist_uat <- ft$url[2] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = TRUE,
        local_dir = local_dir,
        download = download
      ) %>%
      dplyr::left_join(tracks_uat, by = c("submissions_id" = "id"))
    tracks_dist_extra <- tracks_dist_uat %>%
      dplyr::anti_join(tracks_dist_prod, by = "meta_instance_id")

    areas_sf <- wastdr::wastd_GET("area") %>%
      magrittr::extract2("data") %>%
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
      wastdr::join_tsc_sites(sites, prefix = "incident_observed_at_") %>%
      wastdr::add_dates()

    mwi_dmg <- mwi_dmg_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "incident_observed_at_") %>%
      wastdr::add_dates()

    mwi_tag <- mwi_tag_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "incident_observed_at_") %>%
      wastdr::add_dates()

    tsi <- dplyr::bind_rows(tsi01, tsi02)

    svs <- dplyr::bind_rows(svs_prod, svs_extra) %>%
      wastdr::join_tsc_sites(sites, prefix = "site_visit_location_") %>%
      wastdr::add_dates_svs()

    sve <- dplyr::bind_rows(sve_prod, sve_extra) %>%
      wastdr::join_tsc_sites(sites, prefix = "site_visit_location_") %>%
      wastdr::add_dates_sve()

    dist <- dplyr::bind_rows(dist_prod, dist_extra) %>%
      wastdr::join_tsc_sites(sites,
        prefix = "disturbanceobservation_location_"
      ) %>%
      wastdr::add_dates()

    tracks <- dplyr::bind_rows(tracks_prod, tracks_extra) %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates()

    tracks_dist <- tracks_dist_prod %>%
      dplyr::bind_rows(tracks_dist_extra) %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates()

    tracks_log <- tracks_log_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates()

    tracks_egg <- tracks_egg_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates()

    tracks_hatch <- tracks_hatch_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates()

    tracks_fan_outlier <-
      tracks_fan_outlier_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates()

    tracks_light <- tracks_light_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates()

    track_tally <- tracktally_prod

    odkc_turtledata <-
      structure(
        list(
          downloaded_on = Sys.time(),
          tracks = tracks,
          tracks_dist = tracks_dist,
          tracks_egg = tracks_egg,
          tracks_log = tracks_log,
          tracks_hatch = tracks_hatch,
          tracks_fan_outlier = tracks_fan_outlier,
          tracks_light = tracks_light,
          track_tally = track_tally,
          dist = dist,
          mwi = mwi,
          mwi_dmg = mwi_dmg,
          mwi_tag = mwi_tag,
          tsi = tsi,
          svs = svs,
          sve = sve,
          sites = sites,
          areas = areas
        ),
        class = "odkc_turtledata"
      )

    odkc_turtledata
  }

#' @title S3 print method for 'odkc_turtledata'.
#' @description Prints a short representation of data returned by
#' \code{\link{download_odkc_turtledata_2019}}.
#' @param x An object of class `wastd_data` as returned by
#'   \code{\link{download_odkc_turtledata_2019}}.
#' @param ... Extra parameters for `print`
#' @export
print.odkc_turtledata <- function(x, ...) {
  print(
    glue::glue(
      "<ODKC Turtle Data> accessed on {x$downloaded_on}\n",
      "Areas: {nrow(x$areas)}\n",
      "Sites: {nrow(x$sites)}\n",
      "Survey start points: {nrow(x$svs)}\n",
      "Survey end points: {nrow(x$sve)}\n",
      "Marine Wildlife Incidents (rescues, strandings): {nrow(x$mwi)}\n",
      "Live sightings: {nrow(x$tsi)}\n",
      "Turtle Tracks or Nests: {nrow(x$tracks)}\n",
      "Turtle Track Tallies: {nrow(x$track_tally)}"
    )
  )
  invisible(x)
}

# usethis::use_test("download_odkc_turtledata_2019")
