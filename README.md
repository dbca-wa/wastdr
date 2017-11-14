
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
#>   API Username:  wastd_username 
#>   API Password:  wastd_password
```

If you are an external collaborator, see the vignette "Getting WAStD" for an alternative setup with username and password instead of an API token.

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

data("animal_encounters")
data("turtle_nest_encounters_hatched")
data("turtle_nest_encounters")

# listviewer::jsonedit(animal_encounters$content)
# listviewer::jsonedit(turtle_nest_encounters_hatched$content)
# listviewer::jsonedit(turtle_nest_encounters$content)

animals <- wastdr::parse_animal_encounters(animal_encounters)
nests <- wastdr::parse_turtle_nest_encounters(turtle_nest_encounters_hatched)
tracks <- wastdr::parse_turtle_nest_encounters(turtle_nest_encounters)

# DT::datatable(animals)
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
covr::codecov()
```

To enable local testing of the API as well as checking and upload of test coverage, add these two lines with the respective tokens to your .Rprofile:

``` r
Sys.setenv(CODECOV_TOKEN = "my-codecov-token")
Sys.setenv(MY_API_TOKEN = "my-api-token")
```

Updating the package documentation
----------------------------------

The `wastdr` [webpage](https://parksandwildlife.github.io/wastdr/) is hosted on gh-pages and generated using [pkgdown](https://github.com/hadley/pkgdown).

``` r
devtools::document(roclets=c('rd', 'collate', 'namespace', 'vignette'))
# devtools::install_github("hadley/pkgdown")
pkgdown::build_site()
```
