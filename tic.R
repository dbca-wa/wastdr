# installs dependencies, runs R CMD check, runs covr::codecov()
do_package_checks(
    error_on="error",
    args = c(
        "--no-manual",
        # "--as-cran",
        "--no-vignettes",
        "--no-build-vignettes",
        "--no-multiarch"
    )
)

# if (ci_on_ghactions() && ci_has_env("BUILD_PKGDOWN")) {
#   # creates pkgdown site and pushes to gh-pages branch
#   # only for the runner with the "BUILD_PKGDOWN" env var set
#   # do_pkgdown()
# }

get_stage("install") %>%
    # add_step(step_install_github(c("tidyverse/readr"))) %>%
    # https://stackoverflow.com/q/61875754/2813717 - install proj4
    # add_step(step_install_cran("proj4")) %>%
    # sf install fixed by cpp11
    # add_step(step_install_github("r-hub/sysreqs", dependencies = TRUE)) %>%
    # add_step(step_install_github("r-lib/cpp11", dependencies = TRUE)) %>%
    # add_step(step_install_github("r-spatial/sf", dependencies = TRUE)) %>%
    # add_step(step_install_github("r-spatial/mapview", dependencies = TRUE)) %>%
    # add_step(step_install_github("r-spatial/leafem", dependencies = TRUE)) %>%
    # add_step(step_install_github("ropensci/geojsonio", dependencies = TRUE)) %>%
    add_step(step_install_github("Ather-Energy/ggTimeSeries", dependencies = TRUE)) %>%
    add_step(tic::step_install_cran("pkgdown"))
    # add_step(step_install_cran("listviewer")) %>% # already installed
    # add_step(step_install_cran("geojsonlint")) %>% # already installed
    # libicui8n not found: fixed by stringi forced install
    # add_step(step_install_github("gagolews/stringi", dependencies = TRUE, force = TRUE))
