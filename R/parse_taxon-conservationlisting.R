#' Parse a \code{wastd_api_response} of \code{taxon-conservationlisting} to tbl_df
#'
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#'   \code{taxon-conservationlisting},
#'   e.g. \code{get_wastd("taxon-conservationlisting")}.
#' @template param-wastd_url
#' @return A \code{tbl_df} with columns:
#' \itemize{
#'   \item id <int> The TSC ID of the Conservation Listing
#'   \item taxon <int> The WACensus NameID of the taxon
#'   \item source <int> The TSC ID for the Source of the Conservation Listing.
#'   \item source_id <chr> The original ID of the source as chr. Most sources
#'         will be an integer, uuid, or any other unique ID.
#'   \item scope <int> The TSC ID for the legal scope of this Conservation
#'         Listing: State of Western Australia (0),
#'         Commonwealth of Austalia (1), International (2), or Action Plan (3).
#'   \item status <int> The TSC ID of the approval status, e.g. listed (80),
#'         de-listed (90), rejected (100), or in stages of approval (0..70).
#'   \item proposed_on <dttm> The date on which this Conservation Listing was
#'         proposed on (GMT+08).
#'   \item effective_from <dttm> The date on which this Conservation Listing was
#'         effective from (GMT+08).
#'   \item effective_to <dttm> The date on which this Conservation Listing was
#'         effective_to (GMT+08).
#'   \item last_reviewed_on <dttm> The date on which this Conservation Listing
#'         was last reviewed on (GMT+08).
#'   \item review_due <dttm> The date on which this Conservation Listing will be
#'         due for reviewed (GMT+08).
#'   \item comments <chr> Any comments. Worth a read!
#'   \item category_cache <chr> A human-readable representation of the
#'         conservation category (or categories).
#'   \item criteria_cache <chr> A human-readable representation of the
#'         conservation criteria.
#'   \item label <chr> An auto-generated label for the Conservation Listing.
#'   \item category <lst> A list if TSC conservation category IDs.
#'   \item criteria <lst> A list if TSC conservation criterion IDs.
#' }
#' @export
#' @import magrittr
parse_taxon_conservationlisting <- function(
                                            wastd_api_response,
                                            wastd_url = wastdr::get_wastd_url()) {
  wastd_api_response$features %>% {
    tibble::tibble(
      id = purrr::map_int(., "id"),
      taxon = purrr::map_int(., "taxon"),
      source = purrr::map_int(., "source"),
      source_id = purrr::map_chr(., "source_id"),
      scope = purrr::map_int(., "scope"),
      status = purrr::map_int(., "status"),
      proposed_on = purrr::map_chr(
        ., "proposed_on",
        .default = NA
      ) %>%
        wastdr::httpdate_as_gmt08(),
      effective_from = purrr::map_chr(
        ., "effective_from",
        .default = NA
      ) %>%
        wastdr::httpdate_as_gmt08(),
      effective_to = purrr::map_chr(
        ., "effective_to",
        .default = NA
      ) %>%
        wastdr::httpdate_as_gmt08(),
      last_reviewed_on = purrr::map_chr(
        ., "last_reviewed_on",
        .default = NA
      ) %>%
        wastdr::httpdate_as_gmt08(),
      review_due = purrr::map_chr(., "review_due", .default = NA) %>%
        wastdr::httpdate_as_gmt08(),
      comments = purrr::map_chr(., "comments", .default = NA),
      category_cache = purrr::map_chr(., "category_cache", .default = NA),
      criteria_cache = purrr::map_chr(., "criteria_cache", .default = NA),
      label = purrr::map_chr(., "label_cache", .default = NA),
      category = purrr::map(., "category", .default = NA) %>% stringr::str_c(),
      criteria = purrr::map(., "criteria", .default = NA) %>% stringr::str_c()
    )
  }
}
