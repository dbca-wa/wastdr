#' Post a one record to a WAStD / TSC API endpoint
#'
#' \lifecycle{maturing}
#'
#' @param data_row A row of a data tibble with columns equal to the serializer's
#'   fields.
#' @template param-serializer
#' @template param-auth
#' @template param-verbose
#' @return The \code{wastd_api_response} from \code{\link{wastd_POST}}.
#' @family("api")
#' @export
wastd_post_one <- function(data_row,
                           serializer,
                           api_url = wastdr::get_wastdr_api_url(),
                           api_token = wastdr::get_wastdr_api_token(),
                           api_un = wastdr::get_wastdr_api_un(),
                           api_pw = wastdr::get_wastdr_api_pw(),
                           verbose = FALSE) {
  data_row %>%
    as.list() %>%
    wastdr::wastd_POST(
      serializer = serializer,
      api_url = api_url,
      api_token = api_token,
      api_un = api_un,
      api_pw = api_pw,
      verbose = verbose
    )
}

# usethis::use_test("wastd_post_one")
