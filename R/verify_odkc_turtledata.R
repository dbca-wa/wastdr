#' Abort if the parameter x is not of class `wastd_data`
#'
#' @template param-wastd-data
#' @export
#' @importFrom methods is
#' @family helpers
#' @examples
#' \dontrun{
#' data(odkc_data)
#' verify_odkc_turtledata(odkc_data)
#' testthat::expect_error(verify_odkc_turtledata(NULL))
#' testthat::expect_error(verify_odkc_turtledata(c(1, 2, 3)))
#' }
verify_odkc_turtledata <- function(x) {
  if (!inherits(x, "odkc_turtledata")) {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"odkc_turtledata\", ",
        "e.g. the output of wastdr::download_odkc_turtledata_2020."
      )
    )
  }
}

# use_test("verify_odkc_turtledata") # nolint
