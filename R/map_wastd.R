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
  verify_wastd_data(x)

  animals <- x$animals %>% filter_realspecies()
  suppressWarnings(
    animals_alive <- x$animals %>%
      filter_realspecies() %>%
      filter_alive()
  )
  suppressWarnings(
    animals_dead <- x$animals %>%
      filter_realspecies() %>%
      filter_dead()
  )

  map_animals_alive <- map_animals
  map_animals_dead <- map_animals

  if (is.null(animals_alive) || nrow(animals_alive) == 0) {
    if (map_animals == TRUE) {
      wastdr_msg_info("AnimalEncounters (alive) requested but none found")
    }
    map_animals_alive <- FALSE
  }

  if (is.null(animals_dead) || nrow(animals_dead) == 0) {
    if (map_animals == TRUE) {
      wastdr_msg_info("AnimalEncounters (dead) requested but none found")
    }
    map_animals_dead <- FALSE
  }

  tracks <- x$tracks %>% filter_realspecies()
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
  co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL
  overlay_names <- c()
  url <- sub("/$", "", wastd_url)

  animal_popup_template <- '
<h4>
{humanize(health)} {humanize(maturity)} {humanize(sex)} {humanize(species)}
</h4>

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

<a href="{url}/observations/surveys/{survey_id}"
class="btn btn-xs btn-default"
target="_" rel="nofollow" title="View Survey in WAStD">
<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
Survey {survey_id}</a>
{format(httpdate_as_gmt08(survey_start_time), fmt)} -
{format(httpdate_as_gmt08(survey_end_time), fmt)}
<br/>

<div>
<a class="btn btn-xs btn-default" target="_" rel="nofollow"
href="{url}/observations/animal-encounters/{id}">
<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
View in WAStD</a>

<a class="btn btn-xs btn-default" target="_" rel="nofollow"
href="{url}{absolute_admin_url}">
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
Edit in WAStD</a>
</div>
'

  animal_label_template <- "
{format(datetime, fmt)}
{humanize(health)}
{humanize(maturity)}
{humanize(sex)}
{humanize(species)}"

  tracks_label_template <- "
{format(datetime, fmt)} {humanize(nest_age)}
{sentencecase(species)} {humanize(nest_type)} {name}"

  tracks_popup_template <- '
<h4>{humanize(nest_age)} {sentencecase(species)} {humanize(nest_type)} {name}</h4>

<span class="glyphicon glyphicon-globe" aria-hidden="true"></span>
{area_name} - {site_name}</br>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{format(datetime, fmt)}<br/>
<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
{observer_name}<br/>
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
{reporter_name}<br/>

<a href="{url}/observations/surveys/{survey_id}"
class="btn btn-xs btn-default"
target="_" rel="nofollow" title="View Survey in WAStD">
<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
Survey {survey_id}</a>
{format(httpdate_as_gmt08(survey_start_time), fmt)} -
{format(httpdate_as_gmt08(survey_end_time), fmt)}
<br/>

<div>
<a class="btn btn-xs btn-default" target="_" rel="nofollow"
href="{url}/observations/turtle-nest-encounters/{id}">
<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
View in WAStD</a>

<a class="btn btn-xs btn-default" target="_" rel="nofollow"
href="{url}{absolute_admin_url}">
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
Edit in WAStD</a>
</div>
 '

  dist_label_template <- "
{format(datetime, fmt)} {humanize(disturbance_cause)}"

  dist_popup_template <- '
<h4>Signs of {humanize(disturbance_cause)} ({humanize(encounter_encounter_type)})
</h4>

<span class="glyphicon glyphicon-globe" aria-hidden="true"></span>
{encounter_area_name} - {encounter_site_name}<br/>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{format(datetime, fmt)} AWST<br/>

<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
{encounter_observer_name}<br/>
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
{encounter_reporter_name}<br/>

<a href="{url}/observations/surveys/{encounter_survey_id}"
class="btn btn-xs btn-default"
target="_" rel="nofollow" title="View Survey in WAStD">
<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
Survey {encounter_survey_id}</a>
{format(httpdate_as_gmt08(encounter_survey_start_time), fmt)} -
{format(httpdate_as_gmt08(encounter_survey_end_time), fmt)}
<br/>

<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
{encounter_comments}<br/>

<div>
<a class="btn btn-xs btn-default" target="_" rel="nofollow"
href="{url}/observations/encounters/{encounter_id}">
<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
View in WAStD</a>

<a class="btn btn-xs btn-default" target="_" rel="nofollow"
href="{url}{absolute_admin_url}">
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
Edit in WAStD</a>
</div>
'

  # Base map ----------------------------------------------------------------#
  l <- leaflet_basemap()

  # AnimalEncounters --------------------------------------------------------#
  if (map_animals_alive == TRUE) {
    overlay_names <- c(overlay_names, "Live sightings (tags, rescue)")

    l <- l %>%
      leaflet::addAwesomeMarkers(
        data = animals_alive,
        lng = ~longitude,
        lat = ~latitude,
        icon = leaflet::makeAwesomeIcon(
          markerColor = "green",
          iconColor = "white",
          icon = "tag"
        ),
        label = ~ glue::glue(animal_label_template),
        popup = ~ glue::glue(animal_popup_template),
        group = "Live sightings (tags, rescue)",
        clusterOptions = co
      )
  }

  if (map_animals_dead == TRUE) {
    overlay_names <- c(overlay_names, "Mortalities (strandings)")

    l <- l %>%
      leaflet::addAwesomeMarkers(
        data = animals_dead,
        lng = ~longitude,
        lat = ~latitude,
        icon = leaflet::makeAwesomeIcon(
          markerColor = "red",
          iconColor = "white",
          icon = "remove"
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
          iconColor = "white",
          icon = "ok-sign"
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
          iconColor = "white",
          icon = "alert"
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
