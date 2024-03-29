#' Map Marine Wildlife Incident 0.6
#'
#' \lifecycle{maturing}
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle
#' each species separately. The maps auto-zooms to the extent of data given.
#'
#' @param data AnimalEncounters from WAStD.
#' @param sites An sf object of sites with `site_name` and polygon geom, e.g.
#'  `wastdr::wastd_data$sites`.
#' @template param-wastd_url
#' @template param-fmt
#' @template param-tz
#' @template param-cluster
#' @param split_species Whether to split data by species or taxon,
#'   default: TRUE (split by species)
#' @return A leaflet map
#' @export
#' @family wastd
map_mwi <- function(data,
                    sites = NULL,
                    wastd_url = wastdr::get_wastd_url(),
                    fmt = "%Y-%m-%d %H:%M",
                    tz = "Australia/Perth",
                    cluster = FALSE,
                    split_species = FALSE) {
  if ((!is.null(data) && nrow(data) > 1000) || cluster == TRUE) {
    co <- leaflet::markerClusterOptions()
  } else {
    co <- NULL
  }

  overlay_names <- c()
  url <- sub("/$", "", wastd_url)

  l <- leaflet_basemap()

  if (!is.null(data) && nrow(data) > 0) {
    split_col <- ifelse(split_species == TRUE, "species", "taxon")
    data.df <- data %>% split(data[split_col])

    dom <- dplyr::pull(data, split_col)
    pal_mwi <- leaflet::colorFactor(palette = "viridis", domain = dom)

    overlay_names <- names(data.df)
    if (!is.null(sites)) overlay_names <- c("Sites", overlay_names)

    names(data.df) %>%
      purrr::walk(function(df) {
        l <<- l %>% leaflet::addAwesomeMarkers(
          data = data.df[[df]],
          lng = ~longitude,
          lat = ~latitude,
          icon = leaflet::makeAwesomeIcon(
            icon = "remove",
            markerColor = "red",
            iconColor = "white"
          ),
          label = ~ glue::glue("
             {format(datetime, fmt)}
             {humanize(health)}
             {humanize(maturity)}
             {humanize(sex)}
             {humanize(species)}
          "),
          popup = ~ glue::glue('
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
        '),
          group = df,
          clusterOptions = co
        )
      })
  }

  l %>%
    {
      if (!is.null(sites)) {
        leaflet::addPolygons(
          .,
          data = sites,
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
    ) %>%
    leaflet.extras::addBootstrapDependency()
}

# usethis::use_test("map_mwi")
