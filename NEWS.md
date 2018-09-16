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
