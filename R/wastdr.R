#' @description \code{\link{wastdr}} is an R Client for the ODK Central API.
#' The 'WA Sea Turtle Database' 'WAStD' is a 'Django' web app with a 'RESTful'
#' 'API' returning 'GeoJSON' 'FeatureCollections'.
#' \code{\link{wastdr}} provides helpers to retrieve data from the 'API',
#' and to turn the received 'GeoJSON' into R 'tibbles'.
#' \code{\link{wastdr}} will grow alongside implemented
#' use cases of retrieving and analysing 'WAStD' data.
#'
#'   Please see the `wastdr` website for full documentation:
#'   * <https://dbca-wa.github.io/wastdr/>
#'
#'   `ruODK` is "pipe-friendly" and re-exports `%>%`, but does not
#'   require their use.
#'
#' @keywords internal
"_PACKAGE"


#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @family utilities
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL


# CMD check silencer
utils::globalVariables(".")
