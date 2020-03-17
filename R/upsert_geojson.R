#' Upsert GeoJSON into WAStD API endpoints
#'
#' @param gj_featurecollection (list) A GeoJSON featurecollection as list
#' @template param-serializer
#' @param chunksize (int) The number of features to upload simultaneously,
#'   default: 1000.
#' @template param-auth
#' @template param-verbose
#' @export
#' @family wacensus
upsert_geojson <- function(gj_featurecollection,
                           serializer = "names",
                           chunksize = 1000,
                           api_url = wastdr::get_wastdr_api_url(),
                           api_token = wastdr::get_wastdr_api_token(),
                           api_un = wastdr::get_wastdr_api_un(),
                           api_pw = wastdr::get_wastdr_api_pw(),
                           verbose = get_wastdr_verbose()) {
  if (verbose) {
    wastdr_msg_info(glue::glue("Posting to {api_url}{serializer}..."))
  }
  props <- purrr::map(gj_featurecollection[["features"]], "properties")
  # purrr::map(props, wastd_POST, api_url = api_url)
  # One by one - very slow. Faster:
  len <- length(props)
  for (i in 0:(len / chunksize)) {
    start <- (i * chunksize) + 1
    end <- min((start + chunksize) - 1, len)
    if (verbose) {
      wastdr_msg_info(glue::glue("Processing feature {start} to {end}..."))
    }
    props[start:end] %>%
      purrr::map(., purrr::flatten) %>%
      wastd_POST(.,
        serializer = serializer,
        api_url = api_url,
        api_token = api_token,
        api_un = api_un,
        api_pw = api_pw,
        verbose = verbose
      )
  }
  if (verbose) {
    wastdr_msg_success(glue::glue("Finished. {len} records updated."))
  }
}

# usethis::use_test("upsert_geojson")
