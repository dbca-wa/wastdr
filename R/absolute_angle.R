#' Return the smallest possible angle between two compass bearings
#'
#' @param from The start bearing, counted clockwise from North
#' @param to The end bearing, counted clockwise from North
#' @return The smallest possible angle between the two bearings as decimal degrees
#'   within `[0..360[`.
#' @export
#' @family helpers
#' @examples
#' testthat::expect_equal(absolute_angle(NA, 10), NA)
#' testthat::expect_equal(absolute_angle(10, NA), NA)
#' testthat::expect_equal(absolute_angle(0, 20), 20)
#' testthat::expect_equal(absolute_angle(20, 0), -20)
#' testthat::expect_equal(absolute_angle(10, 0), -10)
#' testthat::expect_equal(absolute_angle(20, 60), 40)
#' testthat::expect_equal(absolute_angle(350, 10), 20)
#' testthat::expect_equal(absolute_angle(10, 350), -20)
absolute_angle <- function(from, to) {

  # If from or to are NA, return NA
  if ((is.na(from) || is.na(to))) {
    return(NA)
  }

  # smallest angle between from and to
  ((((to - from) %% 360) + 540) %% 360) - 180

  # clockwise angle from > to
  # ifelse(to < from, to + 360 - from, to - from)
}

# use_test("absolute_angle")  # nolint
