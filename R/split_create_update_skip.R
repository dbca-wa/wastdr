#' Top level helper to split all Turtle Nesting Census data per skip logic
#'
#' Encounters and their related observations are uploaded to WAStD:
#'
#' * New encounters will be created
#' * Existing but unchanged (status=new) encounters will be updated
#'   if `update_existing=TRUE`, else skipped.
#' * Existing and value-added encounters (status > new) will be skipped.s
#'
#' @param odkc_prep ODKC data transformed into WAStD format.
#' @param wastd_data Minimal WAStD data to inform skip logic.
#' @return A list of results from the various uploads.
#'   Each result is a `wastd_api_response` or a tibble of data (`_skip`).
#' @export
split_create_update_skip <- function(odkc_prep, wastd_data) {
  # WAStD Encounters are considered unchanged if QA status is "new" and
  # can be updated without losing edits applied in WAStD.
  enc_update <- wastd_data$enc %>% dplyr::filter(status == "new")

  # WAStD Encounters are considered changed if QA status is not "new" and
  # should never be overwritten, as that would overwrite edits.
  enc_skip <- wastd_data$enc %>% dplyr::filter(status != "new")

  svy_update <- wastd_data$surveys %>% dplyr::filter(status == "new")
  svy_skip <- wastd_data$surveys %>% dplyr::filter(status != "new")

  list(
    # Tracks ------------------------------------------------------------------#
    tne_create = odkc_prep$tne %>%
      dplyr::anti_join(wastd_data$enc, by = "source_id"),
    tne_update = odkc_prep$tne %>%
      dplyr::semi_join(enc_update, by = "source_id"),
    tne_skip = odkc_prep$tne %>%
      dplyr::semi_join(enc_skip, by = "source_id"),

    tn_dist_create = odkc_prep$tn_dist %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    tn_dist_update = odkc_prep$tn_dist %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    tn_dist_skip = odkc_prep$tn_dist %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    tn_tags_create = odkc_prep$tn_tags %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    tn_tags_update = odkc_prep$tn_tags %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    tn_tags_skip = odkc_prep$tn_tags %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    tn_eggs_create = odkc_prep$tn_eggs %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    tn_eggs_update = odkc_prep$tn_eggs %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    tn_eggs_skip = odkc_prep$tn_eggs %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    th_morph_create = odkc_prep$th_morph %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    th_morph_update = odkc_prep$th_morph %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    th_morph_skip = odkc_prep$th_morph %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    th_emerg_create = odkc_prep$th_emerg %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    th_emerg_update = odkc_prep$th_emerg %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    th_emerg_skip = odkc_prep$th_emerg %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    th_outlier_create = odkc_prep$th_outlier %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    th_outlier_update = odkc_prep$th_outlier %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    th_outlier_skip = odkc_prep$th_outlier %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    th_light_create = odkc_prep$th_light %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    th_light_update = odkc_prep$th_light %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    th_light_skip = odkc_prep$th_light %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    # TrackTally Encounters ---------------------------------------------------#
    tte_create = odkc_prep$tte %>%
      dplyr::anti_join(wastd_data$enc, by = "source_id"),
    tte_update = odkc_prep$tte %>%
      dplyr::semi_join(enc_update, by = "source_id"),
    tte_skip = odkc_prep$tte %>%
      dplyr::semi_join(enc_skip, by = "source_id"),

    # tto
    tto_create = odkc_prep$tto %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    tto_update = odkc_prep$tto %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    tto_skip = odkc_prep$tto %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    # ttd
    ttd_create = odkc_prep$ttd %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    ttd_update = odkc_prep$ttd %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    ttd_skip = odkc_prep$ttd %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    # Logger Encounters -------------------------------------------------------#
    le_create = odkc_prep$le %>%
      dplyr::anti_join(wastd_data$enc, by = "source_id"),
    le_update = odkc_prep$le %>%
      dplyr::semi_join(enc_update, by = "source_id"),
    le_skip = odkc_prep$le %>%
      dplyr::semi_join(enc_skip, by = "source_id"),

    # Disturbance Encounters --------------------------------------------------#
    de_mwi_create = odkc_prep$de %>%
      dplyr::anti_join(wastd_data$enc, by = "source_id"),
    de_mwi_update = odkc_prep$de %>%
      dplyr::semi_join(enc_update, by = "source_id"),
    de_mwi_skip = odkc_prep$de %>%
      dplyr::semi_join(enc_skip, by = "source_id"),

    # Disturbance TND obs
    tnd_obs_create = odkc_prep$tnd_obs %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    tnd_obs_update = odkc_prep$tnd_obs %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    tnd_obs_skip = odkc_prep$tnd_obs %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),


    # MWI > AE ----------------------------------------------------------------#
    ae_mwi_create = odkc_prep$ae_mwi %>%
      dplyr::anti_join(wastd_data$enc, by = "source_id"),
    ae_mwi_update = odkc_prep$ae_mwi %>%
      dplyr::semi_join(enc_update, by = "source_id"),
    ae_mwi_skip = odkc_prep$ae_mwi %>%
      dplyr::semi_join(enc_skip, by = "source_id"),

    # MWI > obs turtlemorph
    obs_turtlemorph_create = odkc_prep$obs_turtlemorph %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    obs_turtlemorph_update = odkc_prep$obs_turtlemorph %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    obs_turtlemorph_skip = odkc_prep$obs_turtlemorph %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    obs_tagobs_create = odkc_prep$obs_tagobs %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    obs_tagobs_update = odkc_prep$obs_tagobs %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    obs_tagobs_skip = odkc_prep$obs_tagobs %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    obs_turtledmg_create = odkc_prep$obs_turtledmg %>%
      dplyr::anti_join(wastd_data$enc, by = c("encounter_source_id" = "source_id")),
    obs_turtledmg_update = odkc_prep$obs_turtledmg %>%
      dplyr::semi_join(enc_update, by = c("encounter_source_id" = "source_id")),
    obs_turtledmg_skip = odkc_prep$obs_turtledmg %>%
      dplyr::semi_join(enc_skip, by = c("encounter_source_id" = "source_id")),

    # TSI > AE ----------------------------------------------------------------#
    ae_tsi_create = odkc_prep$ae_tsi %>%
      dplyr::anti_join(wastd_data$enc, by = "source_id"),
    ae_tsi_update = odkc_prep$ae_tsi %>%
      dplyr::semi_join(enc_update, by = "source_id"),
    ae_tsi_skip = odkc_prep$ae_tsi %>%
      dplyr::semi_join(enc_skip, by = "source_id"),

    # Surveys -----------------------------------------------------------------#
    svy_create = odkc_prep$surveys %>%
      dplyr::anti_join(wastd_data$surveys, by = "source_id"),
    svy_update = odkc_prep$surveys %>%
      dplyr::semi_join(svy_update, by = "source_id"),
    svy_skip = odkc_prep$surveys %>%
      dplyr::semi_join(svy_skip, by = "source_id")
  )
}
