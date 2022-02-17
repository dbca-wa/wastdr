#' Map Marine Wildlife Incident 0.6
#'
#' \lifecycle{maturing}
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle
#' each species separately. The maps auto-zooms to the extent of data given.
#'
#' @template param-wastd-data
#' @param map_animals Whether to map animals (AnimalEncounters), default: TRUE
#' @param map_tracks Whether to map tracks (TurtleNestEncounters), default: TRUE
#' @param map_dist Whether to map nest and general disturbances
#'   (Encounters with TurtleNestDisturbanceObservation), default: TRUE
#' @param map_sites Whether to map Sites, default: TRUE
#' @template param-wastd_url
#' @template param-fmt
#' @template param-tz
#' @template param-cluster
#' @return A leaflet map
#' @export
#' @family wastd
#' @examples
#' data(wastd_data)
#' map_wastd(wastd_data)
map_wastd <- function(x,
                      map_animals = TRUE,
                      map_tracks = TRUE,
                      map_dist = TRUE,
                      map_sites = TRUE,
                      wastd_url = wastdr::get_wastd_url(),
                      fmt = "%Y-%m-%d %H:%M",
                      tz = "Australia/Perth",
                      cluster = FALSE) {
  # Data gatechecks ---------------------------------------------------------#
  if (class(x) != "wastd_data") {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"wastd_data\", ",
        "e.g. the output of wastdr::download_wastd_turtledata."
      )
    )
  }

  animals <- x$animals %>% filter_realspecies()
  animals_alive <- x$animals %>%
    filter_realspecies() %>%
    filter_alive()
  animals_dead <- x$animals %>%
    filter_realspecies() %>%
    filter_dead()
  tracks <- x$tracks %>% filter_realspecies()

  if (is.null(animals) || nrow(animals) == 0) {
    if (map_animals == TRUE) {
      wastdr_msg_info("AnimalEncounters requested but none found")
    }
    map_animals <- FALSE
  }

  if (is.null(tracks) || nrow(tracks) == 0) {
    if (map_tracks == TRUE) {
      wastdr_msg_info("TurtleNestEncounters requested but none found")
    }
    map_tracks <- FALSE
  }

  if (is.null(x$nest_dist) || nrow(x$nest_dist) == 0) {
    if (map_dist == TRUE) {
      wastdr_msg_info("TurtleNestDisturbances requested but none found")
    }
    map_dist <- FALSE
  }

  if (is.null(x$sites) || nrow(x$sites) == 0) {
    if (map_sites == TRUE) {
      wastdr_msg_info("Sites requested but none found")
    }
    map_sites <- FALSE
  }

  # Map options -------------------------------------------------------------#
  co <-
    if (cluster == TRUE) {
      leaflet::markerClusterOptions()
    } else {
      NULL
    }
  overlay_names <- c()
  url <- sub("/$", "", wastd_url)

  animal_popup_template <- '
<h3>{humanize(health)} {humanize(maturity)}
{humanize(sex)} {humanize(species)}</h3>

<span class="glyphicon glyphicon-globe" aria-hidden="true"></span>
{area_name} - {site_name}</br>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{format(datetime, fmt)} AWST<br/>
<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
{observer_name}<br/>
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
{reporter_name}<br/>

<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
Cause of death: {humanize(cause_of_death)}<br/>
<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
Activity: {humanize(activity)}<br/>

<p><a class="btn btn-xs btn-secondary" target="_" rel="nofollow"
href="{url}{absolute_admin_url}">Edit on WAStD</a></p>'

  animal_label_template <- "
{lubridate::with_tz(datetime, tz)}
{humanize(health)}
{humanize(maturity)}
{humanize(sex)}
{humanize(species)}"

  tracks_label_template <- "
{lubridate::with_tz(datetime, tz)} {humanize(nest_age)}
{humanize(species)} {humanize(nest_type)} {name}"

  tracks_popup_template <- '
<h3>{humanize(nest_age)} {humanize(species)}
{humanize(nest_type)} {name}</h3>

<span class="glyphicon glyphicon-globe" aria-hidden="true"></span>
{area_name} - {site_name}</br>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{lubridate::with_tz(datetime, tz)}<br/>
<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
{observer_name}<br/>
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
{reporter_name}<br/>

<p>Survey {survey_id} at {site_name}
{format(httpdate_as_gmt08(survey_start_time), fmt)}-
{format(httpdate_as_gmt08(survey_end_time), fmt)} AWST</p>

