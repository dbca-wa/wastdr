#' Check whether API token is set and WAStD is online, else skip test
#'
#' \lifecycle{stable}
#' @template param-auth
#'
#' @family helpers
#' @export
skip_test_if_wastd_offline <- function(api_url = get_wastdr_api_url(),
                                       api_token = get_wastdr_api_token(),
                                       api_un = get_wastdr_api_un(),
                                       api_pw = get_wastdr_api_pw()) {

  suppressWarnings(
      res <- wastd_GET(
      "",
      max_records = 1,
      api_url = api_url,
      api_token = api_token,
      api_un = api_un,
      api_pw = api_pw,
      verbose = TRUE
    )
  )

  if (res$status_code != 200) {
    testthat::skip("WAStD is offline or authentication is missing.")
  }
}

#' Check whether API token is set and WAStD is online, else skip test
#'
#' \lifecycle{stable}
#'
#' @family helpers
#' @export
skip_test_if_odkc_offline <- function() {
  ruODK::ru_setup(
    url = ruODK::get_default_url(),
    un = ruODK::get_default_un(),
    pw = ruODK::get_default_pw()
  )

  res <- ruODK::project_list(
    url = ruODK::get_default_url(),
    un = ruODK::get_default_un(),
    pw = ruODK::get_default_pw()
  ) # will error if auth fails

  if (!tibble::is_tibble(res))
    testthat::skip("Check your ODKC credentials!")
}

# usethis::use_test("check_wastd_api")
