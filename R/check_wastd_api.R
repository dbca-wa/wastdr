#' Check whether API token is set and WAStD is online, else skip test
#' @export
skip_test_if_wastd_offline <- function() {
  res <- wastd_GET("", verbose = FALSE)
  if (res$status_code != 200) {
    testthat::skip("WAStD is offline or authentication is missing.")
  }
}

#' Check whether API token is set and WAStD is online, else skip test
#' @export
skip_test_if_odkc_offline <- function() {
    res <- ruODK::project_list() # will error if auth fails
    if (!tibble::is_tibble(res)) testthat::skip("Check your ODKC credentials!")
}