<p><a class="btn btn-xs btn-secondary" target="_" rel="nofollow"
href="{url}{absolute_admin_url}">Edit on WAStD</a></p>'

  dist_label_template <- "
{lubridate::with_tz(datetime, tz)} {humanize(disturbance_cause)}"

  dist_popup_template <- '
<h3>Signs of {humanize(disturbance_cause)}
({humanize(encounter_encounter_type)})</h3>

<span class="glyphicon glyphicon-globe" aria-hidden="true"></span>
{encounter_area_name} - {encounter_site_name}</br>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{lubridate::with_tz(datetime, tz)} AWST</br>

<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
{encounter_observer_name}<br/>
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
{encounter_reporter_name}<br/>

<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
{encounter_comments}<br/>

<p>Survey {encounter_survey_id} at {encounter_site_name}<br/>
{encounter_survey_start_time}-{encounter_survey_end_time}</p>
<a href="{url}{encounter_survey_absolute_admin_url}"
class="btn btn-xs btn-secondary" target="_" rel="nofollow">
Edit survey in WAStD</a>

<p><a class="btn btn-xs btn-secondary" target="_" rel="nofollow"
href="{url}{absolute_admin_url}">
Edit record in WAStD</a></p>'

  # Base map ----------------------------------------------------------------#
  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Basemap") %>%
    leaflet::addProviderTiles(
      "OpenStreetMap.Mapnik",
      group = "Basemap",
      options = leaflet::providerTileOptions(opacity = 0.35)
    ) %>%
    leaflet.extras::addFullscreenControl(pseudoFullscreen = TRUE) %>%
    leaflet::clearBounds()

  # AnimalEncounters --------------------------------------------------------#
  if (map_animals == TRUE) {
    overlay_names <- c(
      overlay_names,
      "Live sightings (tags, rescue)",
      "Mortalities (strandings)"
    )

    l <- l %>%
      leaflet::addAwesomeMarkers(
        data = animals_alive,
        lng = ~longitude,
        lat = ~latitude,
        icon = leaflet::makeAwesomeIcon(
          markerColor = "green",
          iconColor = "white"
        ),
        label = ~ glue::glue(animal_label_template),
        popup = ~ glue::glue(animal_popup_template),
        group = "Live sightings (tags, rescue)",
        clusterOptions = co
      ) %>%
      leaflet::addAwesomeMarkers(
        data = animals_dead,
        lng = ~longitude,
        lat = ~latitude,
        icon = leaflet::makeAwesomeIcon(
          markerColor = "red",
          iconColor = "white"
        ),
        label = ~ glue::glue(animal_label_template),
        popup = ~ glue::glue(animal_popup_template),
        group = "Mortalities (strandings)",
        clusterOptions = co
      )
  }

  # Tracks ------------------------------------------------------------------#
  if (map_tracks == TRUE) {
    overlay_names <- c(overlay_names, "Tracks and Nests")
    l <- l %>%
      leaflet::addAwesomeMarkers(
        data = tracks,
        lng = ~longitude,
        lat = ~latitude,
        icon = leaflet::makeAwesomeIcon(
          markerColor = "blue",
          iconColor = "white"
        ),
        label = ~ glue::glue(tracks_label_template),
        popup = ~ glue::glue(tracks_popup_template),
        group = "Tracks and Nests",
        clusterOptions = co
      )
  }

  # Dist --------------------------------------------------------------------#
  if (map_dist == TRUE) {
    overlay_names <- c(overlay_names, "Disturbances")
    l <- l %>%
      leaflet::addAwesomeMarkers(
        data = x$nest_dist,
        lng = ~encounter_longitude,
        lat = ~encounter_latitude,
        icon = leaflet::makeAwesomeIcon(
          markerColor = "orange",
          iconColor = "white"
        ),
        label = ~ glue::glue(dist_label_template),
        popup = ~ glue::glue(dist_popup_template),
        group = "Disturbances",
        clusterOptions = co
      )
  }

  # Sites -------------------------------------------------------------------#
  l %>%
    {
      if (map_sites == TRUE) {
        overlay_names <- c(overlay_names, "Sites")
        leaflet::addPolygons(
          .,
          data = x$sites,
          group = "Sites",
          weight = 1,
          fillOpacity = 0.5,
          fillColor = "blue",
          label = ~site_name
        )
      } else {
        .
      }
    } %>%
    leaflet::addLayersControl(
      baseGroups = c("Basemap"),
      overlayGroups = overlay_names,
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}

# usethis::use_test("map_wastd")
