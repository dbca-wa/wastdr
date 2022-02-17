#' Download a minimal dataset of turtle observations from WAStD
#'
#' @param source The WAStD Encounter source, default: "odk".
#' @param year The earliest calendar year to be returned. Default: NULL.
#'   This value, if not NULL, will be used to construct a query parameter
#'   \code{when_year_gte=2019}
#' @template param-tokenauth
#' @template param-verbose
#' @return A list of tibbles:
#' \itemize{
#' \item users A tibble of user names, roles, and contact details which can be
#'   used to resolve submitted user names to WAStD user IDs
#' \item enc A tibble of encounters (source, source ID, QA status) which can be
#'   used to determine which encounters to create / update / skip.
#' \item surveys A tibble of surveys reconstructed from source and year.
#' }
#' @export
#' @family api
download_minimal_wastd_turtledata <-
  function(source = "odk",
           year = NULL,
           api_url = wastdr::get_wastdr_api_url(),
           api_token = wastdr::get_wastdr_api_token(),
           verbose = wastdr::get_wastdr_verbose()) {
    # Encounters ----------------------------------------------------------------#
    qry <- list(source = source)
    if (!is.null(year)) {
      qry["when__year__gte"] <- year
    }
    enc <- wastd_GET(
      "encounters-src",
      query = qry,
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ) %>%
      wastd_parse() %>%
      dplyr::select(-geometry)

    # Surveys -----------------------------------------------------------------#
    surveys <- wastd_GET(
      "surveys",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ) %>% wastd_parse()

    survey_media <- wastd_GET(
      "survey-media-attachments",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ) %>% wastd_parse()

    # Media -------------------------------------------------------------------#
    media <- wastd_GET(
      "media-attachments",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ) %>% wastd_parse()

    # Areas and sites ---------------------------------------------------------#
    areas_sf <- wastd_GET("area",
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ) %>%
      magrittr::extract2("data") %>%
      geojsonio::as.json() %>%
      geojsonsf::geojson_sf()

    areas <- areas_sf %>%
      dplyr::filter(area_type == "Locality") %>%
      dplyr::transmute(
        area_id = pk, area_name = name,
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

    list(
      enc = enc,
      surveys = surveys,
      survey_media = survey_media,
      areas = areas,
      sites = sites,
      media = media
    )
  }

# usethis::use_test("download_minimal_wastd_turtledata")
