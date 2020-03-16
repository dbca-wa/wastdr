#' @param data A dataframe with column "disturbance_cause", e.g. the ouput of
#'   \code{
#'   \link{wastd_GET}("turtle-nest-disturbance-observations") %>%
#'   \link{parse_encounterobservations}()
#'   } or \code{data("wastd_data"); wastd_data$nest_dist}
