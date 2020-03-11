#' Check whether API token is set and WAStD is online, else skip test
#'
#' \lifecycle{stable}
#'
#' @family helpers
#' @export
skip_test_if_wastd_offline <- function() {
  res <- wastd_GET("", verbose = FALSE)
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

  if (!tibble::is_tibble(res)) testthat::skip("Check your ODKC credentials!")
}
