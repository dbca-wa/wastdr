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
  "Posting to {api_url}{serializer}..." %>%
    glue::glue() %>%
    wastdr_msg_info(verbose = verbose)
  props <- purrr::map(gj_featurecollection[["features"]], "properties")
  # purrr::map(props, wastd_POST, api_url = api_url)
  # One by one - very slow. Faster:
  len <- length(props)
  for (i in 0:(len / chunksize)) {
    start <- (i * chunksize) + 1
    end <- min((start + chunksize) - 1, len)
    "Processing feature {start} to {end}..." %>%
      glue::glue() %>%
      wastdr_msg_info(verbose = verbose)
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
  "Finished. {len} records updated." %>%
    glue::glue() %>%
    wastdr_msg_info(verbose = verbose)
}

# usethis::use_test("upsert_geojson")
