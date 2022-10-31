#' Read a table from a SQL connection using either RODBC or DBI
#'
#' @param connection A database connection as returned by RODBC or DBI
#' @param table_name The table to fetch all records for
#' @param rodbc Whether to use RODBC (if TRUE) or DBI (if FALSE, default)
#' @export
#' @family helpers
read_table <- function(connection, table_name, rodbc = FALSE) {
  if (rodbc == TRUE) {
    RODBC::sqlFetch(connection, table_name)
  } else {
    DBI::dbReadTable(connection, table_name)
  }
}

#' Download Turtle Tagging data from WAMTRAM2.
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
#' @param ord Lubridate orders, default: `c("YmdHMS", "Ymd")`.
#' @param tz Timezone, default: `"Australia/Perth"`.
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
#' @param save If supplied, the filepath to save the data object to.
#' @param compress The saveRDS compression parameter, default: "xz".
#'   Set to FALSE for faster writes and reads but larger filesize.
#' @return A structure of class "wamtram_data" containing a named list of
#'   sanitised tables from the Turtle Tagging DB:
#'
#'   * Metadata:
#'     * downloaded_on
#'     * w2_tables
#'   * Personnel:
#'     * persons
#'   * Data entry:
#'     * data_entry_batches "TRT_ENTRY_BATCHES"
#'     * data_entry
#'     * data_entry_operators
#'   * Lookups:
#'     * lookup_beach_positions
#'     * lookup_body_parts
#'     * lookup_conditions
#'     * lookup_damage_causes
#'     * lookup_damage_codes
#'     * lookup_datum_codes
#'     * lookup_egg_count_methods
#'     * lookup_id_types
#'     * lookup_measurement_types
#'     * lookup_pit_tag_states
#'     * lookup_sample_tissue_type
#'     * lookup_tag_states
#'   * Places:
#'     * sites
#'   * Encounters:
#'     * enc
#'       * location_code: the original rookery (where first encountered)
#'       * place_code: the place of the encounter (where currently found)
#'     * enc_qa
#'   * Observations:
#'     * obs_flipper_tags
#'     * obs_pit_tags
#'     * obs_damages
#'     * obs_measurements
#'     * obs_samples
#'   * Reconstructed:
#'     * reconstructed_pit_tags
#'     * reconstructed_tags
#'     * reconstructed_turtles
#' @export
#' @examples
#' \dontrun{
#' # Credentials are set in .Renviron
#'
#' wamtram_data <- download_w2_data()
#'
#'
#' # develop:
#' ord <- c("YmdHMS", "Ymd")
#' tz <- "Australia/Perth"
#' verbose <- wastdr::get_wastdr_verbose()
#'
#' con <- DBI::dbConnect(
#'   odbc::odbc(),
#'   Driver   = Sys.getenv("W2_DRV"),
#'   Server   = Sys.getenv("W2_SRV"),
#'   Database = Sys.getenv("W2_DB"),
#'   UID      = Sys.getenv("W2_UN"),
#'   PWD      = Sys.getenv("W2_PW"),
#'   Port     = Sys.getenv("W2_PT")
#' )
#' }
#' @family wamtram
download_w2_data <- function(ord = c("YmdHMS", "Ymd"),
                             tz = "Australia/Perth",
                             db_drv = Sys.getenv("W2_DRV"),
                             db_srv = Sys.getenv("W2_SRV"),
                             db_name = Sys.getenv("W2_DB"),
                             db_user = Sys.getenv("W2_UN"),
                             db_pass = Sys.getenv("W2_PW"),
                             db_port = Sys.getenv("W2_PT"),
                             verbose = wastdr::get_wastdr_verbose(),
                             dsn = Sys.getenv("W2_DSN"),
                             use_rodbc = Sys.getenv("W2_RODBC", FALSE),
                             save = NULL,
                             compress = "xz") {
  wastdr_msg_info("Opening database connection...")

  # Windows / RODBC ---------------------------------------------------------#
  # nocov start
  if (use_rodbc == TRUE) {
    con <- RODBC::odbcConnect(dsn, uid = db_user, pwd = db_pass)
    if (con == TRUE) {
      wastdr::wastdr_msg_success("Database connection successful")
    } else {
      "Database connection failed with reason:\n{attr(con, \"reason\")}" %>%
        glue::glue() %>%
        wastdr_msg_abort()
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
    } else {
      "Database connection failed" %>% wastdr_msg_abort()
    }

    con <- DBI::dbConnect(
      odbc::odbc(),
      Driver   = db_drv,
      Server   = db_srv,
      Database = db_name,
      UID      = db_user,
      PWD      = db_pass,
      Port     = db_port
    )
  }
  # The open database connection is `con` -----------------------------------#

  # Extract all relevant tables into a named list.
  wastdr_msg_info("Reading tables...")

  # Metadata
  downloaded_on <- Sys.time()
  w2_tables <- ifelse(
    use_rodbc == TRUE,
    RODBC::sqlTables(con, catalog = NULL, schema = TRUE),
    DBI::dbListTables(con)
  )

  # Tables
  wastdr_msg_info("Processing Table TRT_ENTRY_BATCHES")
  data_entry_batches <- "TRT_ENTRY_BATCHES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  wastdr_msg_info("Processing Table TRT_DATA_ENTRY")
  data_entry <- "TRT_DATA_ENTRY" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  wastdr_msg_info("Personnel Table TRT_DATA_ENTRY_PERSONS")
  data_entry_operators <- "TRT_DATA_ENTRY_PERSONS" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  wastdr_msg_info("Sites Table TRT_PLACES")
  sites <- "TRT_PLACES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::rename(
      prefix = location_code,
      code = place_code,
      label = place_name,
      is_rookery = rookery,
      beach_approach = beach_approach,
      beach_aspect = aspect,
      site_datum = datum_code,
      site_latitude = latitude,
      site_longitude = longitude,
      description = comments
    )

  wastdr_msg_info("Lookup Table TRT_TAG_STATES")
  tag_states <- "TRT_TAG_STATES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  wastdr_msg_info("Data Table TRT_PERSONS")
  persons <- "TRT_PERSONS" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::mutate(
      clean_name = paste(first_name, surname) %>%
        stringr::str_replace_all("[<>()*=?]", "") %>%
        stringr::str_trim(),
      clean_email = email %>%
        stringr::str_replace("NA", "") %>%
        stringr::str_trim()
    )

  wastdr_msg_info("Lookup Table TRT_ACTIVITIES")
  activities <- "TRT_ACTIVITIES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::rename(
      activity_description = description,
      activity_is_nesting = nesting,
      activity_label = new_code,
      display_this_observation = display_observation
    )

  wastdr_msg_info("Lookup Table TRT_BEACH_POSITIONS")
  beach_positions <- "TRT_BEACH_POSITIONS" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::rename(
      beach_position_description = description,
      beach_position_label = new_code
    )

  wastdr_msg_info("Lookup Table TRT_BODY_PARTS")
  body_parts <- "TRT_BODY_PARTS" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::rename(
      body_part_code = body_part,
      body_part_label = description,
      is_flipper = flipper
    )

  wastdr_msg_info("Lookup Table TRT_CAUSE_OF_DEATH")
  cause_of_death <- "TRT_CAUSE_OF_DEATH" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()
  # %>% dplyr::rename(code = cause_of_death)

  wastdr_msg_info("Lookup Table TRT_CONDITION_CODES")
  conditions <- "TRT_CONDITION_CODES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::rename(condition_label = description)

  wastdr_msg_info("Lookup Table TRT_EGG_COUNT_METHODS")
  egg_count_methods <- "TRT_EGG_COUNT_METHODS" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::rename(
      egg_count_method_code = egg_count_method,
      egg_count_method_label = description
    )

  # use native datum conversion instead
  wastdr_msg_info("Lookup Table TRT_DATUM_CODES")
  datum_codes <- "TRT_DATUM_CODES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  # Tag types
  wastdr_msg_info("Lookup Table TRT_IDENTIFICATION_TYPES")
  id_types <- "TRT_IDENTIFICATION_TYPES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::transmute(
      id_type_code = identification_type,
      id_type_label = description
    )

  # 260k+ records
  wastdr_msg_info("Data Table TRT_RECORDED_TAGS")
  recorded_tags <- "TRT_RECORDED_TAGS" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::rename(
      tag_name = tag_id,
      tag_label = other_tag_id,
      attached_on_side = side
    ) %>%
    dplyr::arrange(desc(tag_name))

  # 60k+ inferred turtle identities, reconstructed from encounters.
  wastdr_msg_info("Data Table TRT_TURTLES")
  turtles <- "TRT_TURTLES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  # 127k+ Synthesised information about tags,
  # reconstructed from recorded_tags and other tag asset management operations.
  wastdr_msg_info("Data Table TRT_TAGS")
  tags <- "TRT_TAGS" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::arrange(desc(tag_id))

  wastdr_msg_info("Data Table TRT_SAMPLES")
  samples <- "TRT_SAMPLES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  wastdr_msg_info("Lookup Table TRT_TISSUE_TYPES")
  sample_tissue_type <- "TRT_TISSUE_TYPES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  # 22k+ PIT tags
  wastdr_msg_info("Data Table TRT_PIT_TAGS")
  pit_tags <- "TRT_PIT_TAGS" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  # 70k+ PIT tag encounters
  wastdr_msg_info("Table TRT_RECORDED_PIT_TAGS")
  recorded_pit_tags <- "TRT_RECORDED_PIT_TAGS" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  wastdr_msg_info("Lookup Table TRT_PIT_TAG_STATES")
  pit_tag_states <- "TRT_PIT_TAG_STATES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  wastdr_msg_info("Lookup Table TRT_MEASUREMENT_TYPES")
  measurement_types <- "TRT_MEASUREMENT_TYPES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::rename(
      measurement_type_code = measurement_type,
      measurement_type_label = description,
      physical_unit = measurement_units
    )

  # 191k+ Morphometric Measurements
  wastdr_msg_info("Data Table TRT_MEASUREMENTS")
  measurements <- "TRT_MEASUREMENTS" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names() %>%
    dplyr::rename(
      measurement_type_code = measurement_type
    )


  wastdr_msg_info("Lookup Table TRT_DAMAGE_CODES")
  damage_codes <- "TRT_DAMAGE_CODES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  wastdr_msg_info("Lookup Table TRT_DAMAGE_CAUSE_CODES")
  damage_causes <- "TRT_DAMAGE_CAUSE_CODES" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  # 38k+ TurtleDamageObservations
  wastdr_msg_info("Data Table TRT_DAMAGE")
  damages <- "TRT_DAMAGE" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  wastdr_msg_info("Data Table TRT_IDENTIFICATION")
  identifications <- "TRT_IDENTIFICATION" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  # 175k+ AnimalEncounters (raw)
  wastdr_msg_info("Data Table TRT_OBSERVATIONS")
  obs <- "TRT_OBSERVATIONS" %>%
    read_table(con, ., rodbc = use_rodbc) %>%
    janitor::clean_names()

  # Close DB connection
  if (use_rodbc == TRUE) {
    RODBC::odbcCloseAll()
  } else {
    DBI::dbDisconnect(con)
  }

  # Reconstructed turtles without duplicated attributes
  turtles_min <- turtles %>%
    dplyr::select(
      -entered_by, -entry_batch_id, -date_entered
    ) %>%
    dplyr::rename(turtle_comments = comments)

  wastdr_msg_info("Parsing TRT_OBSERVATIONS")
  # TODO date_convention "C" calendar date, "E" evening date = turtle date
  # Does date_convention affect o_date?
  o <- obs %>%
    dplyr::mutate(
      o_date = lubridate::parse_date_time(corrected_date, orders = ord, tz = tz),
      o_time = observation_time %>%
        lubridate::parse_date_time(orders = ord, tz = tz) %>%
        tidyr::replace_na(lubridate::ymd_hms("2000-01-01T00:00:00+08")),
      observation_datetime_gmt08 = o_date +
        lubridate::hours(lubridate::hour(o_time)) +
        lubridate::minutes(lubridate::minute(o_time)),
      observation_datetime_utc = lubridate::with_tz(observation_datetime_gmt08, tz = "UTC"),
      longitude_dd = longitude,
      latitude_dd = latitude,
      latitude_from_dms = latitude_degrees + latitude_minutes / 60 + latitude_seconds / 3600,
      longitude_from_dms = longitude_degrees + longitude_minutes / 60 + longitude_seconds / 3600
      # TODO lon lat from E/N/datum_code/zone
    ) %>%
    dplyr::select(
      -observation_date,
      -observation_date_old,
      -corrected_date,
      -observation_time
      # -o_date,
      # -o_time
    ) %>%
    dplyr::left_join(activities, by = "activity_code") %>%
    # left_join(person_names, by=c("MEASURER_PERSON_ID" = "PERSON_ID")) %>%
    # rename(measured_by=name) %>%
    # left_join(person_names, by=c("MEASURER_REPORTER_PERSON_ID" = "PERSON_ID")) %>%
    # rename(measurements_reported_by=name) %>%
    # left_join(person_names, by=c("TAGGER_PERSON_ID" = "PERSON_ID")) %>%
    # rename(tagged_by=name) %>%
    # left_join(person_names, by=c("REPORTER_PERSON_ID" = "PERSON_ID")) %>%
    # rename(reported_by=name) %>%
    #
    #
    dplyr::left_join(sites, by = c("place_code" = "code")) %>%
    dplyr::left_join(turtles_min, by = "turtle_id") %>%
    dplyr::mutate(
      latitude = dplyr::case_when(
        !is.na(latitude_dd) ~ latitude_dd,
        !is.na(latitude_from_dms) ~ latitude_from_dms,
        TRUE ~ site_latitude
      ),
      longitude = dplyr::case_when(
        !is.na(longitude_dd) ~ longitude_dd,
        !is.na(longitude_from_dms) ~ longitude_from_dms,
        TRUE ~ site_longitude
      )
    )

  encounters <- o %>%
    dplyr::filter(
      !is.na(longitude),
      !is.na(latitude),
      !is.na(observation_datetime_utc)
    ) %>%
    wastdr::add_dates("observation_datetime_utc", parse_date = FALSE) %>%
    dplyr::arrange(desc(observation_datetime_utc))

  encounters_missing <- o %>%
    dplyr::filter(
      is.na(longitude) |
        is.na(latitude) |
        is.na(observation_datetime_utc)
    )

  wastdr_msg_info("Done, closing DB connection.")

  wastdr_msg_success("Returning data")
  wamtram_data <- structure(
    # [41] "TRT_NESTING_SEASON" "TRT_NESTING"  "TRT_DEFAULT" "TRT_YES_NO"
    # [61] "TRV_INTERSEASON_MIGRATION"
    # [63] "TRV_OBSERVATION_SUMMARY" "TRT_OBSERVATIONS"  "View_1"
    list(
      # Metadata
      downloaded_on = downloaded_on,
      w2_tables = w2_tables,
      # trt_nesting = rookeries > attribute on sites
      # trt_nesting_season > lookup for FY

      # personnel
      persons = persons, # TRT_PERSONS

      # TRT_LOCATIONS
      # TRT_PLACES

      # Data entry and QA
      # TRT_DATA_CHANGED TODO
      # TRT_DATA_ENTRY_EXCEPTIONS TODO
      data_entry_batches = data_entry_batches, # TRT_ENTRY_BATCHES
      data_entry = data_entry, # TRT_DATA_ENTRY
      data_entry_operators = data_entry_operators, # TRT_DATA_ENTRY_PERSONS

      # Lookups
      lookup_activities = activities, # TRT_ACTIVITIES
      lookup_beach_positions = beach_positions, # TRT_BEACH_POSITIONS
      lookup_body_parts = body_parts, # TRT_BODY_PARTS
      lookup_cause_of_death = cause_of_death, # TRT_CAUSE_OF_DEATH
      lookup_conditions = conditions, # TRT_CONDITION_CODES
      # TRT_DAMAGE_CAUSE is empty
      lookup_damage_causes = damage_causes, # TRT_DAMAGE_CAUSE_CODES
      lookup_damage_codes = damage_codes, # TRT_DAMAGE_CODES
      lookup_datum_codes = datum_codes, # TRT_DATUM_CODES
      lookup_egg_count_methods = egg_count_methods, # TRT_EGG_COUNT_METHODS
      lookup_id_types = id_types, # TRT_IDENTIFICATION_TYPES
      lookup_measurement_types = measurement_types, # TRT_MEASUREMENT_TYPES
      lookup_pit_tag_states = pit_tag_states, # TRT_PIT_TAG_STATES
      # pit tag status TODO
      lookup_sample_tissue_type = sample_tissue_type, # TRT_TISSUE_TYPES
      lookup_tag_states = tag_states, # TRT_TAG_STATES
      # TRT_TURTLE_STATUS TODO

      # Sites
      sites = sites,

      # Encounters
      enc = encounters,
      enc_qa = encounters_missing,

      # Observations
      obs_flipper_tags = recorded_tags, # TRT_RECORDED_TAGS
      obs_pit_tags = recorded_pit_tags, # TRT_RECORDED_PIT_TAGS
      obs_damages = damages, # TRT_DAMAGE
      obs_measurements = measurements, # TRT_MEASUREMENTS
      obs_samples = samples, # TRT_SAMPLES
      identifications = identifications, # TRT_IDENTIFICATION
      # TRT_SIGHTING is empty
      # TRT_RECORDED_IDENTIFICATION

      # TRT_TAG_ORDERS
      # TRT_TAG_STATUS
      # TRT_TURTLE_STATUS
      # TRT_SPECIES

      # "TRT_DOCUMENT_TYPES" "TRT_DOCUMENTS"

      # Reconstructed
      reconstructed_pit_tags = pit_tags, # TRT_PIT_TAGS
      reconstructed_tags = tags, # TRT_TAGS
      reconstructed_turtles = turtles # TRT_TURTLES
    ),
    class = "wamtram_data"
  )

  if (!is.null(save)) {
    "Saving WAMTRAM data to {save}..." %>%
      glue::glue() %>%
      wastdr::wastdr_msg_success()
    saveRDS(wamtram_data, file = save, compress = compress)
    "Done. Open the saved file with\nw2_data <- readRds({save})" %>%
      glue::glue() %>%
      wastdr::wastdr_msg_success()
  }

  wamtram_data
  # nocov end
}

