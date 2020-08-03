#' Join a dataframe with lat/lon to sf objects of sites and areas.
#'
#' \lifecycle{stable}
#'
#' @param data A dataframe with an optionally prefixed latitude and longitude
#' @param sites An sf object of WAStD sites
#' @param prefix An optional prefix to the longitude/latitude field names,
#'   default: "observed_at_".
#' @return The dataframe as sf with site/area joined.
#' @export
#' @family helpers
join_tsc_sites <- function(data, sites, prefix = "observed_at_") {
  lon <- glue::glue("{prefix}longitude") %>% as.character()
  lat <- glue::glue("{prefix}latitude") %>% as.character()
  data %>%
    tidyr::drop_na(lon) %>%
    tidyr::drop_na(lat) %>%
    sf::st_as_sf(
      coords = c(lon, lat),
      crs = 4326,
      agr = "constant",
      remove = FALSE
    ) %>%
    sf::st_join(sites)
}

# usethis::use_test("join_tsc_sites")
