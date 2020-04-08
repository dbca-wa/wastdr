test_that("exclude_training_species works", {
  data("wastd_data")

  expect_true(is.na(
    match(
      "corolla-corolla",
      wastd_data$tracks %>%
        exclude_training_species() %>%
        magrittr::extract2("species") %>%
        unique()
    )
  ))
})

test_that("exclude_training_species_odkc works", {
  data("odkc_data")

  expect_true(is.na(
    match(
      "corolla-corolla",
      odkc_data$tracks %>%
        exclude_training_species_odkc() %>%
        magrittr::extract2("species") %>%
        unique()
    )
  ))
})

test_that("filter_missing_survey works", {
  data("wastd_data")
  expect_true(
    wastd_data$tracks %>% filter_missing_survey() %>% tibble::is_tibble()
  )
})

test_that("filter_missing_site works", {
  data("wastd_data")
  expect_true(
    wastd_data$tracks %>% filter_missing_site() %>% tibble::is_tibble()
  )
})

test_that("exclude_training_surveys works", {
  data("wastd_data")
  expect_true(
    wastd_data$surveys %>% exclude_training_surveys() %>% tibble::is_tibble()
  )
})

test_that("filter_surveys_requiring_qa works", {
  data("wastd_data")
  expect_true(wastd_data$surveys %>%
    filter_surveys_requiring_qa() %>%
    tibble::is_tibble())
})

test_that("filter_surveys_missing_end works", {
  data("wastd_data")
  expect_true(wastd_data$surveys %>%
    filter_surveys_missing_end() %>%
    tibble::is_tibble())

  # filter_nosite
  # filter_nosurvey
  # filter_realspecies
  # filter_realsurveys
})

test_that("filter_wastd_season works", {
  data("wastd_data")
  expect_true(
    wastd_data$tracks %>% filter_wastd_season(2019) %>% tibble::is_tibble()
  )
})

# usethis::use_r("filters")
