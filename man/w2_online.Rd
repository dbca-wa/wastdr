% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/w2_online.R
\name{w2_online}
\alias{w2_online}
\title{Test whether the Turtle Tagging Database WAMTRAM2 is accessible and online}
\usage{
w2_online(
  db_drv = Sys.getenv("W2_DRV"),
  db_srv = Sys.getenv("W2_SRV"),
  db_name = Sys.getenv("W2_DB"),
  db_user = Sys.getenv("W2_UN"),
  db_pass = Sys.getenv("W2_PW"),
  db_port = Sys.getenv("W2_PT"),
  verbose = wastdr::get_wastdr_verbose(),
  dsn = Sys.getenv("W2_DSN"),
  use_rodbc = Sys.getenv("W2_RODBC", FALSE)
)
}
\arguments{
\item{db_drv}{Database driver, default: \code{Sys.getenv("W2_DRV")} which should
resolve to e.g. \code{"/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so"}.}

\item{db_srv}{Database server, default: \code{Sys.getenv("W2_SRV")}, which should
resolve to a valid server hostname, e.g. \code{"myserver.corporateict.domain"}.}

\item{db_name}{The database name, default: \code{Sys.getenv("W2_DB")}, which should
resolve to a valid database name, e.g. \code{turtle_tagging}.}

\item{db_user}{The read-permitted database user,
default: \code{Sys.getenv("W2_UN")}.}

\item{db_pass}{The database user's password, default: \code{Sys.getenv("W2_PW")}.}

\item{db_port}{The database port, default: \code{Sys.getenv("W2_PT")}, which
should resolve to a numeric port, e.g. \code{1234}.}

\item{verbose}{Whether to show debug messages.
Default: wastdr::get_wastdr_verbose()}

\item{dsn}{The DSN for Windows systems, default: \code{Sys.getenv("W2_DSN")}.}

\item{use_rodbc}{Whether to use the RODBC library (if TRUE, best for Windows
systems), or the odbc/DBI library (if FALSE, default, best for GNU/Linux
systems).}
}
\value{
(lgl) TRUE if WAMTRAM2 is accessible and online, else FALSE.
}
\description{
This function requires an installed ODBC driver for MS SQL Server 2012.
The database credentials are handled via environment variables.
}
\details{
In Windows systems, create a user defined DSN with settings
\itemize{
\item name WAMTRAMPROD
\item server kens-mssql-001-prod.corporateict.domain
\item SQL auth using login ID and password entered by user
\item trust server certificate (this is where odbc falls over)
}

Add to .Renviron:
W2_RODBC=TRUE
W2_DSN="WAMTRAMPROD"
}
\examples{
\dontrun{
# Credentials are set in .Renviron

w2_online()
#> TRUE
#> FALSE
}
}
\seealso{
Other wamtram: 
\code{\link{download_w2_data}()},
\code{\link{map_wamtram}()}
}
\concept{wamtram}
