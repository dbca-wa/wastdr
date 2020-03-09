suppressMessages(library(dplyr))

test_that("wastd_ae_raw parses correctly to animals", {
    data(wastd_ae_raw)
    data(wastd_ae)
    fresh_animals <- parse_animal_encounters(wastd_ae_raw)
    expect_equal(length(wastd_ae_raw$data), nrow(wastd_ae))
    expect_equal(nrow(fresh_animals), nrow(wastd_ae))

    # Compare pickled and fresh animals excluding list columns (like obs)
    expect_equal(
        fresh_animals %>% dplyr::select(-obs),
        wastd_ae %>% dplyr::select(-obs)
    )
})

test_that("wastd_api_response prints something", {
    data(wastd_ae_raw)
    expect_output(print(wastd_ae_raw))
})


test_that("wastd_tne_raw parses correctly to nests", {
    data(wastd_tne_raw)
    data(wastd_tne)
    fresh_tracks <- parse_turtle_nest_encounters(wastd_tne_raw) %>%
        add_nest_labels()
    expect_equal(length(wastd_tne_raw$data), nrow(wastd_tne))
    expect_equal(nrow(fresh_tracks), nrow(wastd_tne))

    # Compare pickled and fresh animals excluding list columns (like obs)
    expect_equal(
        fresh_tracks %>% dplyr::select(-obs, -photos),
        wastd_tne %>% dplyr::select(-obs, -photos)
    )
})

test_that("wastd_data contains expected tibbles", {
    data(wastd_data)
    expect_equal(
        names(wastd_data),
        c(
            "downloaded_on",
            "areas",
            "sites",
            "surveys",
            "animals",
            "tracks",
            "nest_dist",
            "nest_tags",
            "nest_excavations",
            "hatchling_morph",
            "nest_fans",
            "nest_fan_outliers",
            "nest_lightsources"
        )
    )
    purrr::map(wastd_data, class)
    expect_equal(class(wastd_data$downloaded_on), c("POSIXct", "POSIXt"))
    expect_equal(class(wastd_data$areas), c("sf", "data.frame"))
    expect_equal(class(wastd_data$surveys), c("tbl_df", "tbl", "data.frame"))
    expect_equal(class(wastd_data$animals), c("tbl_df", "tbl", "data.frame"))
    expect_equal(class(wastd_data$tracks), c("tbl_df", "tbl", "data.frame"))
    expect_equal(class(wastd_data$nest_dist), c("tbl_df", "tbl", "data.frame"))
})

# wastd_area_raw is tested in usethis::use_test("parse_area_sf")

