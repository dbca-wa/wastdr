#' Top level helper to upload all Turtle Nesting Census data to WAStD
#'
#' Encounters and their related observations are uploaded to WAStD:
#'
#' * New encounters will be created
#' * Existing but unchanged (status=new) encounters will be updated
#'   if `update_existing=TRUE`, else skipped.
#' * Existing and value-added encounters (status > new) will be skipped.s
#'
#' @param data ODKC data transformed into WAStD format and split into create,
#'   update, skip.
#' @param update_existing Whether to update existing but unchanged records in
#'   WAStD Default: FALSE.
#' @template param-auth
#' @template param-verbose
#' @return A list of results from `wastd_create_update_skip`.
#' @export
upload_odkc_to_wastd <- function(data,
                               update_existing = FALSE,
                               api_url = wastdr::get_wastdr_api_url(),
                               api_token = wastdr::get_wastdr_api_token(),
                               api_un = wastdr::get_wastdr_api_un(),
                               api_pw = wastdr::get_wastdr_api_pw(),
                               verbose = wastdr::get_wastdr_verbose()) {
  list(
    # Tracks ------------------------------------------------------------------#
    tne = wastd_create_update_skip(
      data$tne_create,
      data$tne_update,
      data$tne_skip,
      update_existing = update_existing,
      serializer = "turtle-nest-encounters",
      label = "TurtleNestEncounters",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    tn_dist = wastd_create_update_skip(
      data$tn_dist_create,
      data$tn_dist_update,
      data$tn_dist_skip,
      update_existing = update_existing,
      serializer = "turtle-nest-disturbance-observations",
      label = "TurtleNestDisturbanceObservations",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    tn_tags = wastd_create_update_skip(
      data$tn_tags_create,
      data$tn_tags_update,
      data$tn_tags_skip,
      update_existing = update_existing,
      serializer = "nest-tag-observations",
      label = "TurtleNestTagObservations",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    tn_eggs = wastd_create_update_skip(
      data$tn_eggs_create,
      data$tn_eggs_update,
      data$tn_eggs_skip,
      update_existing = update_existing,
      serializer = "turtle-nest-excavations",
      label = "TurtleNestObservations",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    th_morph = wastd_create_update_skip(
      data$th_morph_create,
      data$th_morph_update,
      data$th_morph_skip,
      update_existing = update_existing,
      serializer = "turtle-hatchling-morphometrics",
      label = "TurtleHatchlingMorphometrics",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    th_emerg = wastd_create_update_skip(
      data$th_emerg_create,
      data$th_emerg_update,
      data$th_emerg_skip,
      update_existing = update_existing,
      serializer = "turtle-nest-hatchling-emergences",
      label = "TurtleNestHatchlingEmergences",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    th_outlier = wastd_create_update_skip(
      data$th_outlier_create,
      data$th_outlier_update,
      data$th_outlier_skip,
      update_existing = update_existing,
      serializer = "turtle-nest-hatchling-emergence-outliers",
      label = "TurtleNestHatchlingEmergenceOutliers",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    th_light = wastd_create_update_skip(
      data$th_light_create,
      data$th_light_update,
      data$th_light_skip,
      update_existing = update_existing,
      serializer = "turtle-nest-hatchling-emergence-light-sources",
      label = "TurtleNestHatchlingEmergenceLightSources",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    # tracktally
    tte = wastd_create_update_skip(
      data$tte_create,
      data$tte_update,
      data$tte_skip,
      update_existing = update_existing,
      serializer = "line-transect-encounters",
      label = "LineTransectEncounters (Track Tally)",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    tto = wastd_create_update_skip(
      data$tto_create,
      data$tto_update,
      data$tto_skip,
      update_existing = update_existing,
      serializer = "track-tally",
      label = "LineTransectEncounters (Track Tally) counts",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    ttd = wastd_create_update_skip(
      data$ttd_create,
      data$ttd_update,
      data$ttd_skip,
      update_existing = update_existing,
      serializer = "turtle-nest-disturbance-tally",
      label = "LineTransectEncounters (Track Tally) dist",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),


    # MWI > AE ----------------------------------------------------------------#
    ae_mwi = wastd_create_update_skip(
      data$ae_mwi_create,
      data$ae_mwi_update,
      data$ae_mwi_skip,
      update_existing = update_existing,
      serializer = "animal-encounters",
      label = "AnimalEncounters (MWI)",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    obs_turtlemorph = wastd_create_update_skip(
      data$obs_turtlemorph_create,
      data$obs_turtlemorph_update,
      data$obs_turtlemorph_skip,
      update_existing = update_existing,
      serializer = "turtle-morphometrics",
      label = "TurtleMorphometrics",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    obs_tagobs = wastd_create_update_skip(
      data$obs_tagobs_create,
      data$obs_tagobs_update,
      data$obs_tagobs_skip,
      update_existing = update_existing,
      serializer = "tag-observations",
      label = "TagObservations",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    obs_turtledmg = wastd_create_update_skip(
      data$obs_turtledmg_create,
      data$obs_turtledmg_update,
      data$obs_turtledmg_skip,
      update_existing = update_existing,
      serializer = "turtle-damage-observations",
      label = "TurtleDamageObservations",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    # TSI > AE ----------------------------------------------------------------#
    ae_tsi = wastd_create_update_skip(
      data$ae_tsi_create,
      data$ae_tsi_update,
      data$ae_tsi_skip,
      update_existing = update_existing,
      serializer = "animal-encounters",
      label = "Animal Encounters (TSI)",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    # tracks_log > LE ---------------------------------------------------------#

    le = wastd_create_update_skip(
      data$le_create,
      data$le_update,
      data$le_skip,
      update_existing = update_existing,
      serializer = "logger-encounters",
      label = "Logger Encounters",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    de = wastd_create_update_skip(
      data$de_mwi_create,
      data$de_mwi_update,
      data$de_mwi_skip,
      update_existing = update_existing,
      serializer = "encounters",
      label = "Encounters (General Dist)",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    tnd_obs = wastd_create_update_skip(
      data$tnd_obs_create,
      data$tnd_obs_update,
      data$tnd_obs_skip,
      update_existing = update_existing,
      serializer = "turtle-nest-disturbance-observations",
      label = "TurtleNestDisturbanceObservations (General Dist)",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ),

    svy = wastd_create_update_skip(
      data$svy_create,
      data$svy_update,
      data$svy_skip,
      update_existing = update_existing,
      serializer = "surveys",
      label = "Surveys",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    )
  )
}
