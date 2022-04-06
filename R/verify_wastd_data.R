#' Abort if the parameter x is not of class `wastd_data`
#'
#' @template param-wastd-data
#' @export
#' @examples
#' \dontrun{
#' data(wastd_data)
#' verify_wastd_data(wastd_data)
#' testthat::expect_error(verify_wastd_data(NULL))
#' testthat::expect_error(verify_wastd_data(c(1,2,3)))
#' }
verify_wastd_data <- function(x) {
    if (class(x) != "wastd_data") {
        wastdr_msg_abort(
            glue::glue(
                "The first argument needs to be an object of class \"wastd_data\", ",
                "e.g. the output of wastdr::download_wastd_turtledata."
            )
        )
    }
}

# use_test("verify_wastd_data") # nolint
