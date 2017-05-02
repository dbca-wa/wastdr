
[![Build Status](https://travis-ci.org/parksandwildlife/wastdr.svg?branch=master)](https://travis-ci.org/parksandwildlife/wastdr) [![Test coverage](https://codecov.io/gh/parksandwildlife/wastdr/branch/master/graph/badge.svg)](https://codecov.io/gh/parksandwildlife/wastdr)

wastdr makes WA Strandings Data accessible in R
===============================================

The [WA Strandings Database WAStD](https://strandings.dpaw.wa.gov.au/) lives at [github.com/parksandwildlife/wastd](https://github.com/parksandwildlife/wastd) and provides a RESTful API. WAStD contains data about turtle strandings, turtle taggings, turtle track and nest encounters, and some ancillary data (areas, staff). WAStD is accessible to authenticated staff of the WA Department of Parks & Wildlife. The WAStD API, while in development, is accessible to the DPaW intranet.

The API returns GeoJSON, which can be loaded directly into any standard-compliant GIS environments, e.g. [Quantum GIS](http://www.qgis.org/en/site/).

If the data consumer however wishes to analyse data in a statistical package like R, the data need to be transformed from a nested list of lists (GeoJSON) into a two-dimensional tablular structure.

The main purpose of `wastdr` is to facilitate reading, parsing and using WAStD data by providing helpers to access the API and flatten the API outputs into a [tidy](http://vita.had.co.nz/papers/tidy-data.html) `dplyr::tibble`.

The secondary purpose of `wastdr` is to centralise a collection of commonly used analyses and visualisations of turtle data. As development progresses, example analyses and visualisationsn will be added to the vignette. Contributions and requests are welcome!

Lastly, to facilitate collaboration with external stakeholders, `wastdr` contains some anonymized example data (raw GeoJSON and parsed `tibble`) of turtle taggings, turtle track counts, and turtle nests.

Installation
------------

Install `wastdr` from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("parksandwildlife/wastdr")
```

While the WAStD API is only accessible to a selected audience, and `wastdr` is under active development, it is not feasible to release `wastdr` on CRAN yet. Therefore, `wastdr` will be distributed via GitHub for the time being.

Setup
-----

`wastdr` requires two settings, the API URL and an access token. `wastdr` functions expect both settings to be available as environment variables. For convenience, `wastdr_setup` sets the correct variables, while `wastdr_settings` retrieves the currently set values.

Find your valid WAStD API Token at [WAStD](https://strandings.dpaw.wa.gov.au/) under "My Profile" and run:

``` r
wastdr::wastdr_setup(api_token = "c12345asdfqwer")
```

Review the settings with:

``` r
wastdr::wastdr_settings()
#> <wastdr settings>
#>   API URL:  https://strandings.dpaw.wa.gov.au/api/1/ 
#>   API Token:  Token c12345asdfqwer
```

Get WAStD
---------

Load data from WAStD simply with:

``` r
turtle_nest_encounters <- get_wastd('turtle-nest-encounters')
listviewer::jsonedit(turtle_nest_encounters)

tracks <- parse_turtle_nest_encounters(turtle_nest_encounters)
```

Valid endpoints are listed in the base API URL of WAStD, e.g.:

-   `encounters`
-   `animal-encounters`
-   `turtle-nest-encounters`

...or have a pickle
-------------------

If you don't have access to the WAStD API, you can still get a feel for the data by using the pickled example data:

``` r
require(wastdr)
#> Loading required package: wastdr
#> Loading required package: httr
#> Loading required package: jsonlite

data("animal_encounters")
data("turtle_nest_encounters_hatched")
data("turtle_nest_encounters")

listviewer::jsonedit(animal_encounters$content)
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-598ab484a59d838dff07">{"x":{"data":[{"id":"wamtram-observation-id-255155","type":"Feature","geometry":{"type":"Point","coordinates":[115.01965,-21.46328]},"properties":{"pk":4482,"site_visit":[],"source":"wamtram","encounter_type":"tagging","leaflet_title":"2013 Tagging ","status":"new","observer":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"reporter":{"username":"public_report","name":"Public Report","email":"","phone":[]},"latitude":-21.46328,"longitude":115.01965,"crs":"WGS 84","location_accuracy":"10","when":"2013-08-04T02:00:00Z","name":[],"taxon":"Cheloniidae","species":"eretmochelys-imbricata","health":"na","sex":"female","behaviour":[],"habitat":"na","activity":"floating","nesting_event":"na","checked_for_injuries":"na","scanned_for_pit_tags":"na","checked_for_flipper_tags":"na","cause_of_death":"na","cause_of_death_confidence":"na","absolute_admin_url":"/admin/observations/animalencounter/4482/change/","photographs":[],"tx_logs":[],"observation_set":[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WA14951","tag_location":"flipper-front-right-1","status":"removed","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WA14772","tag_location":"flipper-front-left-1","status":"removed","comments":"Tags returnedNA"}]}},{"id":"wamtram-observation-id-267172","type":"Feature","geometry":{"type":"Point","coordinates":[115.01926,-21.46355]},"properties":{"pk":4647,"site_visit":[],"source":"wamtram","encounter_type":"tagging","leaflet_title":"2016 Tagging WB7309","status":"new","observer":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"reporter":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"latitude":-21.46355,"longitude":115.01926,"crs":"WGS 84","location_accuracy":"10","when":"2016-11-23T14:17:00Z","name":"WB7309","taxon":"Cheloniidae","species":"natator-depressus","health":"na","sex":"female","behaviour":[],"habitat":"beach-edge-of-vegetation","activity":"returning-to-water","nesting_event":"absent","checked_for_injuries":"na","scanned_for_pit_tags":"na","checked_for_flipper_tags":"na","cause_of_death":"na","cause_of_death_confidence":"na","absolute_admin_url":"/admin/observations/animalencounter/4647/change/","photographs":[],"tx_logs":[],"observation_set":[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7310","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7309","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}]}},{"id":"wamtram-observation-id-267173","type":"Feature","geometry":{"type":"Point","coordinates":[115.02021,-21.46309]},"properties":{"pk":4648,"site_visit":[],"source":"wamtram","encounter_type":"tagging","leaflet_title":"2016 Tagging WB7351","status":"new","observer":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"reporter":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"latitude":-21.46309,"longitude":115.02021,"crs":"WGS 84","location_accuracy":"10","when":"2016-11-24T16:25:00Z","name":"WB7351","taxon":"Cheloniidae","species":"natator-depressus","health":"na","sex":"female","behaviour":[],"habitat":"na","activity":"returning-to-water","nesting_event":"absent","checked_for_injuries":"na","scanned_for_pit_tags":"na","checked_for_flipper_tags":"na","cause_of_death":"na","cause_of_death_confidence":"na","absolute_admin_url":"/admin/observations/animalencounter/4648/change/","photographs":[],"tx_logs":[],"observation_set":[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7352","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7351","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}]}},{"id":"wamtram-observation-id-267175","type":"Feature","geometry":{"type":"Point","coordinates":[115.01583,-21.46399]},"properties":{"pk":4649,"site_visit":[],"source":"wamtram","encounter_type":"tagging","leaflet_title":"2016 Tagging WB7369","status":"new","observer":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"reporter":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"latitude":-21.46399,"longitude":115.01583,"crs":"WGS 84","location_accuracy":"10","when":"2016-11-25T13:40:00Z","name":"WB7369","taxon":"Cheloniidae","species":"natator-depressus","health":"na","sex":"female","behaviour":[],"habitat":"na","activity":"returning-to-water","nesting_event":"absent","checked_for_injuries":"na","scanned_for_pit_tags":"na","checked_for_flipper_tags":"na","cause_of_death":"na","cause_of_death_confidence":"na","absolute_admin_url":"/admin/observations/animalencounter/4649/change/","photographs":[],"tx_logs":[],"observation_set":[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7370","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7369","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}]}},{"id":"wamtram-observation-id-267176","type":"Feature","geometry":{"type":"Point","coordinates":[115.02446,-21.46039]},"properties":{"pk":4650,"site_visit":[],"source":"wamtram","encounter_type":"tagging","leaflet_title":"2016 Tagging WB7335","status":"new","observer":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"reporter":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"latitude":-21.46039,"longitude":115.02446,"crs":"WGS 84","location_accuracy":"10","when":"2016-11-25T14:10:00Z","name":"WB7335","taxon":"Cheloniidae","species":"natator-depressus","health":"na","sex":"female","behaviour":[],"habitat":"na","activity":"returning-to-water","nesting_event":"absent","checked_for_injuries":"na","scanned_for_pit_tags":"na","checked_for_flipper_tags":"na","cause_of_death":"na","cause_of_death_confidence":"na","absolute_admin_url":"/admin/observations/animalencounter/4650/change/","photographs":[],"tx_logs":[],"observation_set":[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7336","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7335","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}]}},{"id":"wamtram-observation-id-267177","type":"Feature","geometry":{"type":"Point","coordinates":[115.0188,-21.46341]},"properties":{"pk":4651,"site_visit":[],"source":"wamtram","encounter_type":"tagging","leaflet_title":"2016 Tagging WB7309","status":"new","observer":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"reporter":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"latitude":-21.46341,"longitude":115.0188,"crs":"WGS 84","location_accuracy":"10","when":"2016-11-26T10:25:00Z","name":"WB7309","taxon":"Cheloniidae","species":"natator-depressus","health":"na","sex":"female","behaviour":"","habitat":"beach-edge-of-vegetation","activity":"returning-to-water","nesting_event":"present","checked_for_injuries":"na","scanned_for_pit_tags":"na","checked_for_flipper_tags":"na","cause_of_death":"na","cause_of_death_confidence":"na","absolute_admin_url":"/admin/observations/animalencounter/4651/change/","photographs":[],"tx_logs":[],"observation_set":[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7310","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7309","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}]}},{"id":"wamtram-observation-id-267178","type":"Feature","geometry":{"type":"Point","coordinates":[115.02187,-21.4621]},"properties":{"pk":4652,"site_visit":[],"source":"wamtram","encounter_type":"tagging","leaflet_title":"2016 Tagging WB7335","status":"new","observer":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"reporter":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"latitude":-21.4621,"longitude":115.02187,"crs":"WGS 84","location_accuracy":"10","when":"2016-11-26T10:43:00Z","name":"WB7335","taxon":"Cheloniidae","species":"natator-depressus","health":"na","sex":"female","behaviour":[],"habitat":"beach-above-high-water","activity":"returning-to-water","nesting_event":"present","checked_for_injuries":"na","scanned_for_pit_tags":"na","checked_for_flipper_tags":"na","cause_of_death":"na","cause_of_death_confidence":"na","absolute_admin_url":"/admin/observations/animalencounter/4652/change/","photographs":[],"tx_logs":[],"observation_set":[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7336","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7335","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}]}},{"id":"wamtram-observation-id-267181","type":"Feature","geometry":{"type":"Point","coordinates":[115.01886,-21.46347]},"properties":{"pk":4655,"site_visit":[],"source":"wamtram","encounter_type":"tagging","leaflet_title":"2016 Tagging WB7382","status":"new","observer":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"reporter":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"latitude":-21.46347,"longitude":115.01886,"crs":"WGS 84","location_accuracy":"10","when":"2016-11-26T15:35:00Z","name":"WB7382","taxon":"Cheloniidae","species":"natator-depressus","health":"na","sex":"female","behaviour":[],"habitat":"na","activity":"returning-to-water","nesting_event":"na","checked_for_injuries":"na","scanned_for_pit_tags":"na","checked_for_flipper_tags":"na","cause_of_death":"na","cause_of_death_confidence":"na","absolute_admin_url":"/admin/observations/animalencounter/4655/change/","photographs":[],"tx_logs":[],"observation_set":[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7433","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7382","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}]}},{"id":"wamtram-observation-id-267182","type":"Feature","geometry":{"type":"Point","coordinates":[115.01419,-21.46409]},"properties":{"pk":4656,"site_visit":[],"source":"wamtram","encounter_type":"tagging","leaflet_title":"2016 Tagging WB7337","status":"new","observer":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"reporter":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"latitude":-21.46409,"longitude":115.01419,"crs":"WGS 84","location_accuracy":"10","when":"2016-11-26T15:40:00Z","name":"WB7337","taxon":"Cheloniidae","species":"natator-depressus","health":"na","sex":"female","behaviour":"","habitat":"na","activity":"returning-to-water","nesting_event":"absent","checked_for_injuries":"na","scanned_for_pit_tags":"na","checked_for_flipper_tags":"na","cause_of_death":"na","cause_of_death_confidence":"na","absolute_admin_url":"/admin/observations/animalencounter/4656/change/","photographs":[],"tx_logs":[],"observation_set":[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7338","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7337","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}]}},{"id":"wamtram-observation-id-267386","type":"Feature","geometry":{"type":"Point","coordinates":[115.0162,-21.46395]},"properties":{"pk":4842,"site_visit":[],"source":"wamtram","encounter_type":"tagging","leaflet_title":"2016 Tagging WB7311","status":"new","observer":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"reporter":{"username":"admin","name":"Florian Mayer (Admin)","email":"florian.wendelin.mayer@gmail.com","phone":"+61414239161"},"latitude":-21.46395,"longitude":115.0162,"crs":"WGS 84","location_accuracy":"10","when":"2016-11-27T12:08:00Z","name":"WB7311","taxon":"Cheloniidae","species":"natator-depressus","health":"na","sex":"female","behaviour":"","habitat":"in-dune-vegetation","activity":"returning-to-water","nesting_event":"absent","checked_for_injuries":"na","scanned_for_pit_tags":"na","checked_for_flipper_tags":"na","cause_of_death":"na","cause_of_death_confidence":"na","absolute_admin_url":"/admin/observations/animalencounter/4842/change/","photographs":[],"tx_logs":[],"observation_set":[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7312","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7311","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}]}}],"options":{"mode":"tree","modes":["code","form","text","tree","view"]}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
``` r
# listviewer::jsonedit(turtle_nest_encounters_hatched$content)
# listviewer::jsonedit(turtle_nest_encounters$content)

animals <- wastdr::parse_animal_encounters(animal_encounters)
nests <- wastdr::parse_turtle_nest_encounters(turtle_nest_encounters_hatched)
tracks <- wastdr::parse_turtle_nest_encounters(turtle_nest_encounters)

DT::datatable(animals)
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-7d2de053e6e141422f1d">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10"],["2013-08-04T02:00:00Z","2016-11-23T14:17:00Z","2016-11-24T16:25:00Z","2016-11-25T13:40:00Z","2016-11-25T14:10:00Z","2016-11-26T10:25:00Z","2016-11-26T10:43:00Z","2016-11-26T15:35:00Z","2016-11-26T15:40:00Z","2016-11-27T12:08:00Z"],[115.01965,115.01926,115.02021,115.01583,115.02446,115.0188,115.02187,115.01886,115.01419,115.0162],[-21.46328,-21.46355,-21.46309,-21.46399,-21.46039,-21.46341,-21.4621,-21.46347,-21.46409,-21.46395],["WGS 84","WGS 84","WGS 84","WGS 84","WGS 84","WGS 84","WGS 84","WGS 84","WGS 84","WGS 84"],[10,10,10,10,10,10,10,10,10,10],["2013-08-03","2016-11-23","2016-11-24","2016-11-25","2016-11-25","2016-11-26","2016-11-26","2016-11-26","2016-11-26","2016-11-27"],["eretmochelys-imbricata","natator-depressus","natator-depressus","natator-depressus","natator-depressus","natator-depressus","natator-depressus","natator-depressus","natator-depressus","natator-depressus"],["na","na","na","na","na","na","na","na","na","na"],["female","female","female","female","female","female","female","female","female","female"],["na","beach-edge-of-vegetation","na","na","na","beach-edge-of-vegetation","beach-above-high-water","na","na","in-dune-vegetation"],["floating","returning-to-water","returning-to-water","returning-to-water","returning-to-water","returning-to-water","returning-to-water","returning-to-water","returning-to-water","returning-to-water"],["na","absent","absent","absent","absent","present","present","na","absent","absent"],["na","na","na","na","na","na","na","na","na","na"],["na","na","na","na","na","na","na","na","na","na"],["na","na","na","na","na","na","na","na","na","na"],["na","na","na","na","na","na","na","na","na","na"],["na","na","na","na","na","na","na","na","na","na"],["/admin/observations/animalencounter/4482/change/","/admin/observations/animalencounter/4647/change/","/admin/observations/animalencounter/4648/change/","/admin/observations/animalencounter/4649/change/","/admin/observations/animalencounter/4650/change/","/admin/observations/animalencounter/4651/change/","/admin/observations/animalencounter/4652/change/","/admin/observations/animalencounter/4655/change/","/admin/observations/animalencounter/4656/change/","/admin/observations/animalencounter/4842/change/"],[[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WA14951","tag_location":"flipper-front-right-1","status":"removed","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WA14772","tag_location":"flipper-front-left-1","status":"removed","comments":"Tags returnedNA"}],[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7310","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7309","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}],[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7352","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7351","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}],[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7370","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7369","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}],[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7336","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7335","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}],[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7310","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7309","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}],[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7336","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7335","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}],[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7433","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7382","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}],[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7338","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7337","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}],[{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7312","tag_location":"flipper-front-right-1","status":"resighted","comments":"NANA"},{"observation_name":"tagobservation","tag_type":"flipper-tag","name":"WB7311","tag_location":"flipper-front-left-1","status":"resighted","comments":"NANA"}]],["wamtram","wamtram","wamtram","wamtram","wamtram","wamtram","wamtram","wamtram","wamtram","wamtram"],["wamtram-observation-id-255155","wamtram-observation-id-267172","wamtram-observation-id-267173","wamtram-observation-id-267175","wamtram-observation-id-267176","wamtram-observation-id-267177","wamtram-observation-id-267178","wamtram-observation-id-267181","wamtram-observation-id-267182","wamtram-observation-id-267386"],["tagging","tagging","tagging","tagging","tagging","tagging","tagging","tagging","tagging","tagging"],["new","new","new","new","new","new","new","new","new","new"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>datetime<\/th>\n      <th>longitude<\/th>\n      <th>latitude<\/th>\n      <th>crs<\/th>\n      <th>location_accuracy<\/th>\n      <th>date<\/th>\n      <th>species<\/th>\n      <th>health<\/th>\n      <th>sex<\/th>\n      <th>habitat<\/th>\n      <th>activity<\/th>\n      <th>nesting_event<\/th>\n      <th>checked_for_injuries<\/th>\n      <th>scanned_for_pit_tags<\/th>\n      <th>checked_for_flipper_tags<\/th>\n      <th>cause_of_death<\/th>\n      <th>cause_of_death_confidence<\/th>\n      <th>absolute_admin_url<\/th>\n      <th>obs<\/th>\n      <th>source<\/th>\n      <th>source_id<\/th>\n      <th>encounter_type<\/th>\n      <th>status<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[2,3,5]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
``` r
# DT::datatable(nests)
# DT::datatable(tracks)
```

Learn more
----------

See the vignette for in-depth examples of transforming, analysing and visualising data.

``` r
vignette("getting-wastd")
```

Contribute
==========

Every contribution, constructive feedback, or suggestion is welcome!

Send us your ideas and requests as [issues](https://github.com/parksandwildlife/wastdr/issues) or submit a pull request.

Pull requests should eventually pass tests and checks (not introducing new ERRORs, WARNINGs or NOTEs apart from the "New CRAN package" NOTE):

``` r
devtools::document(roclets=c('rd', 'collate', 'namespace', 'vignette'))
devtools::test()
devtools::check(check_version = T, force_suggests = T, cran = T)
```
