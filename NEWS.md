# wastdr 0.8.18
* add_dates: add new field `turtle_date_awst_text`
* summarise wastd turtledata: summarise by turtle date, not calendar date

# wastdr 0.8.17

# wastdr 0.8.16

# wastdr 0.8.15

# wastdr 0.8.14

# wastdr 0.8.13

# wastdr 0.8.12

# wastdr 0.8.11

# wastdr 0.8.9

# wastdr 0.8.8

# wastdr 0.8.7
## Major fixes
## Minor fixes
* Add scalebar to all maps
## Docs
## Data
## Maintenance

# wastdr 0.8.2
## Major fixes
## Minor fixes
* `filter_odkc_turtledata` now accepts a `username`, which filters data by the 
  ODK Collect Username of each submission. Some components, such as tagging data,
  have hand typed names in additional fields. These are also filtered by.
## Docs
## Data
## Maintenance

# wastdr 0.7.3
## Major fixes
## Minor fixes
* `download_w2_data` improved to exclude duplicate attributes, added print fn.
## Docs
## Data
## Maintenance

# wastdr 0.7.1
## Major fixes
* New: `duplicate_surveys` links to sites and dates with more than one survey.
* Plots from summarize surveys now save to a given `local_dir` only on 
  `export=TRUE` like plots from summarize tracks.
## Minor fixes
## Docs
## Data
## Maintenance
* Dependency versions updated

# wastdr 0.7.0
## Major fixes
## Minor fixes
* `download_odkc_turtledata2020()` now includes Turtle Tagging data (4 tables),
  `download_odkc_turtledata2019()` contains NULL as placeholder in these four 
  tables, and will be sunset after season 2020-21.
## Docs
## Data
* `odkc_data` contains Turtle Tagging data.

# wastdr 0.6.1
## Major fixes
## Minor fixes
* New summary for `wastd_data`: `summarise_wastd_data_per_day_site()`
## Docs
## Data

# wastdr 0.6.0
## Major fixes
* WAStD API changes:
  * Observation serializers now include the most detailed feasible `Encounter`
    class. Those Observations which only ever are recorded against 
    `AnimalEncounter`, `TurtleNestEncounter`, or `LineTransectEncounter`, will
    show now their details in the `encounter` group. This simply adds more 
    fields.
    * `parse_encounterobservations()` now includes these details. 
    * Mapping and summary helpers use the changed names (prefixed encounter_).
    * `download_wastd_turtledata()` now doesn't have to merge AE/TNE/LTE details
      against Observation tables.
    * Some observations, namely `TurtleTagObservation` and 
      `TurtleNestDisturbanceObservation`, could also happen when not associated
      with an animal or turtle nest, and therefore only include the `Encounter`
      details in the WAStD API.
* `TurtleNestObservation.nest_position` has been replaced and merged with the 
  already existing `TurtleNestEncounter.habitat` in WAStD.
  This simplifies the contents of the WAStD table `TurtleNestObservation`, which
  is aptly named `turtle-nest-excavation` in the API to include only excavation
  data (egg counts, HS/ES, nest depth, ambient temperatures). 
  "Nest habitat-only" records have been deleted from `TurtleNestObservation`.
  The calculation of HS and ES is also rectified to now exclude a false `0` for 
  "Nest habitat-only" records (which are deleted and not coming back anyways).
    
## Minor fixes
## Docs
## Data

# wastdr 0.5.7
## Major fixes
## Minor fixes
* Join essential Encounter details to nested tables in 
  `download_wastd_turtledata()`. This should restore behaviour of analysis 
  functions to 0.5.5.
## Docs
## Data`download_wastd_turtledata()`
* Rebuild `wastd_data`.

# wastdr 0.5.6
## Major fixes
* Bugfix: `download_wastd_turtledata()` now shows correct encounter details for 
  nested observations like nest tags, nest loggers etc.
## Minor fixes
* `download_wastd_turtledata()` infers verbosity from `get_wastdr_verbose()`.
## Docs
## Data

