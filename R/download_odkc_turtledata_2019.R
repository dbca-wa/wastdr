#' Download and save Turtle data from ODK Central.
#'
#' @param datafile The target filename to save the final data to.
#' @param extrafile The target filename to save the UAT data to.
#' @param local_dir A local directory to which to save the attachment files.
#'   Attachment filepaths will be relative to the directory.
#'   The directory and its parent folders will be created if not existing.
#' @param prod The ODKC PROD server,
#' default: "https://odkcentral.dbca.wa.gov.au".
#' @param uat The ODKC UAT server,
#' default: "https://odkcentral-uat.dbca.wa.gov.au".
#' @param tz The local timezone, default: "Australia/Perth".
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
#'
#' @examples
download_odkc_turtledata_2019 <-
  function(datafile = here::here("wa-turtle-programs", "data_odkc.rda"),
           extrafile = here::here("wa-turtle-programs", "data_odkc_extra.rda"),
           local_dir = here::here("wa-turtle-programs", "media"),
           prod = "https://odkcentral.dbca.wa.gov.au",
           uat = "https://odkcentral-uat.dbca.wa.gov.au",
           tz = "Australia/Perth",
           verbose = TRUE) {
    fs::dir_create(local_dir, recurse = TRUE)
    pl <- ruODK::project_list()
    # pl

    fl <- ruODK::form_list(pid = 1)
    # fl

    # SV start
    ruODK::ru_setup(
      pid = 1, fid = "build_Site-Visit-Start-0-3_1559789550", url =
        prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    svs_prod <-
      ruODK::odata_submission_get(
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      )

    # SV end
    ruODK::ru_setup(
      pid = 1, fid = "build_Site-Visit-End-0-2_1559789512", url =
        prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    sve_prod <-
      ruODK::odata_submission_get(
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      )

    # MWI
    ruODK::ru_setup(
      pid = 1, fid = "build_Marine-Wildlife-Incident-0-6_1559789189", url =
        prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    ft <- ruODK::odata_service_get()

    mwi_prod <- ft$url[[1]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      )

    mwi_dmg_prod <- ft$url[[2]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      ) %>%
      dplyr::left_join(mwi_prod, by = c("submissions_id" = "id"))

    mwi_tag <- ft$url[[3]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      ) # %>%
    # dplyr::left_join(mwi, by = c("submissions_id" = "id"))

    # Dist
    ruODK::ru_setup(
      pid = 1, fid = "build_Predator-or-Disturbance-1-1_1559789410", url =
        prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    dist_prod <-
      ruODK::odata_submission_get(
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      )

    # Tracks
    ruODK::ru_setup(
      pid = 1, fid = "build_Turtle-Track-or-Nest-1-0_1559789920", url =
        prod
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    ft <- ruODK::odata_service_get()

    tracks_prod <- ft$url[1] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      ) %>%
      wastdr::exclude_training_species() %>%
      wastdr::add_nest_labels()

    tracks_dist_prod <- ft$url[2] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    # None of the following were captured in UAT, so we name them wihtout _prod:
    tracks_egg <- ft$url[3] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      ) # %>%
    # dplyr::left_join(tracks, by = c("submissions_id" = "id"))

    tracks_log_prod <- ft$url[4] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_hatch <- ft$url[5] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      ) # %>%
    # dplyr::left_join(tracks, by = c("submissions_id" = "id"))

    tracks_fan_outlier_prod <- ft$url[6] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_light <- ft$url[7] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      ) # %>%
    # dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    #----------------------------------------------------------------------------#
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
        wkt = T,
        local_dir = local_dir
      )
    svs_extra <-
      dplyr::anti_join(svs_uat, svs_prod, by = "instance_id")

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
        wkt = T,
        local_dir = local_dir
      )
    sve_extra <-
      dplyr::anti_join(sve_uat, sve_prod, by = "instance_id")

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
        wkt = T,
        local_dir = local_dir
      )
    mwi_extra <-
      dplyr::anti_join(mwi_uat, mwi_prod, by = "instance_id")

    # Dist
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Predator-or-Disturbance-1-1_1559789410",
      url = uat
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    dist_uat <-
      ruODK::odata_submission_get(
        wkt = T,
        verbose = verbose,
        local_dir = local_dir
      )
    dist_extra <-
      dplyr::anti_join(dist_uat, dist_prod, by = "instance_id")

    # Tracks
    ruODK::ru_setup(
      pid = 1,
      fid = "build_Turtle-Track-or-Nest-1-0_1559789920",
      url = uat
    )
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    ft <- ruODK::odata_service_get()
    ft %>% knitr::kable(.)
    tracks_uat <- ft$url[1] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      ) %>%
      wastdr::exclude_training_species() %>%
      wastdr::add_nest_labels()
    tracks_extra <-
      dplyr::anti_join(tracks_uat, tracks_prod, by = "instance_id")

    tracks_dist_uat <- ft$url[2] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        wkt = T,
        local_dir = local_dir
      ) %>%
      dplyr::left_join(tracks_uat, by = c("submissions_id" = "id"))
    tracks_dist_extra <-
      dplyr::anti_join(tracks_dist_uat, tracks_dist_prod, by = "instance_id")

    save(
      svs_extra,
      sve_extra,
      mwi_extra,
      dist_extra,
      tracks_extra,
      tracks_dist_extra,
      file = extrafile
    )

    # load(extrafile)

    areas_sf <- wastdr::wastd_GET("area") %>%
      magrittr::extract2("features") %>%
      geojsonio::as.json() %>%
      geojsonsf::geojson_sf()

    sites <- areas_sf %>%
      dplyr::filter(area_type == "Site") %>%
      dplyr::transmute(site_id = pk, site_name = name)

    areas <- areas_sf %>%
      dplyr::filter(area_type == "Locality") %>%
      dplyr::transmute(area_id = pk, area_name = name)


    mwi <- dplyr::bind_rows(mwi_prod, mwi_extra) %>%
      wastdr::join_tsc_sites(sites, areas) %>%
      wastdr::add_dates()

    mwi_dmg <- mwi_dmg_prod %>%
      wastdr::join_tsc_sites(sites, areas) %>%
      wastdr::add_dates()

    svs <- dplyr::bind_rows(svs_prod, svs_extra) %>%
      wastdr::join_tsc_sites(sites, areas, prefix = "location_") %>%
      wastdr::add_dates_svs()

    sve <- dplyr::bind_rows(sve_prod, sve_extra) %>%
      wastdr::join_tsc_sites(sites, areas, prefix = "location_") %>%
      wastdr::add_dates_sve()

    dist <- dplyr::bind_rows(dist_prod, dist_extra) %>%
      wastdr::join_tsc_sites(sites, areas, prefix = "location_") %>%
      wastdr::add_dates()

    tracks <- dplyr::bind_rows(tracks_prod, tracks_extra) %>%
      wastdr::join_tsc_sites(sites, areas) %>%
      wastdr::add_dates()

    tracks_dist <-
      dplyr::bind_rows(tracks_dist_prod, tracks_dist_extra) %>%
      wastdr::join_tsc_sites(sites, areas) %>%
      wastdr::add_dates()

    tracks_log <- tracks_log_prod %>%
      wastdr::join_tsc_sites(sites, areas) %>%
      wastdr::add_dates()

    tracks_fan_outlier <-
      tracks_fan_outlier_prod %>%
      wastdr::join_tsc_sites(sites, areas) %>%
      wastdr::add_dates()

    turtledata <- list(
      downloaded_on = Sys.time(),
      tracks = tracks,
      tracks_dist = tracks_dist,
      tracks_log = tracks_log,
      tracks_fan_outlier = tracks_fan_outlier,
      dist = dist,
      mwi = mwi,
      mwi_dmg = mwi_dmg,
      svs = svs,
      sve = sve,
      sites = sites,
      areas = areas
    )

    save(turtledata, file = datafile, compress = "xz")

    turtledata
  }
