#' Print a blue info message with an info symbol if verbose.
#'
#' @param message (chr) A message to print
#' @template param-verbose
#' @return NULL
#' @export
#' @family helpers
#' @examples
#' wastdr_msg_info("This is an info message.")
wastdr_msg_info <- function(message,
                            verbose = wastdr::get_wastdr_verbose()) {
  if (verbose == FALSE) {
    return(NULL)
  }
  # x <- clisymbols::symbol$info
  message(crayon::cyan(glue::glue("ℹ {message}\n")))
}

#' Print a green success message with a tick symbol if verbose.
#'
#' @param message (chr) A message to print
#' @template param-verbose
#' @return NULL
#' @export
#' @family helpers
#' @examples
#' wastdr_msg_success("This is a success message.")
wastdr_msg_success <- function(message,
                               verbose = wastdr::get_wastdr_verbose()) {
  if (verbose == FALSE) {
    return(NULL)
  }
  # x <- clisymbols::symbol$tick
  message(crayon::green(glue::glue("✔ {message}\n")))
}


#' Print a green noop message with a filled circle symbol if verbose.
#'
#' @param message (chr) A message to print
#' @template param-verbose
#' @return NULL
#' @export
#' @family helpers
#' @examples
#' wastdr_msg_noop("This is a noop message.")
wastdr_msg_noop <- function(message,
                            verbose = wastdr::get_wastdr_verbose()) {
  if (verbose == FALSE) {
    return(NULL)
  }
  # x <- clisymbols::symbol$circle_filled
  message(crayon::green(glue::glue("◉ {message}\n")))
}


#' rlang::warn() with a yellow warning message with a warning symbol if verbose.
#'
#' @param message (chr) A message to print
#' @template param-verbose
#' @return NULL
#' @export
#' @family helpers
#' @examples
#' \dontrun{
#' wastdr_msg_warn("This is a warning.")
#' }
wastdr_msg_warn <- function(message,
                            verbose = wastdr::get_wastdr_verbose()) {
  if (verbose == FALSE) {
    return(NULL)
  }
  # x <- clisymbols::symbol$warning
  rlang::warn(crayon::yellow(glue::glue("⚠ {message}\n")))
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
  # x <- clisymbols::symbol$cross
  rlang::abort(crayon::red(glue::glue("✖ {message}\n")))
}

# usethis::use_test("wastdr_msg")