#' @title S3 print method for 'wamtram_data'.
#' @description Prints a short representation of data returned by
#' \code{\link{download_w2_data}}.
#' @param x An object of class `wamtram_data` as returned by
#'   \code{\link{download_w2_data}}.
#' @param ... Extra parameters for `print`
#' @export
#' @family included
print.wamtram_data <- function(x, ...) {
  print(
    glue::glue(
      "<WAMTRAM Turtle Tagging Data> accessed on {x$downloaded_on}\n",
      "Turtle Obs (acceptable): {nrow(x$enc)}\n",
      "Turtle Obs (need QA):    {nrow(x$enc_qa)}\n",
      "  Flipper tag obs:       {nrow(x$obs_flipper_tags)}\n",
      "  PIT tag obs:           {nrow(x$obs_pit_tags)}\n",
      "  Damage obs:            {nrow(x$obs_damages)}\n",
      "  Morphometric obs:      {nrow(x$obs_measurements)}\n",
      "  Samples:               {nrow(x$obs_samples)}\n",
      "Persons:                 {nrow(x$persons)}\n",
      "Sites:                   {nrow(x$sites)}\n",
      "Reconstructed turtles:   {nrow(x$reconstructed_turtles)}\n",
      "Rec'd flipper tags:      {nrow(x$reconstructed_tags)}\n",
      "Rec'd PIT tags:          {nrow(x$reconstructed_pit_tags)}\n",
      "Turtle identifications:  {nrow(x$identifications)}\n"
    )
  )
  invisible(x)
}

# usethis::use_test("download_w2_data")  # nolint
