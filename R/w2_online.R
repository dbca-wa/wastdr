#' Test whether the Turtle Tagging Database WAMTRAM2 is accessible and online
#'
#' This function requires an installed ODBC driver for MS SQL Server 2012.
#' The database credentials are handled via environment variables.
#'
#' In Windows systems, create a user defined DSN with settings
#'
#' * name WAMTRAMPROD
#' * server kens-mssql-001-prod.corporateict.domain
#' * SQL auth using login ID and password entered by user
#' * trust server certificate (this is where odbc falls over)
#'
#' Add to .Renviron:
#' W2_RODBC=TRUE
#' W2_DSN="WAMTRAMPROD"
#'
#' @param db_drv Database driver, default: `Sys.getenv("W2_DRV")` which should
#'   resolve to e.g. `"/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so"`.
#' @param db_srv Database server, default: `Sys.getenv("W2_SRV")`, which should
#'   resolve to a valid server hostname, e.g. `"myserver.corporateict.domain"`.
#' @param db_name The database name, default: `Sys.getenv("W2_DB")`, which should
#'   resolve to a valid database name, e.g. `turtle_tagging`.
#' @param db_user The read-permitted database user,
#'   default: `Sys.getenv("W2_UN")`.
#' @param db_pass The database user's password, default: `Sys.getenv("W2_PW")`.
#' @param db_port The database port, default: `Sys.getenv("W2_PT")`, which
#'   should resolve to a numeric port, e.g. `1234`.
#' @param dsn The DSN for Windows systems, default: `Sys.getenv("W2_DSN")`.
#' @param use_rodbc Whether to use the RODBC library (if TRUE, best for Windows
#'   systems), or the odbc/DBI library (if FALSE, default, best for GNU/Linux
#'   systems).
#' @template param-verbose
#' @return (lgl) TRUE if WAMTRAM2 is accessible and online, else FALSE.
#' @export
#' @examples
#' \dontrun{
#' # Credentials are set in .Renviron
#'
#' w2_online()
#' #> TRUE
#' #> FALSE
#' }
#' @family wamtram
w2_online <- function(db_drv = Sys.getenv("W2_DRV"),
                      db_srv = Sys.getenv("W2_SRV"),
                      db_name = Sys.getenv("W2_DB"),
                      db_user = Sys.getenv("W2_UN"),
                      db_pass = Sys.getenv("W2_PW"),
                      db_port = Sys.getenv("W2_PT"),
                      verbose = wastdr::get_wastdr_verbose(),
                      dsn = Sys.getenv("W2_DSN"),
                      use_rodbc = Sys.getenv("W2_RODBC", FALSE)) {
  wastdr_msg_info("Testing WAMTRAM2 database connection...")
  can_connect <- FALSE

  # Windows / RODBC ---------------------------------------------------------#
  # nocov start
  if (use_rodbc == TRUE) {
    con <- RODBC::odbcConnect(dsn, uid = db_user, pwd = db_pass)
    if (con == TRUE) {
      wastdr::wastdr_msg_success("Database connection successful")
      RODBC::odbcCloseAll()
      can_connect <- TRUE
    } else {
      "Database connection failed with reason:\n{attr(con, \"reason\")}" %>%
        glue::glue() %>%
        wastdr_msg_info()
    }
  } else {
    # Linux/DBI ---------------------------------------------------------------#
    con <- DBI::dbCanConnect(
      odbc::odbc(),
      Driver   = db_drv,
      Server   = db_srv,
      Database = db_name,
      UID      = db_user,
      PWD      = db_pass,
      Port     = db_port
    )

    if (con == TRUE) {
      wastdr::wastdr_msg_success("Database connection successful")
      can_connect <- TRUE
    } else {
      "Database connection failed" %>% wastdr_msg_info()
    }
  }

  can_connect
}


# use_test("w2_online")  # nolint
