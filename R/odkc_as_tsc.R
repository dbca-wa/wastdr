#' Top level helper combining all mapped data ODKC to TSC
#'
#' @param odkc_data .
#' @param user_mapping .
#' @export
odkc_as_tsc <- function(odkc_data, user_mapping) {
  # TODO: check that each table and each field of odkc_data has been handled
  # TODO: add base_name to encounter/fast/src routers

  list(
    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-nest-encounters/
    tne = odkc_tracks_as_wastd_tne(odkc_data$tracks, user_mapping),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-nest-disturbance-observations/
    tn_dist = odkc_tracks_dist_as_wastd_tndistobs(odkc_data$tracks_dist),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/nest-tag-observations/
    tn_tags = odkc_tracks_as_wastd_nesttagobs(odkc_data$tracks),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-nest-excavations/
    tn_eggs = odkc_tracks_as_wastd_nestobs(odkc_data$tracks),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-hatchling-morphometrics/
    th_morph = odkc_tracks_hatch_as_wastd_thmorph(odkc_data$tracks_hatch),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-nest-hatchling-emergences/
    th_emerg = odkc_tracks_as_tnhe(odkc_data$tracks),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-nest-hatchling-emergence-outliers/
    th_outlier = odkc_tracks_fan_outlier_as_tnheo(odkc_data$tracks_fan_outlier),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-nest-hatchling-emergence-light-sources/
    th_light = odkc_tracks_light_as_wastd_tnhels(odkc_data$tracks_light),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/logger-encounters/
    loggenc = odkc_tracks_log_as_loggerenc(odkc_data$tracks_log, user_mapping),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/encounters/
    de = odkc_dist_as_distenc(odkc_data$dist, user_mapping),
    tnd_obs = odkc_dist_as_tndo(odkc_data$dist),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/animal-encounters/
    # https://github.com/dbca-wa/wastdr/issues/16
    ae_mwi = odkc_mwi_as_wastd_ae(odkc_data$mwi, user_mapping),

    # -------------------------------------------------------------------- #
    # mwi_dmg > damageobs
    # https://github.com/dbca-wa/wastdr/issues/16
    obs_turtledmg = odkc_mwi_dmg_as_wastd_turtledmg(odkc_data$mwi_dmg),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/tag-observations/
    obs_tagobs = odkc_mwi_tag_as_wastd_tagobs(odkc_data$mwi_tag, user_mapping),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-morphometrics/
    # https://github.com/dbca-wa/wastdr/issues/16
    obs_turtlemorph = odkc_mwi_as_wastd_turtlemorph(odkc_data$mwi, user_mapping),

    # -------------------------------------------------------------------- #
    # https://github.com/dbca-wa/wastdr/issues/17
    # https://tsc.dbca.wa.gov.au/api/1/animal-encounters/
    # ae_sightings = odkc_data$tsi
    ae_tsi = odkc_tsi_as_wastd_ae(odkc_data$tsi, user_mapping)

    # -------------------------------------------------------------------- #
    # tracktally > line tx enc
    #
    # -------------------------------------------------------------------- #
    # https://github.com/dbca-wa/wastdr/issues/15
    # https://tsc.dbca.wa.gov.au/api/1/surveys/
    # make survey end from orphaned sve?
    # surveys = ddkc_svs_sve_to_wastd_surveys(odkc_data$svs, odkc_data$sve)
    #
    # ---------------------------------------------------------------------#
    # https://tsc.dbca.wa.gov.au/api/1/media-attachments/
    # "media_type": "data_sheet",
    # "title": "data sheet",
    # "attachment":
    #
    # media_att_* # generate for each possible media attachment
    # photo eggs (repeats)
    # uptrack, downtrack, nest photos 1-3
    # # turtle nest dist photo
    # mwi photos
  )
}
