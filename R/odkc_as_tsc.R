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

    # tn-excavations = odkc_data$tracks (egg_count...)
    #
    # "observation_name": "turtlenestobservation",
    # "nest_position": "in-dune-vegetation",
    # "eggs_laid": false,
    # "egg_count": null,
    # "hatching_success": 100.0,
    # "emergence_success": 100.0,
    # "no_egg_shells": 10, ## Source fields
    # "no_live_hatchlings_neck_of_nest": null,
    # "no_live_hatchlings": 0,
    # "no_dead_hatchlings": 0,
    # "no_undeveloped_eggs": 0,
    # "no_unhatched_eggs": 0,
    # "no_unhatched_term": 0,
    # "no_depredated_eggs": 0,
    # "nest_depth_top": 0,
    # "nest_depth_bottom": 500,
    # "sand_temp": null,
    # "air_temp": null,
    # "water_temp": null,
    # "egg_temp": null,
    # "comments": null
    #
    #
    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-hatchling-morphometrics/
    # turtle_hatchling_morphometrics = odkc_data$tracks_hatch
    #
    # "straight_carapace_length_mm": 12,
    # "straight_carapace_width_mm": 13,
    # "body_weight_g": 14
    #
    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-nest-hatchling-emergences/
    # tn_hatchling_emergences = odkc_data$tracks (fan_angle...)
    # "observation_name": "turtlehatchlingemergenceobservation",
    # "latitude": -20.3068016667,
    # "longitude": 118.61307,
    # "bearing_to_water_degrees": null,
    # "bearing_leftmost_track_degrees": null,
    # "bearing_rightmost_track_degrees": null,
    # "no_tracks_main_group": 1,
    # "no_tracks_main_group_min": null,
    # "no_tracks_main_group_max": null,
    # "outlier_tracks_present": "absent",
    # "path_to_sea_comments": "clear None",
    # "hatchling_emergence_time_known": "no",
    # "light_sources_present": "na",
    # "hatchling_emergence_time": null,
    # "hatchling_emergence_time_accuracy": null,
    # "cloud_cover_at_emergence": null
    #
    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-nest-hatchling-emergence-outliers/
    # tnhe_outlier = odkc_data$tracks_fan_outlier
    #
    # "observation_name": "turtlehatchlingemergenceoutlierobservation",
    # "latitude": -21.4608516667,
    # "longitude": 115.02234,
    # "bearing_outlier_track_degrees": 12.0,
    # "outlier_group_size": 1,
    # "outlier_track_comment": null
    #
    #
    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-nest-hatchling-emergence-light-sources/
    # tnhe_light_sources = odkc_data$tracks_light
    #
    # "observation_name": "lightsourceobservation",
    # "latitude": -20.306645,
    # "longitude": 118.613845,
    # "bearing_light_degrees": 200.0,
    # "light_source_type": "artificial",
    # "light_source_description": "Street lights"
    #
    #
    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/animal-encounters/
    # https://github.com/dbca-wa/wastdr/issues/16
    ae_mwi = odkc_mwi_as_wastd_ae(odkc_data$mwi, user_mapping),
    # obs_media = odkc_mwi_as_wastd_media(odkc_data$mwi),

    # -------------------------------------------------------------------- #
    # mwi_dmg > damageobs
    # https://github.com/dbca-wa/wastdr/issues/16
    # obs_turtledmg = odkc_mwi_dmg_as_wastd_turtledmg(odkc_data$mwi_dmg, user_mapping),

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/tag-observations/
    # obs_tagobs = odkc_mwi_tag_as_wastd_tagobs(odkc_data$mwi_tag, user_mapping),
    # mwi_tag > tagobs
    # "tag_type": "flipper-tag",
    # "name": "WA49138",
    # "tag_location": "flipper-front-left-1",
    # "status": "removed",
    # "comments": ""

    # -------------------------------------------------------------------- #
    # https://tsc.dbca.wa.gov.au/api/1/turtle-morphometrics/
    # https://github.com/dbca-wa/wastdr/issues/16
    obs_turtlemorph = odkc_mwi_as_wastd_turtlemorph(odkc_data$mwi, user_mapping)

    # -------------------------------------------------------------------- #
    # https://github.com/dbca-wa/wastdr/issues/17
    # https://tsc.dbca.wa.gov.au/api/1/animal-encounters/
    # ae_sightings = odkc_data$tsi
    # ae_tsi = odkc_tsi_as_wastd_ae(odkc_data$tsi, user_mapping),
    #
    # "comments": null,
    # "crs": "WGS 84",
    # "location_accuracy": "10",
    # "when": "2015-01-21T08:00:00+08:00",
    # "name": null,
    # "taxon": "Cheloniidae",
    # "species": "chelonia-mydas",
    # "health": "dead-disarticulated",
    # "sex": "na",
    # "maturity": "juvenile",
    # "behaviour": "",
    # "habitat": "beach",
    # "activity": "na",
    # "nesting_event": "na",
    # "checked_for_injuries": "na",
    # "scanned_for_pit_tags": "na",
    # "checked_for_flipper_tags": "na",
    # "cause_of_death": "indeterminate-decomposed",
    # "cause_of_death_confidence": "expert-opinion",
    #
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
