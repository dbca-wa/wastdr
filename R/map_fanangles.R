#' Map turtle hatchling emergence orientation from wastd_data
#'
#' @template param-wastd-data
#' @template param-wastd_url
#' @template param-fmt
#' @importFrom leaflet.circlesector addCircleSectorMid addCircleSectorMinMax
#' @export
#' @family wastd
#' @return A Leaflet map
#' @examples
#' \dontrun{
#' data(wastd_data)
#' wastd_data %>%
#'   filter_wastd_turtledata(area_name = "Port Hedland") %>%
#'   map_fanangles()
#' }
map_fanangles <- function(x,
                          fmt = "%Y-%m-%d %H:%M",
                          wastd_url = wastdr::get_wastd_url()) {
  # Data gatechecks -----------------------------------------------------------#
  verify_wastd_data(x)

  # Map options ---------------------------------------------------------------#
  # co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL
  overlay_names <- c()
  url <- sub("/$", "", wastd_url)

  # Prep data -----------------------------------------------------------------#
  fans <- x$nest_fans %>%
    wastdr::filter_realspecies() %>%
    dplyr::filter(
      !is.na(bearing_leftmost_track_degrees),
      !is.na(bearing_rightmost_track_degrees)
    )

  fans_w <- fans %>% dplyr::filter(!is.na(bearing_to_water_degrees))

  outliers <- x$nest_fan_outliers %>% wastdr::filter_realspecies()

  lights <- x$nest_lightsources %>%
    wastdr::filter_realspecies() %>%
    dplyr::filter(!is.na(bearing_light_degrees))

  lights_a <- lights %>% dplyr::filter(light_source_type == "artificial")

  lights_n <- lights %>% dplyr::filter(light_source_type == "natural")

  # Labels and popups ---------------------------------------------------------#
  label_fans_tracks <- "<strong>{format(datetime, fmt)}</strong> {no_tracks_main_group} tracks"
  label_fans_mean <- "<strong>{format(datetime, fmt)}</strong> Mean bearing: {bearing_mean}&deg;"
  label_fans_water <- "<strong>{format(datetime, fmt)}</strong> Bearing to water: {bearing}&deg;"
  label_fans_mis <- "<strong>{format(datetime, fmt)}</strong> Misorientation: {absolute_angle(bearing_mis_from, bearing_mis_to)}&deg;"
  label_out <- "<strong>{format(datetime, fmt)}</strong> {outlier_group_size} track(s) {bearing}&deg; {outlier_track_comment}"
  label_light <- "<strong>{format(datetime, fmt)}</strong> {light_source_description}"

  popup_fans_tracks <- '
<h2>{no_tracks_main_group} <em>{sentencecase(encounter_species)}</em> tracks</h2>
<h3>{format(datetime, fmt)} AWST</h3>
Estimate: {no_tracks_main_group_min}-{no_tracks_main_group_max} tracks<br/>
Path to sea: {sentencecase(stringr::str_replace_all(path_to_sea_comments, "None", ""))}<br/>
Emergence time: {hatchling_emergence_time} ({hatchling_emergence_time_accuracy})<br/>
Light sources: {light_sources_present}<br/>
Clouds: {cloud_cover_at_emergence}/8<br/>

<div>
<a class="btn btn-xs btn-default" target="_" rel="nofollow"
href="{url}/observations/turtle-nest-encounters/{encounter_id}">
View in WAStD</a>

<a class="btn btn-xs btn-default" target="_" rel="nofollow"
href="{url}{encounter_absolute_admin_url}">
Edit in WAStD</a>
</div>
'
  popup_fans_mean <- "
<h2>Mean bearing: {bearing}&deg;</h2>
<h3>{format(datetime, fmt)} AWST</h3>
Tracks from: {bearing_leftmost_track_degrees}&deg;<br/>
Tracks to: {bearing_rightmost_track_degrees}&deg;<br/>
"
  popup_fans_water <- "
<h2>Bearing to water: {bearing}&deg;</h2>
<h3>{format(datetime, fmt)} AWST</h3>
"
  popup_fans_mis <- "
<h2>Misorientation: {absolute_angle(bearing_mis_from, bearing_mis_to)}&deg;</h2>
<h3>{format(datetime, fmt)} AWST</h3>
Tracks from: {bearing_leftmost_track_degrees}&deg;<br/>
Tracks to: {bearing_rightmost_track_degrees}&deg;<br/>
Tracks mean bearing: {bearing_mean}&deg;<br/>
Direction to water: {bearing_to_water_degrees}&deg;<br/>
Misorientation is the angle between mean bearing and direction to water.
"
  popup_out <- "
<h2>{outlier_group_size} outlier track(s)</h2>
<h3>{format(datetime, fmt)} AWST</h3>
Bearing: {bearing}&deg;<br/>
{outlier_track_comment}
"
  popup_light <- "
<h2>{light_source_description}</h2>
<h3>{format(datetime, fmt)} AWST</h3>
Type: {light_source_type}<br/>
Bearing: {bearing}&deg;
"

  # Prepare data --------------------------------------------------------------#
  # Target data objects
  lights_art <- NULL
  lights_nat <- NULL
  fans_out <- NULL
  fans_mean <- NULL
  fans_tracks <- NULL
  fans_mis <- NULL
  fans_water <- NULL

  if (nrow(fans) > 0) {
    # Main track fans
    fans_tracks <- fans %>%
      dplyr::transmute(
        lat = encounter_latitude,
        lon = encounter_longitude,
        start_angle = bearing_leftmost_track_degrees,
        end_angle = bearing_rightmost_track_degrees,
        radius = 10,
        weight = 2,
        colour = "blue",
        label = glue::glue(label_fans_tracks),
        popup = glue::glue(popup_fans_tracks)
      )

    # The mean direction of the fan
    fans_mean <- fans %>%
      dplyr::transmute(
        lat = encounter_latitude,
        lon = encounter_longitude,
        bearing = bearing_mean,
        angle = 1,
        radius = 15,
        weight = 1,
        colour = "blue",
        label = glue::glue(label_fans_mean),
        popup = glue::glue(popup_fans_mean)
      )

    # The main direction to water
    fans_water <- fans_w %>%
      dplyr::transmute(
        lat = encounter_latitude,
        lon = encounter_longitude,
        bearing = bearing_to_water_degrees,
        angle = 1,
        radius = 15,
        weight = 1,
        colour = "black",
        label = glue::glue(label_fans_water),
        popup = glue::glue(popup_fans_water)
      )

    # The misorientation of the fan is a sector(mean_bearing, bearing_to_water)
    fans_mis <- fans_w %>%
      dplyr::transmute(
        lat = encounter_latitude,
        lon = encounter_longitude,
        start_angle = bearing_mis_from,
        end_angle = bearing_mis_to,
        radius = 15,
        weight = 1,
        colour = "purple",
        label = glue::glue(label_fans_mis),
        popup = glue::glue(popup_fans_mis)
      )
  }

  if (nrow(outliers) > 0) {
    # Outlier tracks
    fans_out <- outliers %>%
      dplyr::filter(
        !is.na(bearing_outlier_track_degrees)
      ) %>%
      dplyr::transmute(
        lat = encounter_latitude,
        lon = encounter_longitude,
        bearing = bearing_outlier_track_degrees,
        angle = 2,
        radius = 10,
        weight = 1,
        colour = "red",
        label = glue::glue(label_out),
        popup = glue::glue(popup_out)
      )
  }

  if (nrow(lights_a) > 0) {
    # Known light sources
    lights_art <- lights_a %>%
      dplyr::transmute(
        lat = encounter_latitude,
        lon = encounter_longitude,
        bearing = bearing_light_degrees,
        angle = 1,
        radius = 100,
        weight = 2,
        colour = "#FFC300",
        label = glue::glue(label_light),
        popup = glue::glue(popup_light)
      )
  }

  if (nrow(lights_n) > 0) {
    lights_nat <- lights_n %>%
      dplyr::transmute(
        lat = encounter_latitude,
        lon = encounter_longitude,
        bearing = bearing_light_degrees,
        angle = 1,
        radius = 100,
        weight = 2,
        colour = "#f0ebc2",
        label = glue::glue(label_light),
        popup = glue::glue(popup_light)
      )
  }

  # Map -----------------------------------------------------------------------#
  l <- leaflet_basemap(l_height = 500, l_width = 700) %>%
    # clearBounds releases setView from leaflet_basemap
    # so that addCircleSectorMid/MinMax can expandLimits
    leaflet::clearBounds()

  # Draw layers in this sequence for best presentation
  if (!is.null(fans_tracks)) {
    l <- l %>%
      leaflet::addCircles(
        data = fans_tracks,
        lat = ~lat,
        lng = ~lon,
        color = "white",
        weight = 2,
        radius = 5
      )
  }

  if (!is.null(lights_art)) {
    l <- l %>% addCircleSectorMid(data = lights_art)
  }
  if (!is.null(lights_nat)) {
    l <- l %>% addCircleSectorMid(data = lights_nat)
  }
  if (!is.null(fans_out)) {
    l <- l %>% addCircleSectorMid(data = fans_out)
  }
  if (!is.null(fans_mean)) {
    l <- l %>% addCircleSectorMid(data = fans_mean)
  }
  if (!is.null(fans_tracks)) {
    l <- l %>% addCircleSectorMinMax(data = fans_tracks)
  }
  if (!is.null(fans_mis)) {
    l <- l %>% addCircleSectorMinMax(data = fans_mis)
  }
  if (!is.null(fans_water)) {
    l <- l %>% addCircleSectorMid(data = fans_water)
  }

  l
}

# use_test("map_fanangles")  # nolint
