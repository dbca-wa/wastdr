#' Download all turtle data from DBCA's ODK Central 2020
#'
#' \lifecycle{maturing}
#'
#' @param local_dir A local directory to which to save the attachment files.
#'   Attachment filepaths will be relative to the directory.
#'   The directory and its parent folders will be created if not existing.
#' @param prod The ODKC PROD server,
#' default: "https://odkc.dbca.wa.gov.au".
#' @template param-tz
#' @param odkc_version The numeric ODK Central version, e.g. 0.7 or 0.8.
#' @param download (lgl) Whether to download attachments to `local_dir` or not,
#' @template param-verbose
#'
#' @return An S3 class "odkc_turtledata" with items:
#' \itemize{
#'   \item downloaded_on An UTC POSIXct timestamp of the data snapshot.
#'   \item tracks The turtle tracks and nests from form
#'         "Turtle Track or Nest 1.0".
#'   \item tracks_dist Individual disturbances recorded against tracks,
#'         one record per disturbance.
#'   \item tracks_log Individual nest tags recorded against nests,
#'         one record per tag.
#'   \item tracks_egg Next excavation photos, one record per photo.
#'   \item tracks_hatch Turtle hatchling morphometrics, one record per measured
#'         hatchling.
#'   \item tracks_fan_outlier Individual hatchling track outliers recorded
#'         against hatched nests, one record per outlier.
#'   \item tracks_light Individual light sources known at hatchling emergence,
#'         one record per light source.
#'   \item track_tally A line transect tally of turtle tracks from form
#'         "Track Tally 0.6".
#'   \item dist The disturbance and predation records from form
#'         "Predator or Disturbance 1.1".
#'   \item mwi Strandings and rescues from the form
#'         "Marine Wildlife Incident 0.6 ".
#'   \item mwi_dmg Individual injuries recorded against mwi,
#'         one record per injury.
#'   \item mwi_tag Individual tags sighted during an mwi, one record per tag.
#'   \item tsi Turtle Sightings from form `Turtle-Sighting`,
#'         one record per sighted turtle.
#'   \item tt Individual turtles encountered and tagged after nesting
#'         during night time turtle tagging from form `Turtle-Tagging-3-0`,
#'         one record per encountered turtle.
#'   \item tt_dmg Characteristic damages or injuries recorded during turtle
#'         tagging, one record per damage.
#'   \item tt_tag Individual tags recorded during turtle tagging,
#'         one record per tag. Tags can be of different type,
#'         re-sighted, applied, or removed.
#'   \item tt_log Individual loggers recorded during turtle tagging,
#'         one record per logger. Loggers can be of different type,
#'         re-sighted, deployed, or removed.
#'   \item svs Survey start points from form `Site-Visit-Start`.
#'   \item sve Survey end points from form `Site-Visit-End`.
#'   \item sites An sf object of known WAStD sites.
#'   \item areas An sf object of known WAStD localities.
#'  }
#' @export
#' @family odkc
download_odkc_turtledata_2020 <-
  function(local_dir = here::here("media"),
           prod = "https://odkc.dbca.wa.gov.au",
           # uat = "https://odkc-uat.dbca.wa.gov.au",
           tz = ruODK::get_default_tz(),
           download = TRUE,
           # exclude_training = TRUE,
           odkc_version = ruODK::get_default_odkc_version(),
           verbose = wastdr::get_wastdr_verbose()) {
    if (download == TRUE) fs::dir_create(local_dir, recurse = TRUE) # nocov

    ruODK::ru_setup(
      pid = 1,
      url = prod,
      un = ruODK::get_default_un(),
      pw = ruODK::get_default_pw(),
      odkc_version = 1.0
    )
    # pl <- ruODK::project_list()
    # pl

    # fl <- ruODK::form_list()
    # fl
    #
    # -------------------------------------------------------------------------#
    # Turtle Tracks
    #
    ruODK::ru_setup(fid = "Turtle-Track-or-Nest")
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    ft <- ruODK::odata_service_get()

    tracks_prod <- ft$url[1] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      ) %>%
      # { if (exclude_training == TRUE)
      #     wastdr::exclude_training_species_odkc() else .} %>%
      wastdr::add_nest_labels_odkc()

    tracks_dist_prod <- ft$url[2] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_egg_prod <- ft$url[3] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_log_prod <- ft$url[4] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_hatch_prod <- ft$url[5] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_fan_outlier_prod <- ft$url[6] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    tracks_light_prod <- ft$url[7] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      ) %>%
      dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))

    # -------------------------------------------------------------------------#
    # Track Tally (enc and denormalised tt obs)
    #
    ruODK::ru_setup(fid = "Turtle-Track-Tally")
    ft <- ruODK::odata_service_get()
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    tracktally_prod <- ruODK::odata_submission_get(
      table = ft$url[1],
      verbose = verbose,
      wkt = TRUE,
      local_dir = local_dir,
      download = download,
      odkc_version = odkc_version
    ) %>%
      dplyr::rename(tx = overview_location) %>%
      sf::st_as_sf(wkt = "tx")

    tracktally_dist_prod <- ruODK::odata_submission_get(
      table = ft$url[2],
      verbose = verbose,
      wkt = FALSE,
      local_dir = local_dir,
      download = download,
      odkc_version = odkc_version
    ) %>%
      dplyr::left_join(tracktally_prod, by = c("submissions_id" = "id"))

    # -------------------------------------------------------------------------#
    # Dist or Pred
    #
    ruODK::ru_setup(fid = "Predator-or-Disturbance")
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    dist_prod <-
      ruODK::odata_submission_get(
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      )

    # -------------------------------------------------------------------------#
    # MWI
    #
    ruODK::ru_setup(fid = "Marine-Wildlife-Incident")
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    ft <- ruODK::odata_service_get()

    mwi_prod <- ft$url[[1]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      )

    mwi_dmg_prod <- ft$url[[2]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      ) %>%
      dplyr::left_join(mwi_prod, by = c("submissions_id" = "id"))

    mwi_tag_prod <- ft$url[[3]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      ) %>%
      dplyr::left_join(mwi_prod, by = c("submissions_id" = "id"))

    # -------------------------------------------------------------------------#
    #  Turtle Sighting
    #
    ruODK::ru_setup(fid = "Turtle-Sighting")
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    ft <- ruODK::odata_service_get()
    tsi_prod <- ft$url[[1]] %>%
      ruODK::odata_submission_get(
        table = .,
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      )

    # -------------------------------------------------------------------------#
    # Turtle Tagging
    #
    ruODK::ru_setup(fid = "Turtle-Tagging-3-0")
    ft <- ruODK::odata_service_get()
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    tt_prod <- ruODK::odata_submission_get(
      table = ft$url[1],
      verbose = verbose,
      local_dir = local_dir,
      download = download,
      odkc_version = odkc_version,
      wkt = FALSE
    )

    tt_dmg_prod <- ruODK::odata_submission_get(
      table = ft$url[2],
      verbose = verbose,
      local_dir = local_dir,
      download = download,
      odkc_version = odkc_version,
      wkt = FALSE
    )

    tt_tag_prod <- ruODK::odata_submission_get(
      table = ft$url[3],
      verbose = verbose,
      local_dir = local_dir,
      download = download,
      odkc_version = odkc_version,
      wkt = FALSE
    )

    tt_log_prod <- ruODK::odata_submission_get(
      table = ft$url[4],
      verbose = verbose,
      local_dir = local_dir,
      download = download,
      odkc_version = odkc_version,
      wkt = FALSE
    )

    # -------------------------------------------------------------------------#
    # Site Visit Start
    #
    ruODK::ru_setup(fid = "Site-Visit-Start")
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    svs_prod <-
      ruODK::odata_submission_get(
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      )

    # SV start (map)
    ruODK::ru_setup(fid = "Site-Visit-Start-map")
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    svs_prod_map <-
      ruODK::odata_submission_get(
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      )

    # -------------------------------------------------------------------------#
    # Site Visit End
    #
    ruODK::ru_setup(fid = "Site-Visit-End")
    message(glue::glue("Downloading {ruODK::get_default_fid()}"))
    sve_prod <-
      ruODK::odata_submission_get(
        verbose = verbose,
        local_dir = local_dir,
        download = download,
        odkc_version = odkc_version,
        wkt = FALSE
      )

    # -------------------------------------------------------------------------#
    # WAStD Areas
    #
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

    # -------------------------------------------------------------------------#
    # Spatial joins (require sf)
    #
    tracks <- tracks_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates(parse_date = FALSE)

    tracks_dist <- tracks_dist_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates(parse_date = FALSE)

    tracks_log <- tracks_log_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates(parse_date = FALSE)

    tracks_egg <- tracks_egg_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates(parse_date = FALSE)

    tracks_hatch <- tracks_hatch_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates(parse_date = FALSE)

    tracks_fan_outlier <- tracks_fan_outlier_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates(parse_date = FALSE)

    tracks_light <- tracks_light_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
      wastdr::add_dates(parse_date = FALSE)

    track_tally <- tracktally_prod %>%
      sf::st_set_crs(4326) %>%
      sf::st_join(sites, join = sf::st_crosses)

    track_tally_dist <- tracktally_dist_prod


    dist <- dist_prod %>%
      wastdr::join_tsc_sites(sites,
        prefix = "disturbanceobservation_location_"
      ) %>%
      wastdr::add_dates(parse_date = FALSE)

    mwi <- mwi_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "incident_observed_at_") %>%
      wastdr::add_dates(parse_date = FALSE)

    mwi_dmg <- mwi_dmg_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "incident_observed_at_") %>%
      wastdr::add_dates(parse_date = FALSE)

    mwi_tag <- mwi_tag_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "incident_observed_at_") %>%
      wastdr::add_dates(parse_date = FALSE)

    tsi <- tsi_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "encounter_observed_at_") %>%
      wastdr::add_dates(parse_date = FALSE)

    tt <- tt_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "start_geopoint_") %>%
      wastdr::add_dates(parse_date = FALSE)

    tt_dmg <- tt_dmg_prod

    tt_tag <- tt_tag_prod

    tt_log <- tt_log_prod

    svs <- svs_prod %>%
      dplyr::bind_rows(svs_prod_map) %>%
      wastdr::join_tsc_sites(sites, prefix = "site_visit_location_") %>%
      wastdr::add_dates(date_col = "survey_start_time", parse_date = FALSE)

    sve <- sve_prod %>%
      wastdr::join_tsc_sites(sites, prefix = "site_visit_location_") %>%
      wastdr::add_dates(date_col = "survey_end_time", parse_date = FALSE)


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
          track_tally_dist = track_tally_dist,
          dist = dist,
          mwi = mwi,
          mwi_dmg = mwi_dmg,
          mwi_tag = mwi_tag,
          tsi = tsi,
          tt = tt,
          tt_dmg = tt_dmg,
          tt_tag = tt_tag,
          tt_log = tt_log,
          svs = svs,
          sve = sve,
          sites = sites,
          areas = areas
        ),
        class = "odkc_turtledata"
      )

    odkc_turtledata
  }

# usethis::use_test("download_odkc_turtledata_2020")
