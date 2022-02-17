#' Map WAMTRAM data
#'
#' @param data The output of `wastdr::download_w2_data()`.
#' @param location A W2 location code, e.g. "TH", to filter the data by.
#' @param place A W2 place code, e.g. "THEE", to filter the data by. Providing
#'   `place` overrides `location`.
#' @param l_width The parameter `width` for `leaflet::leaflet()`.
#' @param l_height The parameter `height` for `leaflet::leaflet()`.
#' @return A leaflet map showing W2 sites and encounters.
#' @export
#' @examples \dontrun{
#' data("w2_data", package="etlTurtleNesting")
#' w2_data <- readRDS("~/projects/etlTurtleNesting/inst/w2.rds")
#' map_wamtram(w2_data)
#'
#' map_wamtram(w2_data, location="DH")
#' map_wamtram(w2_data, place="DHTB")
#'
#' map_wamtram(w2_data, place="WKBB", l_height="calc(100vh - 80px)")
#' }
map_wamtram <- function(data, location=NULL, place=NULL, obs_id=NULL,
                        l_width=NULL, l_height=NULL){

    if (class(data) != "wamtram_data") {
        glue::glue(
            "The first argument needs to be an object of class ",
            "\"wamtram_data\", e.g. the output of wastdr::download_w2_data."
        ) %>% wastdr_msg_abort()
    }

    enc <- data$enc
    sites <- data$sites

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

    co <- NULL
    co <- if(nrow(enc) > 1000) co <- leaflet::markerClusterOptions()

    leaflet::leaflet(width=l_width, height=l_height) %>%
        leaflet::addProviderTiles("Esri.WorldImagery", group = "Basemap") %>%
        leaflet::addProviderTiles(
            "OpenStreetMap.Mapnik",
            group = "Basemap",
            options = leaflet::providerTileOptions(opacity = 0.35)
        ) %>%
        leaflet.extras::addFullscreenControl(pseudoFullscreen = TRUE) %>%
        leaflet::clearBounds() %>%
        leaflet::addAwesomeMarkers(
            data = sites,
            lng = ~ site_longitude,
            lat = ~ site_latitude,
            icon = leaflet::makeAwesomeIcon(markerColor = "green", iconColor = "white"),
            label = ~ glue::glue("[{prefix} {code}] {label}"),
            popup = ~ glue::glue('
                <h3>{label}</h3>
                <i class="fa fa-solid fa-map-location-dot"></i> {prefix} {code}<br/>
                <i class="fa fa-solid fa-location-dot"></i> {round(site_latitude, 5)} {round(site_longitude, 5)}<br/>
                <i class="fa fa-solid fa-comment"></i> {description}
            '),
            group = "WAMTRAM sites"
        ) %>%
        leaflet::addAwesomeMarkers(
            data = enc,
            lng = ~ longitude,
            lat = ~ latitude,
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
            <h3>{species_code} {observation_status}</h3>
            <i class="fa fa-solid fa-calendar"></i> {observation_datetime_gmt08}<br/>
            <i class="fa fa-solid fa-eye"></i> <strong>Turtle ID</strong> 65845 <strong>ObsID</strong> 288417<br/>
            <i class="fa fa-solid fa-map-location-dot"></i><strong> {location_code} {place_code}</strong><br/>
            <i class="fa fa-solid fa-location-dot"></i> <strong>Chosen</strong> {latitude}  {longitude}<br/>
            <i class="fa fa-solid fa-location-dot"></i> <strong>Supplied DD</strong> {latitude_dd}  {longitude_dd}<br/>
            <i class="fa fa-solid fa-location-dot"></i> <strong>Supplied DMS</strong> {latitude_from_dms}  {longitude_from_dms}<br/>
            <i class="fa fa-solid fa-location-dot"></i> <strong>Supplied EN</strong> {northing} {easting} {zone} {datum_code}<br/>
                '),
            group = "WAMTRAM turtles",
            clusterOptions = co
        ) %>%
        leaflet::addLayersControl(
            baseGroups = c("Basemap"),
            overlayGroups = c("WAMTRAM sites", "WAMTRAM turtles"),
            options = leaflet::layersControlOptions(collapsed = FALSE)
        )
}


# usethis::use_test("map_wamtram")  # nolint