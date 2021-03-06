#' Print a blue info message with an info symbol.
#'
#' @param message (chr) A message to print
#' @return NULL
#' @export
#' @family helpers
#' @examples
#' wastdr_msg_info("This is an info message.")
wastdr_msg_info <- function(message) {
  x <- clisymbols::symbol$info
  message(crayon::cyan(glue::glue("{x} {message}\n")))
}

#' Print a green success message with a tick symbol.
#'
#' @param message (chr) A message to print
#' @return NULL
#' @export
#' @family helpers
#' @examples
#' wastdr_msg_success("This is a success message.")
wastdr_msg_success <- function(message) {
  x <- clisymbols::symbol$tick
  message(crayon::green(glue::glue("{x} {message}\n")))
}


#' Print a green noop message with a filled circle symbol.
#'
#' @param message (chr) A message to print
#' @return NULL
#' @export
#' @family helpers
#' @examples
#' wastdr_msg_noop("This is a noop message.")
wastdr_msg_noop <- function(message) {
  x <- clisymbols::symbol$circle_filled
  message(crayon::green(glue::glue("{x} {message}\n")))
}


#' rlang::warn() with a yellow warning message with a warning symbol.
#'
#' @param message (chr) A message to print
#' @return NULL
#' @export
#' @family helpers
#' @examples
#' \dontrun{
#' wastdr_msg_warn("This is a warning.")
#' }
wastdr_msg_warn <- function(message) {
  x <- clisymbols::symbol$warning
  rlang::warn(crayon::yellow(glue::glue("{x} {message}\n")))
}


#' rlang::abort() with a red error message with a cross symbol.
#'
#' @param message (chr) A message to print
#' @return NULL
#' @export
#' @family helpers
#' @examples
#' \dontrun{
#' wastdr_msg_abort("This is an error, abort.")
#' }
wastdr_msg_abort <- function(message) {
  x <- clisymbols::symbol$cross
  rlang::abort(crayon::red(glue::glue("{x} {message}\n")))
}

# usethis::use_test("wastdr_msg")
