test_that("build_auth uses TokenAuth if api_token is set", {
  x <- build_auth(verbose = FALSE)
  expect_equal(class(x), "request")
  expect_equal(x$auth_token, NULL)
  expect_equal(x$options$httpauth, NULL)
  expect_true(length(x$options$userpwd) == 0)
  expect_true("Authorization" %in% names(x$headers))
})

test_that(
  "build_auth uses TokenAuth if api_token is set but api_un/pw are NULL",
  {
    x <- build_auth(api_un = NULL, api_pw = NULL, verbose = FALSE)
    expect_equal(class(x), "request")
    expect_equal(x$auth_token, NULL)
    expect_equal(x$options$httpauth, NULL)
    expect_true(length(x$options$userpwd) == 0)
    expect_true("Authorization" %in% names(x$headers))
  }
)


test_that("build_auth uses BasicAuth if api_token is NULL", {
  x <- build_auth(api_token = NULL, verbose = FALSE)
  expect_equal(class(x), "request")
  expect_equal(x$auth_token, NULL)
  expect_equal(x$options$httpauth, 1)
  expect_true(length(x$options$userpwd) > 0)
})

test_that("build_auth emits verbose message if api_token is NULL", {
  expect_message(build_auth(api_token = NULL, verbose = TRUE))
})

test_that("build_auth errors if api_token and api_un are NULL", {
  expect_error(build_auth(api_token = NULL, api_un = NULL, verbose = FALSE))
})


test_that("build_auth errors if api_token and api_pw are NULL", {
  expect_error(build_auth(api_token = NULL, api_pw = NULL, verbose = FALSE))
})

# usethis::use_r("build_auth")
