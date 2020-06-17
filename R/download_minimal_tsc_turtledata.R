#' Download a minimal dataset of turtle observations from TSC
#'
#' @param source The TSC Encounter source, default: "odk".
#' @param year The earliest calendar year to be returned. Default: NULL.
#'   This value, if not NULL, will be used to construct a query parameter
#'   \code{when_year_gte=2019}
#' @return A list of tibbles:
#' \itemize{
#' \item users A tibble of user names, roles, and contact details which can be
#'   used to resolve submitted user names to TSC user IDs
#' \item enc A tibble of encounters (source, source ID, QA status) which can be
#'   used to determine which encounters to create / update / skip.
#' \item surveys A tibble of surveys reconstructed from source and year.
#' }
#' @export
download_minimal_tsc_turtledata <- function(source = "odk", year = NULL) {
  users <- wastd_GET("users") %>% wastd_parse()

  qry <- list(source = source)
  if (!is.null(year)) qry["when__year__gte"] <- year

  enc <- wastd_GET("encounters-src", query = qry) %>%
    wastd_parse() %>%
    dplyr::select(-geometry)

  surveys <- wastd_GET("surveys") %>% wastd_parse()

  areas_sf <- wastdr::wastd_GET("area") %>%
    magrittr::extract2("data") %>%
    geojsonio::as.json() %>%
    geojsonsf::geojson_sf()

  areas <- areas_sf %>%
    dplyr::filter(area_type == "Locality") %>%
    dplyr::transmute(area_id = pk, area_name = name)

  sites <- areas_sf %>%
    dplyr::filter(area_type == "Site") %>%
    dplyr::transmute(site_id = pk, site_name = name) %>%
    sf::st_join(areas)


  users <- wastd_GET("users") %>% wastd_parse()

  list(
    users = users,
    enc = enc,
    surveys = surveys,
    areas = areas,
    sites = sites
  )
}
