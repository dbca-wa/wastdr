#' #' Download all turtle data from DBCA's ODK Central
#' #'
#' #' \lifecycle{maturing}
#' #'
#' #' @param local_dir A local directory to which to save the attachment files.
#' #'   Attachment filepaths will be relative to the directory.
#' #'   The directory and its parent folders will be created if not existing.
#' #' @param prod The ODKC PROD server,
#' #' default: "https://odkcentral.dbca.wa.gov.au".
#' #' @param uat The ODKC UAT server,
#' #' default: "https://odkcentral-uat.dbca.wa.gov.au".
#' #' @template param-tz
#' #' @param odkc_version The numeric ODK Central version, e.g. 0.7 or 0.8.
#' #' @param download (lgl) Whether to download attachments to `local_dir` or not,
#' #' default: TRUE.
#' #' @template param-verbose
#' #'
#' #' @return An S3 class "odkc_turtledata" with items:
#' #' \itemize{
#' #'   \item downloaded_on An UTC POSIXct timestamp of the data snapshot.
#' #'   \item tracks The turtle tracks and nests from form
#' #'         "Turtle Track or Nest 1.0".
#' #'   \item tracks_dist Individual disturbances recorded against tracks,
#' #'         one row per disturbance.
#' #'   \item tracks_log Individual nest tags recorded against nests,
#' #'         one row per tag.
#' #'   \item tracks_egg Next excavation photos, one row per photo.
#' #'   \item tracks_hatch Turtle hatchling morphometrics, one row per measured
#' #'         hatchling.
#' #'   \item tracks_fan_outlier Individual hatchling track outliers recorded
#' #'         against hatched nests, one row per outlier.
#' #'   \item tracks_light Individual light sources known at hatchling emergence,
#' #'         one row per light source.
#' #'   \item track_tally A line transect tally of turtle tracks from form
#' #'         "Track Tally 0.6".
#' #'   \item dist The disturbance and predation records from form
#' #'         "Predator or Disturbance 1.1".
#' #'   \item mwi Strandings and rescues from the form
#' #'         "Marine Wildlife Incident 0.6 ".
#' #'   \item mwi_dmg Individual injuries recorded against mwi,
#' #'         one record per injury.
#' #'   \item mwi_tag Individual tags sighted during an mwi, one record per tag.
#' #'   \item tsi Turtle Sightings from form "Turtle Sighting 0.1/0.2",
#' #'         one row per sighted turtle.
#' #'   \item tt Placeholder for form `Turtle-Tagging-3-0`, here: NULL.
#' #'   \item tt_dmg Placeholder for form `Turtle-Tagging-3-0` (damages), here: NULL.
#' #'   \item tt_tag Placeholder for form `Turtle-Tagging-3-0` (tags), here: NULL.
#' #'   \item tt_log Placeholder for form `Turtle-Tagging-3-0` (loggers), here: NULL.
#' #'   \item svs Survey start points from form "Site Visit Start 1.3".
#' #'   \item sve Survey end points from form "Site Visit End 1.2".
#' #'   \item sites An sf object of known WAStD sites.
#' #'   \item areas An sf object of known WAStD localities.
#' #'  }
#' #' @export
#' #' @family odkc
#' download_odkc_turtledata_2019 <-
#'   function(local_dir = here::here("media"),
#'            prod = "https://odkc-uat.dbca.wa.gov.au",
#'            uat = "https://odkcentral-uat.dbca.wa.gov.au",
#'            tz = "Australia/Perth",
#'            download = TRUE,
#'            odkc_version = 1.2,
#'            verbose = wastdr::get_wastdr_verbose()) {
#'     if (download == TRUE) fs::dir_create(local_dir, recurse = TRUE) # nocov
#'
#'     ruODK::ru_setup(
#'       pid = 1,
#'       url = prod,
#'       un = ruODK::get_default_un(),
#'       pw = ruODK::get_default_pw()
#'     )
#'     pl <- ruODK::project_list()
#'     # pl
#'
#'     fl <- ruODK::form_list()
#'     # fl
#'
#'     # SV start
#'     ruODK::ru_setup(
#'       pid = 1,
#'       fid = "build_Site-Visit-Start-0-3_1559789550",
#'       url = prod
#'     )
#'     message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     svs_prod <-
#'       ruODK::odata_submission_get(
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       )
#'
#'     # SV end
#'     ruODK::ru_setup(
#'       pid = 1,
#'       fid = "build_Site-Visit-End-0-2_1559789512",
#'       url = prod
#'     )
#'     message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     sve_prod <-
#'       ruODK::odata_submission_get(
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       )
#'
#'     # MWI
#'     ruODK::ru_setup(
#'       pid = 1,
#'       fid = "build_Marine-Wildlife-Incident-0-6_1559789189",
#'       url = prod
#'     )
#'     message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     ft <- ruODK::odata_service_get()
#'
#'     mwi_prod <- ft$url[[1]] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       )
#'
#'     mwi_dmg_prod <- ft$url[[2]] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       ) %>%
#'       dplyr::left_join(mwi_prod, by = c("submissions_id" = "id"))
#'
#'     mwi_tag_prod <- ft$url[[3]] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       ) %>%
#'       dplyr::left_join(mwi_prod, by = c("submissions_id" = "id"))
#'
#'     # Turtle Sighting
#'     ruODK::ru_setup(
#'       pid = 1,
#'       fid = "build_Turtle-Sighting-0-1_1559790020",
#'       url = prod
#'     )
#'     message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     ft <- ruODK::odata_service_get()
#'     tsi01 <- ft$url[[1]] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       )
#'
#'     ruODK::ru_setup(
#'       pid = 1,
#'       fid = "build_Turtle-Sighting-0-2_1581567844",
#'       url = prod
#'     )
#'     message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     ft <- ruODK::odata_service_get()
#'     tsi02 <- ft$url[[1]] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       )
#'
#'     # Dist
#'     ruODK::ru_setup(
#'       pid = 1,
#'       fid = "build_Predator-or-Disturbance-1-1_1559789410",
#'       url = prod
#'     )
#'     message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     dist_prod <-
#'       ruODK::odata_submission_get(
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       )
#'
#'     # Tracks
#'     ruODK::ru_setup(
#'       pid = 1,
#'       fid = "build_Turtle-Track-or-Nest-1-0_1559789920",
#'       url = prod
#'     )
#'     message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     ft <- ruODK::odata_service_get()
#'
#'     tracks_prod <- ft$url[1] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       ) %>%
#'       # wastdr::exclude_training_species_odkc() %>%
#'       wastdr::add_nest_labels_odkc()
#'
#'     tracks_dist_prod <- ft$url[2] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       ) %>%
#'       dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))
#'
#'     tracks_egg_prod <- ft$url[3] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       ) %>%
#'       dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))
#'
#'     tracks_log_prod <- ft$url[4] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       ) %>%
#'       dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))
#'
#'     tracks_hatch_prod <- ft$url[5] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       ) %>%
#'       dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))
#'
#'     tracks_fan_outlier_prod <- ft$url[6] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       ) %>%
#'       dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))
#'
#'     tracks_light_prod <- ft$url[7] %>%
#'       ruODK::odata_submission_get(
#'         table = .,
#'         verbose = verbose,
#'         local_dir = local_dir,
#'         download = download,
#'         odkc_version = odkc_version,
#'         wkt = FALSE
#'       ) %>%
#'       dplyr::left_join(tracks_prod, by = c("submissions_id" = "id"))
#'
#'
#'     # Track Tally (enc and denormalised tt obs)
#'     ruODK::ru_setup(
#'       pid = 1,
#'       fid = "build_Turtle-Track-Tally-0-6_1564387009",
#'       url = prod
#'     )
#'     ft <- ruODK::odata_service_get()
#'     message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     tracktally_prod <- ruODK::odata_submission_get(
#'       table = ft$url[1],
#'       verbose = verbose,
#'       wkt = TRUE,
#'       local_dir = local_dir,
#'       download = download,
#'       odkc_version = odkc_version
#'     ) %>%
#'       dplyr::rename(tx = overview_location) %>%
#'       sf::st_as_sf(wkt = "tx")
#'
#'
#'     tracktally_dist_prod <- ruODK::odata_submission_get(
#'       table = ft$url[2],
#'       verbose = verbose,
#'       wkt = FALSE,
#'       local_dir = local_dir,
#'       download = download,
#'       odkc_version = odkc_version
#'     ) %>%
#'       dplyr::left_join(tracktally_prod, by = c("submissions_id" = "id"))
#'
#'     # Track Tally 0.7
#'     ruODK::ru_setup(
#'       pid = 1,
#'       fid = "build_Turtle-Track-Tally-0-7_1596509970",
#'       url = prod
#'     )
#'     ft <- ruODK::odata_service_get()
#'     message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     tracktally07_prod <- ruODK::odata_submission_get(
#'       table = ft$url[1],
#'       verbose = verbose,
#'       wkt = TRUE,
#'       local_dir = local_dir,
#'       download = download,
#'       odkc_version = odkc_version
#'     ) %>%
#'       dplyr::rename(tx = overview_location) %>%
#'       sf::st_as_sf(wkt = "tx")
#'
#'     # tracktally07_dist_prod <- ruODK::odata_submission_get(
#'     #   table = ft$url[2],
#'     #   verbose = verbose,
#'     #   wkt = TRUE,
#'     #   local_dir = local_dir,
#'     #   download = download,
#'     #   odkc_version = odkc_version
#'     # ) #%>%
#'     #   # dplyr::left_join(tracktally07_prod, by = c("submissions_id" = "id"))
#'
#'     #--------------------------------------------------------------------------#
#'     # Fix error: PROD used UAT db for a week - what's in UAT but not in PROD?
#'
#'     # # SV start
#'     # ruODK::ru_setup(
#'     #   pid = 1,
#'     #   fid = "build_Site-Visit-Start-0-3_1559789550",
#'     #   url = uat
#'     # )
#'     # message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     # svs_uat <-
#'     #   ruODK::odata_submission_get(
#'     #     verbose = verbose,
#'     #     local_dir = local_dir,
#'     #     download = download,
#'     #     odkc_version = odkc_version,
#'     #     wkt = FALSE
#'     #   )
#'     # svs_extra <-
#'     #   dplyr::anti_join(svs_uat, svs_prod, by = "meta_instance_id")
#'     #
#'     # # SV end
#'     # ruODK::ru_setup(
#'     #   pid = 1,
#'     #   fid = "build_Site-Visit-End-0-2_1559789512",
#'     #   url = uat
#'     # )
#'     # message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     # sve_uat <-
#'     #   ruODK::odata_submission_get(
#'     #     verbose = verbose,
#'     #     local_dir = local_dir,
#'     #     download = download,
#'     #     odkc_version = odkc_version,
#'     #     wkt = FALSE
#'     #   )
#'     # sve_extra <-
#'     #   dplyr::anti_join(sve_uat, sve_prod, by = "meta_instance_id")
#'     #
#'     # # MWI
#'     # ruODK::ru_setup(
#'     #   pid = 1,
#'     #   fid = "build_Marine-Wildlife-Incident-0-6_1559789189",
#'     #   url = uat
#'     # )
#'     # message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     # mwi_uat <-
#'     #   ruODK::odata_submission_get(
#'     #     verbose = verbose,
#'     #     local_dir = local_dir,
#'     #     download = download,
#'     #     odkc_version = odkc_version,
#'     #     wkt = FALSE
#'     #   )
#'     # mwi_extra <-
#'     #   dplyr::anti_join(mwi_uat, mwi_prod, by = "meta_instance_id")
#'     #
#'     # # Dist
#'     # ruODK::ru_setup(
#'     #   pid = 1,
#'     #   fid = "build_Predator-or-Disturbance-1-1_1559789410",
#'     #   url = uat
#'     # )
#'     # message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     # dist_uat <-
#'     #   ruODK::odata_submission_get(
#'     #     verbose = verbose,
#'     #     local_dir = local_dir,
#'     #     download = download,
#'     #     odkc_version = odkc_version,
#'     #     wkt = FALSE
#'     #   )
#'     # dist_extra <-
#'     #   dplyr::anti_join(dist_uat, dist_prod, by = "meta_instance_id")
#'     #
#'     # # Tracks
#'     # ruODK::ru_setup(
#'     #   pid = 1,
#'     #   fid = "build_Turtle-Track-or-Nest-1-0_1559789920",
#'     #   url = uat
#'     # )
#'     # message(glue::glue("Downloading {ruODK::get_default_fid()}"))
#'     # ft <- ruODK::odata_service_get()
#'     # tracks_uat <- ft$url[1] %>%
#'     #   ruODK::odata_submission_get(
#'     #     table = .,
#'     #     verbose = verbose,
#'     #     local_dir = local_dir,
#'     #     download = download,
#'     #     odkc_version = odkc_version,
#'     #     wkt = FALSE
#'     #   ) %>%
#'     #   # wastdr::exclude_training_species_odkc() %>%
#'     #   wastdr::add_nest_labels_odkc()
#'     # tracks_extra <-
#'     #   dplyr::anti_join(tracks_uat, tracks_prod, by = "meta_instance_id")
#'     #
#'     # tracks_dist_uat <- ft$url[2] %>%
#'     #   ruODK::odata_submission_get(
#'     #     table = .,
#'     #     verbose = verbose,
#'     #     local_dir = local_dir,
#'     #     download = download,
#'     #     odkc_version = odkc_version,
#'     #     wkt = FALSE
#'     #   ) %>%
#'     #   dplyr::left_join(tracks_uat, by = c("submissions_id" = "id"))
#'     # tracks_dist_extra <- tracks_dist_uat %>%
#'     #   dplyr::anti_join(tracks_dist_prod, by = "meta_instance_id")
#'
#'     areas_sf <- wastdr::wastd_GET("area") %>%
#'       magrittr::extract2("data") %>%
#'       geojsonio::as.json() %>%
#'       geojsonsf::geojson_sf()
#'
#'     areas <- areas_sf %>%
#'       dplyr::filter(area_type == "Locality") %>%
#'       dplyr::transmute(area_id = pk, area_name = name)
#'
#'     sites <- areas_sf %>%
#'       dplyr::filter(area_type == "Site") %>%
#'       dplyr::transmute(site_id = pk, site_name = name) %>%
#'       sf::st_join(areas)
#'
#'     mwi <- # dplyr::bind_rows(mwi_prod, mwi_extra) %>%
#'       mwi_prod %>%
#'       wastdr::join_tsc_sites(sites, prefix = "incident_observed_at_") %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     mwi_dmg <- mwi_dmg_prod %>%
#'       wastdr::join_tsc_sites(sites, prefix = "incident_observed_at_") %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     mwi_tag <- mwi_tag_prod %>%
#'       wastdr::join_tsc_sites(sites, prefix = "incident_observed_at_") %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     tsi <- dplyr::bind_rows(tsi01, tsi02) %>%
#'       wastdr::join_tsc_sites(sites, prefix = "encounter_observed_at_") %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     svs <- # dplyr::bind_rows(svs_prod, svs_extra) %>%
#'       svs_prod %>%
#'       wastdr::join_tsc_sites(sites, prefix = "site_visit_location_") %>%
#'       wastdr::add_dates(date_col = "survey_start_time", parse_date = FALSE)
#'
#'     sve <- # dplyr::bind_rows(sve_prod, sve_extra) %>%
#'       sve_prod %>%
#'       wastdr::join_tsc_sites(sites, prefix = "site_visit_location_") %>%
#'       wastdr::add_dates(date_col = "survey_end_time", parse_date = FALSE)
#'
#'     dist <- # dplyr::bind_rows(dist_prod, dist_extra) %>%
#'       dist_prod %>%
#'       wastdr::join_tsc_sites(sites,
#'         prefix = "disturbanceobservation_location_"
#'       ) %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     tracks <- # dplyr::bind_rows(tracks_prod, tracks_extra) %>%
#'       tracks_prod %>%
#'       wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     tracks_dist <- tracks_dist_prod %>%
#'       # dplyr::bind_rows(tracks_dist_extra) %>%
#'       wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     tracks_log <- tracks_log_prod %>%
#'       wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     tracks_egg <- tracks_egg_prod %>%
#'       wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     tracks_hatch <- tracks_hatch_prod %>%
#'       wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     tracks_fan_outlier <-
#'       tracks_fan_outlier_prod %>%
#'       wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     tracks_light <- tracks_light_prod %>%
#'       wastdr::join_tsc_sites(sites, prefix = "details_observed_at_") %>%
#'       wastdr::add_dates(parse_date = FALSE)
#'
#'     track_tally <- dplyr::bind_rows(tracktally_prod, tracktally07_prod) %>%
#'       sf::st_set_crs(4326) %>%
#'       sf::st_join(sites, join = sf::st_crosses)
#'
#'     track_tally_dist <- tracktally_dist_prod
#'
#'
#'     odkc_turtledata <-
#'       structure(
#'         list(
#'           downloaded_on = Sys.time(),
#'           tracks = tracks,
#'           tracks_dist = tracks_dist,
#'           tracks_egg = tracks_egg,
#'           tracks_log = tracks_log,
#'           tracks_hatch = tracks_hatch,
#'           tracks_fan_outlier = tracks_fan_outlier,
#'           tracks_light = tracks_light,
#'           track_tally = track_tally,
#'           track_tally_dist = track_tally_dist,
#'           dist = dist,
#'           mwi = mwi,
#'           mwi_dmg = mwi_dmg,
#'           mwi_tag = mwi_tag,
#'           tsi = tsi,
#'           tt = NULL,
#'           tt_dmg = NULL,
#'           tt_tag = NULL,
#'           tt_log = NULL,
#'           svs = svs,
#'           sve = sve,
#'           sites = sites,
#'           areas = areas
#'         ),
#'         class = "odkc_turtledata"
#'       )
#'
#'     odkc_turtledata
#'   }

# usethis::use_test("download_odkc_turtledata_2019")
