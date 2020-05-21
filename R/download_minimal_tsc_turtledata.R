#' Download a minimal dataset of turtle observations from TSC
#'
#' @param source The TSC Encounter source, default: "odk".
#' @param year The earliest calendar year to be returned. Default: NULL.
#'   This value, if not NULL, will be used to construct a query parameter
#'   \code{when_year_gte=2019}
#' @export
#' @return A list of tibbles:
#' \itemize{
#' \item users A tibble of user names, roles, and contact details which can be
#'   used to resolve submitted user names to TSC user IDs
#' \item enc A tibble of encounters (source, source ID, QA status) which can be
#'   used to determine which encounters to create / update / skip.
#' \item surveys A tibble of surveys reconstructed from source and year.
#' }
download_minimal_tsc_turtledata <- function(
    source = "odk",
    year = NULL
){
    users <- wastd_GET("users") %>% wastd_parse()

    qry <- list(source = source)
    if (!is.null(year)) source["when__year__gte"] = year

    enc <- wastd_GET("encounters", query = qry) %>%
        wastd_parse() %>%
        dplyr::select(source, source_id, status)

    # TODO build source query from source and year
    surveys <- wastd_GET("surveys") %>% wastd_parse()

    sites <- wastd_GET("sites") %>% wastd_parse()

    list(
        users = NULL,
        enc = enc,
        surveya = surveys,
        sites = sites
    )
}