# wastdr 0.5.5
## Major fixes
* Updated turtle tagging database extractor `download_w2_data()`. (#29)
## Minor fixes
* `wastdr_msg_*` has new parameter `verbose = get_wastdr_verbose()` because we
  always want to make message verbosity conditional.
## Docs
## Data

# wastdr 0.5.4
## Major fixes
* Improved parsing of WAStD data
## Minor fixes
## Docs
## Data

# wastdr 0.5.3
## Major fixes
## Minor fixes
## Docs
## Data
* `export_wastd_turtledata` now also exports all data to an RData file.

# wastdr 0.5.2
## Data
* WAStD API changes: Surveys now contain in addition to the surveyed `site` also 
  the Locality (`area`), e.g. "Ningaloo". 
  This allows filtering to whole monitoring programs.
* WAStD API changes: Users now include `is_active` to indicate whether they are
  a closed duplicate profile or an active one. This is useful to exclude
  duplicate profiles from user name mapping (e.g. in `etlTurtleNesting`).

## Docs
* All functions are now shown in Reference sorted by function family.
* Reference docs now support Markdown. Bullet point lists are easier to write 
  now.


# wastdr 0.5.1
## Data
* `odkc_data` is not generated from `wastdr::download_odkc_turtledata2020()`.
  The first 100 records of each element are retained and sanitised of PII 
  (names).
* `download_wastd_turtledata()` was extended to include LoggerObservations 
  as `nest_loggers` in addition to the superseded LoggerEncounters.
  This prepares etlTurtleNesting to migrate the reports from using LoggerEnc to 
  LoggerObs.

# wastdr 0.5.0
Status Oct 2020
## Minor fixes
* `download_odkc_turtledata_2020` now includes Site Visit Start (Map)

## Documentation
All ODK forms used to capture data for WAStD are included in `inst/` as 
ODK Build savefiles, XForm XML (form ID changed to drop `build_` prefix and
version postfix to allow updating deployed forms on ODK Central 1.0), and 
XlsForm XLSX.

# wastdr 0.4.0
## Major changes
* The WA Sea Turtles DB (WAStD) has been separated from the Threatened Species and 
  Communities DB (TSC). This version begins the migration of TSC functionality
  to a dedicated R package (tscr).
* TSC can be used with this version of wastdr.
* Renaming and rebranding will be ongoing.

# wastdr 0.3.2
* Bugfix: `download_wastd_turtledata` called `parse_encounterobservations`
  which called `add_dates` incorrectly. Dates are now preserved and value-added
  with season, calendar and turtle date and local datetime.

# wastdr 0.3.0
* Add `download_w2_data` to extract and parse WAMTRAM2. Early stages with 
  improvements planned.

# wastdr 0.2.19
* Upgrade map_tracks_odkc and map_mwi_odkc to Bootstrap4 image carousels to 
  work in the Shiny app turtleviewer.

# wastdr 0.2.18
* Adapted wastdr to new WAStD API (#3)
  * include example data, 
  * use example data in code examples,
  * use example data in tests,
  * use example data in vignettes,
  * automate example data refresh from WAStD,
  * update docs, man, vignettes,
  * propagate updates to turtleviewer.
* Increased test coverage to near 100% (#3)
* Set up CI on GitHub Actions for Windows and Ubuntu - TODO MacOS (#3)
* Improve WAStD summarize_* methods (#5).
* Improve map popups for ODKC tracks and mwi (#6).

# wastdr 0.2.11
* Start work on ODKC to WAStD data ingest via `ruODK`, `odkc_data`, 
  `wastd_post_one` and `wastd_bulk_post`. The hard bits are:
  
  * Data mapping ODKC to WAStD.
  * Guess users (re-implement PostGIS's trigram fuzzy search).
  * Determine create / update / skip based on source/sourceID already present 
    in WAStD.

# wastdr 0.2.8
* Test coverage 99.9%
* `filter_dead()` and `filter_alive()` work for WAStD and ODKC data, see 
  examples.

# wastdr 0.2.6
* Test coverage increased.
* Test data included (WAStD, TSC, ODKC) and used in tests and examples.

# wastdr 0.2.0
* Refactor `wastd_GET` and `wastd_POST`, add examples to man, tests, vignettes.

# wastdr 0.1.33
* Add opt-in timelines to maps.

# wastdr 0.1.31
* Refactor maps: humanize layer names (tracks: species, dist: causes), make
  map_mwi robust against null records.

# wastdr 0.1.29
## Minor changes
* Add `map_sv_odkc` to map Site Visit Start/End over TSC Sites. 
  Extremely helpful to QA TSC sites and survey methodology.

# wastdr 0.1.28
## Minor changes
* Add disturbed nests and sites, both optional, to `map_dist`.

# wastdr 0.1.27
## Major changes
* Add ODK Central data wrangling.
* Bump to `R>=3.5`.

## Minor changes

# wastdr 0.1.23
## Major changes
* `wastd_GET` drops `response`, keeps `url`, `date`, and `status_code`.
  Results now always expected from WAStD in key `features`, not `results`.
* Turtle parsing functions add now additional calendar date in AWST for clarity.
* Generic `wastd_parse` function parses any non-GeoJSON TSC API response, while
  `wastd_parse_gj` will parse a

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
