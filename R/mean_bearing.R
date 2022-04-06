#' Calculate the mean bearing of two bearings (from, to)
#'
#' @param from The start bearing, counted clockwise from North
#' @param to The end bearing, counted clockwise from North
#' @return The mean of the two bearings as decimal degrees within `[0..360[`
#' @export
#' @family helpers
#' @examples
#' testthat::expect_equal(mean_bearing(NA, 10), NA)
#' testthat::expect_equal(mean_bearing(10, NA), NA)
#' testthat::expect_equal(mean_bearing(0, 20), 10)
#' testthat::expect_equal(mean_bearing(20, 60), 40)
#' testthat::expect_equal(mean_bearing(60, 0), 210)
mean_bearing <- function(from, to){

    # If from or to are NA, return NA
    if ((is.na(from) || is.na(to))) return(NA)

    # Ensure from and to fall between 0 and 360
    from <- ifelse(from > 360, from %% 360, from)
    to <- ifelse(to > 360, to %% 360, to)

    # If to is smaller that from, add 360 to allow mean
    to <- ifelse(to < from, to + 360, to)

    # Calculate the arithmetic mean, then return the modulo 360 remainder
    ((from + to) / 2) %% 360
}

# use_test("mean_bearing")  # nolint
