#' Parse a \code{wastd_api_response} of \code{turtle-nest-encounters} to tbl_df
#'
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{turtle-nest-encounters}, e.g. \code{\link{get_wastd("turtle-nest-encounters")}}
#' @return A \code{tbl_df} with columns:
#' \itemize{
#'   \item datetime (dttm)
#'   \item longitude (dbl)
#'   \item latitude (dbl)
#'   \item crs (chr)
#'   \item location_accuracy (dbl)
#'   \item date (date)
#'   \item species (chr)
#'   \item nest_age (chr)
#'   \item nest_type (chr)
#'   \item habitat (chr)
#'   \item disturbance <chr>
#'   \item absolute_admin_url <chr>
#'   \item obs <list>
#'   \item hatching_success <dbl>
#'   \item emergence_success <dbl>
#'   \item clutch_size <dbl>
#'   \item source <chr>
#'   \item source_id <chr>
#'   \item encounter_type <chr>
#'   \item status <chr>
#' }
#' @export
#' @import magrittr
#' @importFrom tibble tibble
#' @importFrom purrr map map_chr map_dbl
parse_turtle_nest_encounters <- function(wastd_api_response){
    wastd_api_response$content %>% {
        tibble::tibble(
            datetime = purrr::map_chr(., c("properties", "when")) %>% httpdate_as_gmt08,
            longitude = purrr::map_dbl(., c("properties", "longitude")),
            latitude = purrr::map_dbl(., c("properties", "latitude")),
            crs = purrr::map_chr(., c("properties", "crs")),
            location_accuracy = purrr::map_chr(., c("properties", "location_accuracy")) %>% as.integer,
            date = purrr::map_chr(., c("properties", "when")) %>% httpdate_as_gmt08_turtle_date,
            species = purrr::map_chr(., c("properties", "species")),
            nest_age = purrr::map_chr(., c("properties", "nest_age")),
            nest_type = purrr::map_chr(., c("properties", "nest_type")),
            habitat = purrr::map_chr(., c("properties", "habitat")),
            disturbance = purrr::map_chr(., c("properties", "disturbance")),
            # comments = purrr::map_chr(., c("properties", "comments")),
            absolute_admin_url = purrr::map_chr(., c("properties", "absolute_admin_url")),
            obs = purrr::map(., c("properties", "observation_set")),
            hatching_success = obs %>% purrr::map(get_num_field, "hatching_success") %>% as.numeric,
            emergence_success = obs %>% purrr::map(get_num_field, "emergence_success") %>% as.numeric,
            clutch_size = obs %>% purrr::map(get_num_field, "egg_count_calculated") %>% as.numeric,
            source = purrr::map_chr(., c("properties", "source")),
            source_id = purrr::map_chr(., c("properties", "source_id")),
            encounter_type = purrr::map_chr(., c("properties", "encounter_type")),
            status = purrr::map_chr(., c("properties", "status"))
        )
    }
}
