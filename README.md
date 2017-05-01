
[![Build Status](https://travis-ci.org/parksandwildlife/wastdr.svg?branch=master)](https://travis-ci.org/parksandwildlife/wastdr) [![Test coverage](https://codecov.io/gh/parksandwildlife/wastdr/branch/master/graph/badge.svg)](https://codecov.io/gh/parksandwildlife/wastdr)

wastdr makes WA Strandings Data accessible in R
===============================================

The [WA Strandings Database WAStD](https://strandings.dpaw.wa.gov.au/) lives at [github.com/parksandwildlife/wastd](https://github.com/parksandwildlife/wastd) and provides a RESTful API.

`wastdr` facilitates reading, parsing and using data from the WAStD API by providing helpers to access the API as well as examples on how to flatten the GeoJSON from the API into a two-dimensional tibble.

Installation
------------

Install `wastdr` from GitHub:

``` r
require(devtools) || install.packages("devtools")
devtools::install_github("parksandwildlife/wastdr")
```

Setup
-----

Find your valid WAStD API Token at [WAStD](https://strandings.dpaw.wa.gov.au/) under "My Profile" and run:

``` r
wastdr::wastdr_setup(api_token = "c12345asdfqwer")
```

Review the settings with:

``` r
library(wastdr)
#> Loading required package: httr
#> Loading required package: jsonlite
wastdr_settings()
#> <wastdr settings>
#>   API URL:  https://strandings.dpaw.wa.gov.au/api/1/ 
#>   API Token:  Token c12345asdfqwer
```

Get WAStD
---------

Load data from WAStD simply with:

``` r
track_records <- get_wastd('turtle-nest-encounters')
listviewer::jsonedit(track_records)
```

Valid endpoints are listed in the base API URL of WAStD, e.g.:

-   `encounters`
-   `animal-encounters`
-   `turtle-nest-encounters`

Learn more
----------

See the vignette for in-depth examples of transforming and analysing data.

``` r
vignette("getting-wastd")
```

Contribute
==========

Any contribution or suggestion is welcome! Send us your [issues](https://github.com/parksandwildlife/wastdr/issues) or submit a pull request.

Make sure to rebuild the documentation before checking the package.

Pull requests should pass checks (not introduce ERRORs, WARNINGs or NOTEs apart from the "New CRAN package" NOTE) and pass all tests:

``` r
devtools::document(roclets=c('rd', 'collate', 'namespace', 'vignette'))
devtools::check(check_version = T, force_suggests = T, cran = T)
devtools::test()
```
