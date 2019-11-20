# wastdr 0.1.23
## Major changes
* `wastd_GET` drops `response`, keeps `url`, `date`, and `status_code`.
  Results now always expected from WAStD in key `features`, not `results`.

## Minor changes

# wastdr 0.1.22
## Minor changes
* Add `parse_taxon-conservationlisting` and `parse_community-conservationlisting`.

# wastdr 0.1.21
## Major changes
## Minor changes
* Added `parse_area` for WAStD Areas.

# wastdr 0.1.20
## Major changes
## Minor changes
* `map_tracks()`, `map_nests()`, `map_dist()` accept new parameters: `wastd_url`
  (default `get_wastd_url()`), and cluster (whether to cluster markers).
* `parse_surveys()` now includes an HTML link to the admin `change_url` in the
  data curation portal.
* Filters added: 
  * \code{exclude_training_surveys}
  * \code{filter_surveys_requiring_qa}
  * \code{filter_surveys_missing_end}
  * \code{exclude_training_species}
  * \code{filter_missing_survey}
  * \code{filter_missing_site}
* Summaries added: 
  * \code{disturbance_by_season}
  * \code{surveys_per_site_name_and_date}
  * \code{survey_hours_per_site_name_and_date}
  * \code{survey_hours_per_person}
  * \code{list_survey_count}
  * \code{list_survey_effort}
* Plots added:
  * \code{plot_survey_count}
  * \code{plot_survey_effort}
  * \code{ggplot_track_success_by_date}
  * \code{ggplot_track_successrate_by_date}
* Some refactoring of documentation templates.

# wastdr 0.1.19
## Major changes
* All `parse_` functions return `iso_week` and `season_week` instead of `week`.
  `season_week` is a useful grouper in combination with `season`.

# wastdr 0.1.18
## Minor changes
* Added `clutch_size_fresh` to `parse_turtle_nest_encounters` as the number of
  eggs directly observed during a nesting/tagging event as opposed to `clutch_size`,
  which is reconstructed from egg remnants after a hatched nest excavation.

# wastdr 0.1.17
## Minor changes
* Added `datetime_as_season`, `datetime_as_isoweek`, `datetime_as_turtledate`.
  This speeds up the parsers by re-using the costly string-to-date conversion 
  from `datetime`.
* Added `isoweek` to parsers. The parsers now provide for each record:
  
  * timezone-aware datetime (actual time of observation),
  * "turtle date" (nesting night start date),
  * season start year,
  * week number.

# wastdr 0.1.16
## Major changes
* All `parse_` functions changed the column `date` to the more descriptive `turtle_date`, 
  as in the date (ymd) of "the night before". 
  Using `turtle_date` groups turtle tagging (nightfall to sunrise) and tracks
  (made same night but observed the next morning) under the same date.
  This change requires code depending on the column `date` to be updated to `turtle_date`.

## Minor changes
* All `parse_` functions now include `season`, as in the earlier year of the fiscal year. This
  cleanly groups the (Australian) summer nesters (nesting Oct-Mar) under the same season number.
  E.g., any observations made between 01/07/2017 and 30/06/2018 (AWST for the sticklers) will come
  up as season `2017`.
  Note, the season for (Australian) winter nesters can be grouped by the calendar year, which can
  itself be derived trivially from the `datetime` as `dplyr::mutate(year = lubridate::year(datetime))`.
  The same goes for the calendar week, `dplyr::mutate(week = lubridate::isoweek(datetime))`.

# wastdr 0.1.15
## Bug fixes
* `parse_surveys` can now handle surveys without a `source_id`. These surveys
  are e.g. those which were reconstructed by WAStD.

# wastdr 0.1.14
## Minor changes
* Add map_nests to create a map of tagged nests from WAStD "nesttag-observations".

# wastdr 0.1.13
## Minor changes
* Added `map_dist` to map disturbance observations.
* Added `parse_nesttag_observations` for WAStD "nesttag-observations".

# wastdr 0.1.12
## Minor changes
* Survey helpers writing files accept an optional prefix for the filename they
  save the outputs to" `plot_survey_effort`, `plot_survey_count`.
* Survey helpers: placename and prefix are optional.
* Usage of `paste` replaced by `glue`.

# wastdr 0.1.11
## Minor changes
* `parse_surveys` now includes WAStD survey ID and absolute admin URL. The
  latter can be used to construct a direct link to update a survey in WAStD.

# wastdr 0.1.10
## Minor changes
* `map_tracks` popup formatted, including a link to record in WAStD.

# wastdr 0.1.9
## Minor changes
* Change example plot theme from `theme_light()` to `theme_classic()`.

## Bug fixes
* Bugfix: parse_animalencounter and parse_turtlenestencounter now correctly parse survey ID.
  Re-generated example data.

# wastdr 0.1.8
## Minor changes
* Cut down on size of vignette "analysis"

# wastdr 0.1.7
## Bug fixes
* patch release: fix `parse_surveys`: hours/minutes were minutes/seconds.

# wastdr 0.1.6
## Minor changes
* `parse_disturbance_observations` added. 

# wastdr 0.1.5
## Minor changes
* `upsert_geojson` added.

# wastdr 0.1.4
## Minor changes
* AnimalEncounters and TurtleNestEncounters now include survey information.
* Surveys: `parse_survey`, plus some data viz for Surveys, see vignette "Analysis".
* wastd_POST can be used to update users and taxomony in WAStD.
* Changed example dataset names to "tne" and "nests".
* Added `map_tracks`, a map of turtle tracks/nests. WIP: more data viz for tracks.

# wastdr 0.1.3
## Minor changes
* AnimalEncounters: add `maturity`
