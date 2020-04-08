test_that("filter_alive excludes dead outcome from WAStD", {
  data("wastd_data")

  filtered_data <- wastd_data$animals %>% filter_alive()
  filtered_values <- unique(filtered_data$health)

  excluded_values <- c(
    "alive-then-died",
    "dead-advanced",
    "dead-organs-intact",
    "dead-edible",
    "dead-mummified",
    "dead-disarticulated",
    "deadedible",
    "deadadvanced"
  )

  for (x in excluded_values) {
    expect_false(
      x %in% filtered_values,
      label = glue::glue("{x} found but should have been excluded")
    )
  }
})

test_that("filter_alive excludes dead outcome from ODKC", {
  data("odkc_data")

  filtered_data <- odkc_data$mwi %>% filter_alive()
  filtered_values <- unique(filtered_data$status_health)

  excluded_values <- c(
    "alive-then-died",
    "dead-advanced",
    "dead-organs-intact",
    "dead-edible",
    "dead-mummified",
    "dead-disarticulated",
    "deadedible",
    "deadadvanced"
  )

  for (x in excluded_values) {
    expect_false(
      x %in% filtered_values,
      label = glue::glue("{x} found but should have been excluded")
    )
  }
})


test_that("filter_dead excludes live outcome from WAStD", {
  data("wastd_data")

  filtered_data <- wastd_data$animals %>% filter_dead()
  filtered_values <- unique(filtered_data$health)

  excluded_values <- c(
    "na",
    "other",
    "alive",
    "alive-injured"
  )

  for (x in excluded_values) {
    expect_false(
      x %in% filtered_values,
      label = glue::glue("{x} found but should have been excluded")
    )
  }
})

test_that("filter_dead excludes live outcome from ODKC", {
  data("odkc_data")

  filtered_data <- odkc_data$mwi %>% filter_dead()
  filtered_values <- unique(filtered_data$status_health)

  excluded_values <- c(
    "na",
    "other",
    "alive",
    "alive-injured"
  )

  for (x in excluded_values) {
    expect_false(
      x %in% filtered_values,
      label = glue::glue("{x} found but should have been excluded")
    )
  }
})

# usethis::use_r("summarise_mwi")
