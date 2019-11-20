#' @export
wastd_parse <- function(wastd_api_response, payload = "features"){
    wastd_api_response %>%
        magrittr::extract2(payload) %>%
        tibble::tibble() %>%
        tidyr::unnest_wider(".")
}
