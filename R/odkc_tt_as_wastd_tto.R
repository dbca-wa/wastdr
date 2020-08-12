#' Transform odkc_data$track_tally into WAStD TrackTallyObservations.
#'
#' @param data The tibble of Turtle Track Tallies,
#'   e.g. \code{odkc_data$track_tally}.
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("track-tally")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' tto <- odkc_tt_as_wastd_tto(odkc_data$track_tally)
#'
#' tto %>%
#'   wastd_POST("track-tally",
#'     api_url = Sys.getenv("WASTDR_API_DEV_URL"),
#'     api_token = Sys.getenv("WASTDR_API_DEV_TOKEN")
#'   )
#' }
odkc_tt_as_wastd_tto <- function(data) {

    data %>%
        sf_as_tbl() %>%
        dplyr::select(
            dplyr::starts_with(
                c("id", "fb_", "gn_", "lh_", "hb_", "or_", "unk_")
            )
        ) %>%
        tidyr::pivot_longer(-id, names_to="tracktype", values_to="tally") %>%
        tidyr::separate(
            "tracktype",
            c("species", "species2", "no", "nest_age", "nest_type"),
            sep = "_",
            extra="merge"
        ) %>%
        dplyr::select(-"species2", -"no") %>%
        tidyr::drop_na("tally") %>%
        dplyr::transmute(
            source = 2,
            source_id = id,
            encounter_source="odk",
            encounter_source_id = id,
            species = dplyr::case_when(
                species == "fb" ~ "natator-depressus",
                species == "gn" ~ "chelonia-mydas",
                species == "hb" ~ "eretmochelys-imbricata",
                species == "lh" ~ "caretta-caretta",
                species == "or" ~ "lepidochelys-olivacea",
                species == "unk" ~ "cheloniidae-fam"
            ),
            # nest_age: fresh, old, unknown, missed
            nest_age = nest_age %>% stringr::str_replace("hatched", "old"),
            # nest_type: track-not-assessed, false-crawl, successful-crawl,
            # track-unsure, nest, hatched-nest, body-pit
            nest_type = dplyr::case_when(
                nest_type == "successful_crawls" ~ "successful-crawl",
                nest_type == "tracks" ~ "track-not-assessed",
                nest_type == "false_crawls" ~ "false-crawl",
                nest_type == "tracks_unsure" ~ "track-unsure",
                nest_type == "tracks_not_assessed" ~ "track-not-assessed",
                nest_type == "nests" ~ "hatched-nest"
            ),
            tally = tally
        ) %>%
        dplyr::filter_at(
            dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
            dplyr::any_vars(!is.na(.))
        )
}

# usethis::use_test("odkc_tt_as_wastd_tto")
