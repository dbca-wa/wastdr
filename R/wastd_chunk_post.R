#' POST data to a WAStD API serializer in chunks
#'
#' @param data Data to post to the serializer
#' @param serializer A WAStD API serializer, e.g. "encounters"
#' @param query An optional query for \code{\link{wastd_POST}},
#'   default: `list()`.
#' @param chunksize The number of records to post at a time, default: 1000.
#' @param encode The parameter \code{encode} for \code{link{httr::POST}},
#'   default: "json".
#'   Other options: \code{c("multipart", "form", "json", "raw")}.
#' @template param-tokenauth
#' @template param-verbose
#'
#' @return The `wastd_api_response` of the last batch of data.
#' @export
#' @family api
#'
#' @examples
#' \dontrun{
#' # ODKC data as WAStD data, chunk_post
#' }
wastd_chunk_post <- function(data,
                             serializer,
                             query = list(),
                             chunksize = 1000,
                             encode = "json",
                             api_url = wastdr::get_wastdr_api_url(),
                             api_token = wastdr::get_wastdr_api_token(),
                             verbose = wastdr::get_wastdr_verbose()) {
  "[chunk_post][{Sys.time()}] Updating {api_url}{serializer}..." %>%
    glue::glue() %>%
    wastdr::wastdr_msg_info(verbose = verbose)

  len <- nrow(data)
  res <- NULL
  for (i in seq_len(ceiling(len / chunksize))) {
    start <- (i - 1) * chunksize + 1
    end <- min(start + chunksize - 1, len)

    "[chunk_post][{Sys.time()}][{i}] Processing feature {start} to {end}" %>%
      glue::glue() %>%
      wastdr::wastdr_msg_info(verbose = verbose)

    res <- data[start:end, ] %>%
      wastdr::wastd_POST(.,
        serializer = serializer,
        query = query,
        encode = encode,
        api_url = api_url,
        api_token = api_token,
        verbose = verbose
      )
  }

  "[chunk_post][{Sys.time()}] Finished, {len} records created/updated." %>%
    glue::glue() %>%
    wastdr::wastdr_msg_info(verbose = verbose)
  res
}
