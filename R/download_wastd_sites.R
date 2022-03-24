#' Download Areas of type Site from WAStD
#' @template param-tokenauth
#' @template param-verbose
#' @param save If supplied, the filepath to save the data object to.
#' @param compress The saveRDS compression parameter, default: "xz".
#'   Set to FALSE for faster writes and reads but larger filesize.
#' @return A list
#'
#'   * downloaded_on A timestamp of the download
#'   * localities A `sf` object of WAStD Areas of type Locality
#'   * sites An `sf` object of WAStD Areas of type Sites joined to Localities.
#' @export
#' @family api
download_wastd_sites <- function(api_url = wastdr::get_wastdr_api_url(),
                                 api_token = wastdr::get_wastdr_api_token(),
                                 verbose = wastdr::get_wastdr_verbose(),
                                 save = NULL,
                                 compress = "xz") {
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

  sites <- list(
    downloaded_on = downloaded_on,
    areas = areas,
    sites = sites
  )

  if (!is.null(save)) {
    "Saving WAStD sites to {save}..." %>%
      glue::glue() %>%
      wastdr::wastdr_msg_success()
    saveRDS(sites, file = save, compress = compress)
    "Done. Open the saved file with\nwastd_sites <- readRds({save})" %>%
      glue::glue() %>%
      wastdr::wastdr_msg_success()
  }

  sites
}

# usethis::use_test("download_wastd_sites")
