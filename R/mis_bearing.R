#' Return the smallest possible angle for a sector's mean bearing and a given direction
#'
#' `dplyr::rowwise` is required to apply this function in `dplyr::mutate`.
#'
#'
#' @param from The smallest bearing of the sector, measured clockwise from North
#' @param to The largest bearing of the sector, measured clockwise from North
#' @param water The bearing of a direction
#' @export
#' @family helpers
#' @examples
#' testthat::expect_equal(mis_bearing(10, 50, 40), c(30, 40))
#' testthat::expect_equal(mis_bearing(10, 50, 340), c(340, 30))
#' testthat::expect_equal(mis_bearing(30, 50, 230), c(230, 40))
#' testthat::expect_equal(mis_bearing(30, 50, 210), c(40, 210))
mis_bearing <- function(from, to, water) {
  if (any(is.na(from), is.na(to), is.na(water))) {
    return(NA)
  }

  mid <- mean_bearing(from, to)
  mis_min <- min(mid, water)
  mis_max <- max(mid, water)


  if (mis_max - mis_min > 180) {
    # "[{from}-{mid}-{to}] vs {water} = [{mis_max}-{mis_min}]" %>%
    #   glue::glue() %>%
    #   wastdr::wastdr_msg_info()

    return(c(mis_max, mis_min))
  }

  # "[{from}-{mid}-{to}] vs {water} = [{mis_min}-{mis_max}]" %>%
  #   glue::glue() %>%
  #   wastdr::wastdr_msg_info()

  return(c(mis_min, mis_max))
}

# use_test("mis_bearing")  # nolint
