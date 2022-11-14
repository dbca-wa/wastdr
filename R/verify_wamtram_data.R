#' Abort if the parameter x is not of class `wastd_data`
#'
#' @template param-wastd-data
#' @export
#' @importFrom methods is
#' @family helpers
#' @examples
#' \dontrun{
#' # data(wamtram_data)
#' # verify_wamtram_data(wamtram_data)
#' testthat::expect_error(verify_wamtram_data(NULL))
#' testthat::expect_error(verify_wamtram_data(c(1, 2, 3)))
#' }
verify_wamtram_data <- function(x) {
  if (!inherits(x, "wamtram_data")) {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"wamtram_data\", ",
        "e.g. the output of wastdr::download_w2_data."
      )
    )
  }
}

# use_test("verify_wamtram_data") # nolint
