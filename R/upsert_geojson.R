upsert_geojson <- function(gj_featurecollection,
                           serializer = "names",
                           api_url = wastdr::get_wastdr_api_url(),
                           chunksize = 1000,
                           verbose = TRUE) {
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
      wastd_POST(., serializer = serializer, api_url = api_url, verbose = verbose)
  }
  message("[upsert_geojson] Finished. ", len, " records updated.")
}
