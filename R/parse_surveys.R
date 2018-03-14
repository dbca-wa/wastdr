#' Parse a \code{wastd_api_response} of \code{animal-encounters} to tbl_df
#'
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{animal-encounters}, e.g. \code{get_wastd("animal-encounters")}
#' @return A \code{tbl_df} with columns:
#' \itemize{
#'   \item site_name <chr>
#'   \item site_type <chr>
#'   \item site_id <int>
#'   \item start_time <dttm>
#'   \item end_time <dttm>
#'   \item source <chr>
#'   \item source_id <chr>
#'   \item status <chr>
#' }
#' @export
#' @import magrittr
#' @importFrom tibble tibble
#' @importFrom purrr map map_chr map_dbl
parse_surveys <- function(wastd_api_response) {
  obs <- NULL # Make R CMD check happy
  . <- "Shut up Wesley"
  wastd_api_response$features %>% {
    tibble::tibble(
      site_name = map_chr_hack(., c("properties", "site", "name")),
      site_type = map_chr_hack(., c("properties", "site", "area_type")),
      site_id = map_chr_hack(., c("properties", "site", "pk")) %>% as.integer(),

      reporter = map_chr_hack(., c("properties", "reporter", "name")),
      reporter_username = map_chr_hack(., c("properties", "reporter", "username")),
      reporter_id = map_chr_hack(., c("properties", "reporter", "pk")),

      date = purrr::map_chr(., c("properties", "start_time")) %>% httpdate_as_gmt08_turtle_date(),
      start_time = purrr::map_chr(., c("properties", "start_time")) %>% httpdate_as_gmt08(),
      end_time = map_chr_hack(., c("properties", "end_time")) %>% httpdate_as_gmt08(),

      start_comments = map_chr_hack(., c("properties", "start_comments")),
      end_comments = map_chr_hack(., c("properties", "end_comments")),

      source = purrr::map_chr(., c("properties", "source")),
      source_id = purrr::map_chr(., c("properties", "source_id")),
      end_source_id = map_chr_hack(., c("properties", "end_source_id")),
      device_id = map_chr_hack(., c("properties", "device_id")),
      # transect, start_photo, end_photo, start_location, end_location, team
    )
  }
}
