#' A wrapper for `tidyr::unnest_wider`
#'
#' This function saves repetition by currying tidyr::unnest_wider with default
#' parameters `names_repair = "universal", names_sep = "_"`.
#' @param data The data frame to be unnested.
#' @param col The column name to be unnested as string.
#' @return The data frame `data` with column `col` replaced by its unnested
#'   components.
#' @export
tun <- function(data, col) {
  if (col %in% colnames(data)) {
    tidyr::unnest_wider(
      data,
      col,
      names_repair = "universal",
      names_sep = "_"
    )
  } else {
    data
  }
}
