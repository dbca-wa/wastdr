#' Download Areas of type Site from WAStD
#' @template param-tokenauth
#' @template param-verbose
#' @return An `sf` dataframe of WAStD Sites joined to Locality details.
#' @export
#' @family api
download_wastd_sites <- function(api_url = wastdr::get_wastdr_api_url(),
                                 api_token = wastdr::get_wastdr_api_token(),
                                 verbose = wastdr::get_wastdr_verbose()) {

  downloaded_on <- Sys.time()
  areas_sf <- wastdr::wastd_GET("area") %>%
    magrittr::extract2("data") %>%
    geojsonio::as.json() %>%
    geojsonsf::geojson_sf()

  areas <- areas_sf %>%
    dplyr::filter(area_type == "Locality") %>%
    dplyr::transmute(
      area_id = pk,
      area_name = name,
      w2_location_code = w2_location_code
    )

  sites <- areas_sf %>%
    dplyr::filter(area_type == "Site") %>%
    dplyr::transmute(
      site_id = pk,
      site_name = name,
      w2_place_code = w2_place_code
    ) %>%
    sf::st_join(areas)

  list(downloaded_on = downloaded_on, localities = areas, sites = sites)
}

# usethis::use_test("download_wastd_sites")
