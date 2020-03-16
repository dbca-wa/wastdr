test_that("filter_alive excludes all health stages indicating death", {
  data("wastd_data")

  x <- wastd_data$animals %>% filter_alive()
  xn <- unique(x$health)

  expect_false("alive-then-died" %in% xn)
  expect_false("dead-advanced" %in% xn)
  expect_false("dead-organs-intact" %in% xn)
  expect_false("dead-edible" %in% xn)
  expect_false("dead-mummified" %in% xn)
  expect_false("dead-disarticulated" %in% xn)
  expect_false("deadedible" %in% xn)
  expect_false("deadadvanced" %in% xn)

})

test_that("filter_dead excludes all health stages indicating not dead", {
    data("wastd_data")

    x <- wastd_data$animals %>% filter_dead()
    xn <- unique(x$health)

    expect_false("na" %in% xn)
    expect_false("other" %in% xn)
    expect_false("alive" %in% xn)
    expect_false("alive-injured" %in% xn)

})


test_that("filter_alive_odkc excludes all health stages indicating death", {
    data("odkc_data")

    x <- odkc_data$mwi %>% filter_alive_odkc()
    xn <- unique(x$status_health)

    expect_false("alive-then-died" %in% xn)
    expect_false("dead-advanced" %in% xn)
    expect_false("dead-organs-intact" %in% xn)
    expect_false("dead-edible" %in% xn)
    expect_false("dead-mummified" %in% xn)
    expect_false("dead-disarticulated" %in% xn)
    expect_false("deadedible" %in% xn)
    expect_false("deadadvanced" %in% xn)
})

test_that("filter_dead_odkc excludes all health stages indicating not dead", {
    data("odkc_data")

    x <- odkc_data$mwi %>% filter_dead_odkc()
    xn <- unique(x$status_health)

    expect_false("na" %in% xn)
    expect_false("other" %in% xn)
    expect_false("alive" %in% xn)
    expect_false("alive-injured" %in% xn)
})
# usethis::use_r("summarise_mwi")
