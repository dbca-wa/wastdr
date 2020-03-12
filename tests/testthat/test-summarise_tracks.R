sf_as_tbl
test_that("sf_as_tbl returns a tibble", {
    data("wastd_data")

    x <- sf_as_tbl(wastd_data$sites)

    expect_true(tibble::is_tibble(x))
})



test_that("nesting_type_by_season_species returns a tibble", {
    data("wastd_data")

    x <- nesting_type_by_season_species(wastd_data$tracks)

    expect_true(tibble::is_tibble(x))
    expect_true("season" %in% names(x))
    expect_true("species" %in% names(x))
})

test_that("nesting_type_by_season_age_species returns a tibble", {
    data("wastd_data")

    x <- nesting_type_by_season_age_species(wastd_data$tracks)

    expect_true(tibble::is_tibble(x))
    expect_true("season" %in% names(x))
    expect_true("species" %in% names(x))
    expect_true("nest_age" %in% names(x))

})


test_that("nesting_type_by_area_season_species returns a tibble", {
    data("wastd_data")

    x <- nesting_type_by_area_season_species(wastd_data$tracks)

    expect_true(tibble::is_tibble(x))
    expect_true("area_name" %in% names(x))
    expect_true("season" %in% names(x))
    expect_true("species" %in% names(x))

})


test_that("nesting_type_by_area_season_age_species returns a tibble", {
    data("wastd_data")

    x <- nesting_type_by_area_season_age_species(wastd_data$tracks)

    expect_true(tibble::is_tibble(x))
    expect_true("area_name" %in% names(x))
    expect_true("season" %in% names(x))
    expect_true("species" %in% names(x))
    expect_true("nest_age" %in% names(x))
})

test_that("nesting_type_by_site_season_species returns a tibble", {
    data("wastd_data")

    x <- nesting_type_by_site_season_species(wastd_data$tracks)

    expect_true(tibble::is_tibble(x))
    expect_true("area_name" %in% names(x))
    expect_true("site_name" %in% names(x))
    expect_true("season" %in% names(x))
    expect_true("species" %in% names(x))
})


test_that("nesting_type_by_site_season_age_species returns a tibble", {
    data("wastd_data")

    x <- nesting_type_by_site_season_age_species(wastd_data$tracks)

    expect_true(tibble::is_tibble(x))
    expect_true("area_name" %in% names(x))
    expect_true("site_name" %in% names(x))
    expect_true("season" %in% names(x))
    expect_true("species" %in% names(x))
    expect_true("nest_age" %in% names(x))

})



test_that("nesting_type_by_season_week_age_species returns a tibble", {
    data("wastd_data")

    x <- nesting_type_by_season_week_age_species(wastd_data$tracks)

    expect_true(tibble::is_tibble(x))
    expect_true("season" %in% names(x))
    expect_true("season_week" %in% names(x))
    expect_true("iso_week" %in% names(x))
    expect_true("species" %in% names(x))
    expect_true("nest_age" %in% names(x))
})


test_that("nesting_type_by_season_week_site_species returns a tibble", {
    data("wastd_data")

    x <- nesting_type_by_season_week_site_species(wastd_data$tracks)

    expect_true(tibble::is_tibble(x))
    expect_true("site_name" %in% names(x))
    expect_true("season" %in% names(x))
    expect_true("season_week" %in% names(x))
    expect_true("iso_week" %in% names(x))
    expect_true("species" %in% names(x))
})


# nesting_type_by_season_day_species
# nesting_type_by_season_calendarday_species
# nesting_type_by_season_calendarday_age_species
#
#
# track_success
# track_success_by_species
# ggplot_track_success_by_date
# ggplot_track_successrate_by_date
#
# summarise_hatching_and_emergence_success
# hatching_emergence_success
# hatching_emergence_success_area
# hatching_emergence_success_site

# usethis::use_r("summarise_tracks")
