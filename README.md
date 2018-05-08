
[![Build Status](https://travis-ci.org/dbca-wa/wastdr.svg?branch=master)](https://travis-ci.org/dbca-wa/wastdr) [![Test coverage](https://codecov.io/gh/dbca-wa/wastdr/branch/master/graph/badge.svg)](https://codecov.io/gh/dbca-wa/wastdr)

wastdr makes WA Strandings Data accessible in R
===============================================

The [WA Strandings Database WAStD](https://tsc.dbca.wa.gov.au/) ([github](https://github.com/dbca-wa/wastd/)) provides a [RESTful API](https://tsc.dbca.wa.gov.au/api/1/). WAStD contains data about turtle strandings, turtle taggings, turtle track and nest encounters, and some ancillary data (areas, surveys, staff). WAStD is accessible to authenticated staff of the WA Department of Parks & Wildlife. The WAStD API uses token and basic authentication, see vignette on details.

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
devtools::install_github("dbca-wa/wastdr")
```

While the WAStD API is only accessible to a selected audience, and `wastdr` is under active development, it is not feasible to release `wastdr` on CRAN yet. Therefore, `wastdr` will be distributed via GitHub for the time being.

Setup
-----

`wastdr` requires to be configured with the WAStD API URL and an access token or a username / password combination. `wastdr` functions expect these settings to be available as environment variables. For convenience, `wastdr_setup` sets the correct variables, while `wastdr_settings` retrieves the currently set values.

DBCA staff can find their WAStD API Token at [WAStD](https://tsc.dbca.wa.gov.au/) under "My Profile" and run:

``` r
wastdr::wastdr_setup(api_token = "c12345asdfqwer")
```

External collaborator can use their allocated username and password:

``` r
wastdr::wastdr_setup(api_un = "my_username", api_pw = "my_password")
```

Review the settings with:

``` r
wastdr::wastdr_settings()
#> <wastdr settings>
#>   API URL:  https://strandings.dpaw.wa.gov.au/api/1/ 
#>   API Token:  Token c12345asdfqwer 
#>   API Username:  my_username 
#>   API Password:  my_password
```

For a more permanent configuration method using environment variables please see the vignette "Setup".

Get WAStD
---------

Once set up, `wastdr` can load data from WAStD simply with:

``` r
tne <- get_wastd("turtle-nest-encounters")
listviewer::jsonedit(tne)
nests <- parse_turtle_nest_encounters(tne)
```

Valid endpoints are listed in the base API URL of WAStD, e.g.:

-   `encounters`
-   `animal-encounters`
-   `turtle-nest-encounters`
-   `disturbance-observations`

...or have a pickle
-------------------

If you don't have access to the WAStD API, you can still get a feel for the data by using the pickled example data:

``` r
require(wastdr)
#> Loading required package: wastdr

data("animal_encounters")
data("tne")

# listviewer::jsonedit(animal_encounters$content)
# listviewer::jsonedit(tne$content)

animals <- wastdr::parse_animal_encounters(animal_encounters)
tracks <- wastdr::parse_turtle_nest_encounters(tne)

# DT::datatable(animals)
# DT::datatable(tracks)
```

Learn more
----------

See the vignette for in-depth examples of transforming, analysing and visualising data.

``` r
vignette("getting-wastd")
vignette("analysis")
```

Contribute
==========

Every contribution, constructive feedback, or suggestion is welcome!

Send us your ideas and requests as [issues](https://github.com/dbca-wa/wastdr/issues) or submit a pull request.

Pull requests should eventually pass tests and checks (not introducing new ERRORs, WARNINGs or NOTEs apart from the "New CRAN package" NOTE):

``` r
# install.packages("devtools")
# devtools::install_github("hadley/devtools", force=T)
# source("https://install-github.me/mangothecat/callr")
# devtools::install_github("hadley/pkgdown")
# devtools::install_github("klutometis/roxygen")
require(devtools)
require(pkgdown)
require(covr)
require(styler)
styler:::style_pkg()
devtools::document(roclets = c("rd", "collate", "namespace", "vignette"))
devtools::test()
devtools::check(check_version = T, force_suggests = T, args = c("--as-cran", "--timings"))
covr::codecov(token = Sys.getenv("CODECOV_TOKEN"))
pkgdown::build_news()
pkgdown::build_site()
```

To enable local testing of the API as well as checking and upload of test coverage, add these two lines with the respective tokens to your .Rprofile:

``` r
Sys.setenv(CODECOV_TOKEN = "my-codecov-token")
Sys.setenv(MY_API_TOKEN = "my-api-token")
```

The `wastdr` [webpage](https://dbca-wa.github.io/wastdr/) is hosted on gh-pages and generated using [pkgdown](https://github.com/hadley/pkgdown).
