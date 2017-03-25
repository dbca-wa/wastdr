
wastr gets WAStD into R
=======================

`wastdr` facilitates reading, parsing and using data from the WAStD API.

Installation
------------

Install `wastdr` from GitHub:

``` r
require(devtools) || install.packages("devtools")
#> Loading required package: devtools
#> [1] TRUE
devtools::install_github("parksandwildlife/wastdr")
#> Skipping install of 'wastdr' from a github remote, the SHA1 (90911352) has not changed since last install.
#>   Use `force = TRUE` to force installation
```

Set confidential variables:

TODO follow ckanr\_setup

Get data
--------

### Live from the API

``` r
library(wastdr)
#> Loading required package: httr
#> Loading required package: jsonlite
# d <- wastd_api("animal-encounters")
# print(d)
```

### Example data from wastdr

``` r
cat("Implement: load data from WAStD, save as data/, then show here: load from data/")
#> Implement: load data from WAStD, save as data/, then show here: load from data/
```

Learn more
----------

See the vignette for in-depth examples of all functionality provided here.
