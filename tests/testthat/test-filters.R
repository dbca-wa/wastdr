test_that("filters work", {
  expect_equal(2 * 2, 4)

  data("wastd_data")
  data("odkc_data")

  expect_true(is.na(
    match(
      "corolla-corolla",
      wastd_data$tracks %>%
        exclude_training_species() %>%
        magrittr::extract2("species") %>%
        unique()
    )
  ))

  expect_true(is.na(
    match(
      "corolla-corolla",
      odkc_data$tracks %>%
        exclude_training_species_odkc() %>%
        magrittr::extract2("species") %>%
        unique()
    )
  ))

  expect_true(
    wastd_data$tracks %>% filter_missing_survey() %>% tibble::is_tibble()
  )

  expect_true(
    wastd_data$tracks %>% filter_missing_site() %>% tibble::is_tibble()
  )

  expect_true(
    wastd_data$surveys %>% exclude_training_surveys() %>% tibble::is_tibble()
  )


  expect_true(
    wastd_data$surveys %>%
      filter_surveys_requiring_qa() %>%
      tibble::is_tibble()
  )


  expect_true(
    wastd_data$surveys %>%
      filter_surveys_missing_end() %>%
      tibble::is_tibble()
  )

  # filter_nosite
  # filter_nosurvey
  # filter_realspecies
  # filter_realsurveys

  expect_true(
    wastd_data$tracks %>% filter_wastd_season(2019) %>% tibble::is_tibble()
  )
})

# usethis::use_r("filters")
