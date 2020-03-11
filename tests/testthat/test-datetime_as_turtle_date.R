test_that("datetime_as_turtle_date works", {

  # noon AWST is turtle date "2016-11-20":
  noon_awst <- httpdate_as_gmt08("2016-11-20T04:00:00Z")
  expect_equal(lubridate::tz(noon_awst), "Australia/Perth")
  expect_equal(noon_awst %>% as.character(), "2016-11-20 12:00:00")
  expect_equal(
    datetime_as_turtle_date(noon_awst) %>% as.character(),
    "2016-11-20"
  )

  # 1 sec before noon AWST is turtle date "2016-11-19":
  before_noon_awst <- httpdate_as_gmt08("2016-11-20T03:59:59Z")
  expect_equal(lubridate::tz(before_noon_awst), "Australia/Perth")
  expect_equal(before_noon_awst %>% as.character(), "2016-11-20 11:59:59")
  expect_equal(
    datetime_as_turtle_date(before_noon_awst) %>% as.character(),
    "2016-11-19"
  )

  # noon AWST is turtle date "2016-11-20":
  after_noon_awst <- httpdate_as_gmt08("2016-11-20T04:00:01Z")
  expect_equal(lubridate::tz(after_noon_awst), "Australia/Perth")
  expect_equal(after_noon_awst %>% as.character(), "2016-11-20 12:00:01")
  expect_equal(
    datetime_as_turtle_date(after_noon_awst) %>% as.character(),
    "2016-11-20"
  )
})

# usethis::use_r("datetime_as_turtle_date")
