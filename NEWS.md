# `wastdr` release notes

## Check notes
* Package size is pushing 10 Mb - will split out example data once 
  package matures and release frequency slows down.
* Non-standard file/directory found at top level: man-roxygen is required for documentation templates.

## 1.0.4
* AnimalEncounters and TurtleNestEncounters now include survey information.
* Surveys: `parse_survey`, plus some data viz for Surveys, see vignette "Analysis".
* wastd_POST can be used to update users and taxomony in WAStD.
* Changed example dataset names to "tne" and "nests".
* Added `map_tracks`, a map of turtle tracks/nests. WIP: more data viz for tracks.

## 1.0.3
* AnimalEncounters: add `maturity`
