#' Map WAMTRAM data
#'
#' @param data The output of `wastdr::download_w2_data()`.
#' @param location A W2 location code, e.g. "TH", to filter the data by.
#' @param place A W2 place code, e.g. "THEE", to filter the data by. Providing
#'   `place` overrides `location`.
#' @param obs_id An Observation ID to filter W2 obs by.
#' @param wa_sites WAStD Sites (joined to Localities) to display.
#' @param l_width The parameter `width` for `leaflet::leaflet()`.
#' @param l_height The parameter `height` for `leaflet::leaflet()`.
#' @return A leaflet map showing W2 sites and encounters.
#' @export
#' @family wamtram
#' @examples \dontrun{
#' data("w2_data", package = "etlTurtleNesting")
#' w2_data <- readRDS("~/projects/etlTurtleNesting/inst/w2.rds")
#' map_wamtram(w2_data)
#'
#' map_wamtram(w2_data, location = "DH")
#' map_wamtram(w2_data, place = "THEE")
#'
#' map_wamtram(w2_data, place = "WKBB", l_height = "calc(100vh - 80px)")
#'
#' # With WAStD Sites
#' areas_sf <- wastd_GET("area") %>%
#'   magrittr::extract2("data") %>%
#'   geojsonio::as.json() %>%
#'   geojsonsf::geojson_sf()
#'
#' areas <- areas_sf %>%
#'   dplyr::filter(area_type == "Locality") %>%
#'   dplyr::transmute(area_id = pk, area_name = name, w2_location_code = w2_location_code)
#'
#' sites <- areas_sf %>%
#'   dplyr::filter(area_type == "Site") %>%
#'   dplyr::transmute(site_id = pk, site_name = name, w2_place_code = w2_place_code) %>%
#'   sf::st_join(areas)
#'
#' map_wamtram(w2_data, place = "THEE", wa_sites = sites)
#' }
map_wamtram <- function(data, location = NULL, place = NULL, obs_id = NULL,
                        wa_sites = NULL, l_width = NULL, l_height = NULL) {
  # Gatechecks ----------------------------------------------------------------#
  verify_wamtram_data(data)

  # Filter WAMTRAM Encounters by loc, place, obs ID ---------------------------#
  enc <- data$enc %>%
    dplyr::filter(
      !is.na(longitude),
      !is.na(latitude),
      longitude > -180,
      longitude < 180,
      latitude > -90,
      latitude < 90
    )

  sites <- data$sites %>%
    dplyr::filter(!is.na(site_longitude), !is.na(site_latitude))

  if (!is.null(location) && location != "") {
    enc <- enc %>% dplyr::filter(location_code == location)
    sites <- sites %>% dplyr::filter(prefix == location)
  }

  if (!is.null(place) && place != "") {
    enc <- enc %>% dplyr::filter(place_code == place)
    sites <- sites %>% dplyr::filter(code == place)
  }

  if (!is.null(obs_id) && obs_id != "") {
    enc <- enc %>% dplyr::filter(observation_id == obs_id)
  }

  # Basemap -------------------------------------------------------------------#
  co <- NULL
  co <- if (nrow(enc) > 1000) leaflet::markerClusterOptions()

  l <- leaflet_basemap()

  # Split WAMTRAM Encounters by season ----------------------------------------#
  data.df <- enc %>% split(enc$season)
  seasons <- as.integer(names(data.df))
  og <- c(glue::glue("Turtles {seasons}-{seasons+1}"), "WAMTRAM sites")

  names(data.df) %>%
    purrr::walk(function(df) {
      l <<- l %>%
        leaflet::addAwesomeMarkers(
          data = data.df[[df]],
          lng = ~longitude,
          lat = ~latitude,
          icon = leaflet::makeAwesomeIcon(markerColor = "red", iconColor = "white"),
          label = ~ glue::glue("{observation_datetime_gmt08} {species_code} {observation_status}"),
          # observation_id turtle_id alive measurer_person_id
          # measurer_reporter_person_id tagger_person_id reporter_person_id
          # place_code place_description datum_code latitude longitude
          # latitude_degrees latitude_minutes latitude_seconds
          # longitude_degrees longitude_minutes longitude_seconds zone easting
          # northing activity_code beach_position_code condition_code nesting
          # clutch_completed number_of_eggs egg_count_method measurements
          # action_taken comments entered_by date_entered
          # original_observation_id entry_batch_id
          # comment_fromrecordedtagstable scars_left scars_right other_tags
          # other_tags_identification_type transfer_id mund
          # entered_by_person_id scars_left_scale_1 scars_left_scale_2
          # scars_left_scale_3 scars_right_scale_1 scars_right_scale_2
          # scars_right_scale_3 cc_length_not_measured
          # cc_notch_length_not_measured cc_width_not_measured
          # tag_scar_not_checked did_not_check_for_injury date_convention
          # observation_status o_date o_time observation_datetime_gmt08
          # observation_datetime_utc longitude_dd latitude_dd
          # latitude_from_dms longitude_from_dms activity_description
          # activity_is_nesting activity_label display_this_observation label
          # prefix is_rookery beach_approach beach_aspect site_datum
          # site_latitude site_longitude description species_code
          # identification_confidence sex turtle_status location_code
          # cause_of_death re_entered_population turtle_comments
          # original_turtle_id tag mund_id turtle_name
          #
          # <strong></strong> {}<br/>
          popup = ~ glue::glue('
            <h4>{species_code} {observation_status}</h4>
            <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span> <strong>Seen on</strong> {observation_datetime_gmt08} AWST<br/>
            <span class="glyphicon glyphicon-tags" aria-hidden="true"></span> <strong>Turtle ID</strong> {turtle_id}<br/>
            <span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span> <strong>ObsID</strong> {observation_id}<br/>
            <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span> <strong>{location_code} {place_code}</strong><br/>
            <span class="glyphicon glyphicon-globe" aria-hidden="true"></span> <strong>Chosen</strong> {latitude}  {longitude}<br/>
            <span class="glyphicon glyphicon-pushpin" aria-hidden="true"></span> <strong>Supplied DD</strong> {latitude_dd}  {longitude_dd}<br/>
            <span class="glyphicon glyphicon-pushpin" aria-hidden="true"></span> <strong>Supplied DMS</strong> {latitude_from_dms}  {longitude_from_dms}<br/>
            <span class="glyphicon glyphicon-pushpin" aria-hidden="true"></span> <strong>Supplied EN</strong> {northing} {easting} {zone} {datum_code}<br/>
                '),
          group = glue::glue("Turtles {df}-{as.integer(df)+1}"),
          clusterOptions = co
        )
    })

  # WAMTRAM sites -------------------------------------------------------------#
  l %>%
    leaflet::addAwesomeMarkers(
      data = sites,
      lng = ~site_longitude,
      lat = ~site_latitude,
      icon = leaflet::makeAwesomeIcon(markerColor = "green", iconColor = "white", icon = "tag"),
      label = ~ glue::glue("[{prefix} {code}] {label}"),
      popup = ~ glue::glue('
                <h4>{label}</h4>
                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span> {prefix} {code}<br/>
                <span class="glyphicon glyphicon-pushpin" aria-hidden="true"></span>
                {round(site_latitude, 5)} {round(site_longitude, 5)}<br/>
                <span class="glyphicon glyphicon-comment" aria-hidden="true"></span> {description}
            '),
      group = "WAMTRAM sites"
    ) %>%
    # WAStD sites -------------------------------------------------------------#
    {
      if (!is.null(wa_sites)) {
        og <<- c(og, "WAStD Sites")

        leaflet::addPolygons(
          .,
          data = wa_sites,
          weight = 1,
          fillOpacity = 0.5,
          fillColor = "green",
          label = ~ glue::glue("[{w2_location_code} {w2_place_code}] {site_name}"),
          popup = ~ glue::glue(
            '<h3>{site_name}</h3>
        <strong>W2 location</strong> {w2_location_code}<br/>
        <strong>W2 place</strong> {w2_place_code}<br/>
        <a href="https://wastd.dbca.wa.gov.au/admin/observations/area/{site_id}"
         class="btn btn-xs btn-success"
         target="_">Edit</a>'
          ),
          group = "WAStD Sites"
        )
      } else {
        .
      }
    } %>%
    leaflet::addLayersControl(
      baseGroups = c("Basemap"),
      overlayGroups = og,
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}


# usethis::use_test("map_wamtram")  # nolint
