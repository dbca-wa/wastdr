#' Send a POST request to WAStD's API
#'
#' @param data (JSON) A list of lists (JSON) to post to WAStD.
#' @template param-serializer
#' @template param-auth
#' @template param-verbose
#' @template return-wastd-api-response
#' @importFrom httr add_headers authenticate user_agent POST content
#' @export
#' @examples \dontrun{
#'
#' # One by one
#' gj <- "public:herbie_hbvnames_public" %>% kmi_getFeature
#' props <- purrr::map(gj[["features"]], "properties")
#' wastd_POST(props[[1]], serializer = "names")
#'
#'  # All in batch
#' "public:herbie_hbvnames_public" %>%
#'   kmi_getFeature %>%
#'   wastd_upsert_geojson(serializer = "names", verbose = T)
#' }
wastd_POST <- function(data,
                       serializer,
                       api_url = wastdr::get_wastdr_api_url(),
                       api_token = wastdr::get_wastdr_api_token(),
                       api_un = wastdr::get_wastdr_api_un(),
                       api_pw = wastdr::get_wastdr_api_pw(),
                       verbose=FALSE) {
  . <- NULL
  ua <- httr::user_agent("http://github.com/parksandwildlife/turtle-scripts")
  if (!is.null(api_token)) {
    auth <- httr::add_headers(c(Authorization = api_token))
  } else {
    auth <- httr::authenticate(api_un, api_pw, type = "basic")
  }
  url <- paste0(api_url, serializer, "/")
  if (verbose == TRUE) message("[wastd_POST] url ", url)
  res <- httr::POST(url, auth, ua, encode = "json", body = data) %>% httr::stop_for_status(.)

  if (verbose == TRUE) message("[wastd_POST] status ", res$status)
  structure(
    list(
      features = data,
      serializer = serializer,
      response = res
    ),
    class = "wastd_api_response"
  )
}
