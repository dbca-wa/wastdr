#' Upsert GeoJSON into WAStD API endpoints
#'
#' @param gj_featurecollection (list) A GeoJSON featurecollection as list
#' @template param-serializer
#' @template param-auth
#' @param chunksize (int) The number of features to upload simultaneously, default: 1000.
#' @template param-verbose
#' @importFrom purrr map
#' @export
upsert_geojson <- function(gj_featurecollection,
                           serializer = "names",
                           api_url = wastdr::get_wastdr_api_url(),
                           api_token = wastdr::get_wastdr_api_token(),
                           api_un = wastdr::get_wastdr_api_un(),
                           api_pw = wastdr::get_wastdr_api_pw(),
                           chunksize = 1000,
                           verbose = FALSE) {
  . <- NULL
  if (verbose) message("[upsert_geojson] Updating ", api_url, serializer, "...")
  props <- purrr::map(gj_featurecollection[["features"]], "properties")
  # purrr::map(props, wastd_POST, api_url = api_url) # One by one - very slow. Faster:
  len <- length(props)
  for (i in 0:(len / chunksize)) {
    start <- (i * chunksize) + 1
    end <- min((start + chunksize) - 1, len)
    message("[upsert_geojson] Processing feature ", start, " to ", end)
    props[start:end] %>%
      purrr::map(., purrr::flatten) %>%
      wastd_POST(.,
                 serializer = serializer,
                 api_url = api_url,
                 api_token = api_token,
                 api_un = api_un,
                 api_pw = api_pw,
                 verbose = verbose)
  }
  message("[upsert_geojson] Finished. ", len, " records updated.")
}
