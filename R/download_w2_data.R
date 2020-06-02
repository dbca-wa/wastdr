#' Download Turtle Tagging data from WAMTRAM2.
#'
#' This function requires an installed ODBC driver for MS SQL Server 2012.
#' The database credentials are handled via environment variables.
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
#' @param db_pass The database users's password, detaulf: `Sys.getenv("W2_PW")`.
#' @param db_port The database port, default: `Sys.getenv("W2_PT")`, which
#'   should resolve to a numeric port, e.g. `1234`.
#' @param verbose Whether to print verbose help messages,
#'   default: `wastdr::get_wastdr_verbose()`.
#' @return A named list of sanitised tables from the Turtle Tagging DB:
#'
#'   # Metadata
#'   downloaded_on
#'   w2_tables
#'
#'   # personnel
#'   persons
#'
#'   # Data entry
#'   data_entry_batches
#'   data_entry
#'   data_entry_operators
#'
#'   # Lookups
#'   lookup_beach_positions
#'   lookup_body_parts
#'   lookup_conditions
#'   lookup_damage_causes
#'   lookup_damage_codes
#'   lookup_datum_codes
#'   lookup_egg_count_methods
#'   lookup_id_types
#'   lookup_measurement_types
#'   lookup_pit_tag_states
#'   lookup_sample_tissue_type
#'   lookup_tag_states
#'
#'   # Sites
#'   sites
#'
#'   # Encounters
#'   enc
#'   enc_qa
#'
#'   # Observations
#'   obs_flipper_tags
#'   obs_pit_tags
#'   obs_damages
#'   obs_measurements
#'   obs_samples
#'
#'   # Reconstructed
#'   reconstructed_pit_tags
#'   reconstructed_tags
#'   reconstructed_turtles
#' @export
download_w2_data <- function(ord = c("YmdHMS", "Ymd"),
                             tz = "Australia/Perth",
                             db_drv = Sys.getenv("W2_DRV"),
                             db_srv = Sys.getenv("W2_SRV"),
                             db_name = Sys.getenv("W2_DB"),
                             db_user = Sys.getenv("W2_UN"),
                             db_pass = Sys.getenv("W2_PW"),
                             db_port = Sys.getenv("W2_PT"),
                             verbose = wastdr::get_wastdr_verbose()) {
    # Open a database connection
    if (DBI::dbCanConnect(
        odbc::odbc(),
        Driver   = db_drv,
        Server   = db_srv,
        Database = db_name,
        UID      = db_user,
        PWD      = db_pass,
        Port     = db_port
    ))
        wastdr::wastdr_msg_success("Database credentials verified")
    else
        wastdr_msg_abort("Database credentials invalid, aborting")

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Opening database connection...")
    con <- DBI::dbConnect(
        odbc::odbc(),
        Driver   = db_drv,
        Server   = db_srv,
        Database = db_name,
        UID      = db_user,
        PWD      = db_pass,
        Port     = db_port
    )

    # Extract all relevant tables into a named list.
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Reading tables...")

    # Metadata
    downloaded_on = Sys.time()
    w2_tables = DBI::dbListTables(con)

    # Tables
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Processing Table TRT_ENTRY_BATCHES")
    data_entry_batches = "TRT_ENTRY_BATCHES" %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Processing Table TRT_DATA_ENTRY")
    data_entry = 'TRT_DATA_ENTRY' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Personnel Table TRT_DATA_ENTRY_PERSONS")
    data_entry_operators = 'TRT_DATA_ENTRY_PERSONS' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Sites Table TRT_PLACES")
    sites = 'TRT_PLACES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::rename(
            prefix = location_code,
            name = place_code,
            label = place_name,
            is_rookery = rookery,
            beach_aspect = aspect,
            site_datum = datum_code,
            site_latitude = latitude,
            site_longitude = longitude
        )

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_TAG_STATES")
    tag_states = 'TRT_TAG_STATES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Data Table TRT_PERSONS")
    persons = 'TRT_PERSONS' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::mutate(
            clean_name = paste(first_name, surname) %>%
                stringr::str_replace_all("[<>()*=?]", "") %>% stringr::str_trim(),
            clean_email = email %>% stringr::str_replace("NA", "") %>% stringr::str_trim()
        )

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_ACTIVITIES")
    activities = 'TRT_ACTIVITIES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::rename(
            activity_description = description,
            activity_is_nesting = nesting,
            activity_label = new_code,
            display_this_observation = display_observation
        )

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_BEACH_POSITIONS")
    beach_positions = 'TRT_BEACH_POSITIONS' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::rename(
            beach_position_description = description,
            beach_position_label = new_code
        )

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_CONDITION_CODES")
    conditions = 'TRT_CONDITION_CODES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::rename(condition_label = description)

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_EGG_COUNT_METHODS")
    egg_count_methods = 'TRT_EGG_COUNT_METHODS' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::rename(egg_count_method_code = egg_count_method,
                      egg_count_method_label = description)

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_BODY_PARTS")
    body_parts = 'TRT_BODY_PARTS' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::rename(
            body_part_code = body_part,
            body_part_label = description,
            is_flipper = flipper
        )

    # use native datum conversion instead
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_DATUM_CODES")
    datum_codes = 'TRT_DATUM_CODES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    # Tag types
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_IDENTIFICATION_TYPES")
    id_types = 'TRT_IDENTIFICATION_TYPES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::transmute(id_type_code = identification_type,
                         id_type_label = description)

    # 252k+ records
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Data Table TRT_RECORDED_TAGS")
    recorded_tags = 'TRT_RECORDED_TAGS' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::rename(
            tag_name = tag_id,
            tag_label = other_tag_id,
            attached_on_side = side
        ) %>%
        dplyr::arrange(desc(tag_name))

    # 58k+ inferred turtle identities, reconstructed from encounters.
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Data Table TRT_TURTLES")
    turtles = 'TRT_TURTLES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    # 124k+ Synthesised information about tags,
    # reconstructed from recorded_tags and other tag asset management operations.
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Data Table TRT_TAGS")
    tags = 'TRT_TAGS' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::arrange(desc(tag_id))

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Data Table TRT_SAMPLES")
    samples = 'TRT_SAMPLES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_TISSUE_TYPES")
    sample_tissue_type = 'TRT_TISSUE_TYPES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    # 22k+ PIT tags
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Data Table TRT_PIT_TAGS")
    pit_tags = 'TRT_PIT_TAGS' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    # 70k+ PIT tag encounters
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Table TRT_RECORDED_PIT_TAGS")
    recorded_pit_tags = 'TRT_RECORDED_PIT_TAGS' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_PIT_TAG_STATES")
    pit_tag_states = 'TRT_PIT_TAG_STATES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_MEASUREMENT_TYPES")
    measurement_types = 'TRT_MEASUREMENT_TYPES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::rename(
            measurement_type_code = measurement_type,
            measurement_type_label = description,
            physical_unit = measurement_units
        )

    # 191k+ Morphometric Measurements
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Data Table TRT_MEASUREMENTS")
    measurements = 'TRT_MEASUREMENTS' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names() %>%
        dplyr::rename(
            measurement_type_code = measurement_type
        )


    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_DAMAGE_CODES")
    damage_codes = 'TRT_DAMAGE_CODES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Lookup Table TRT_DAMAGE_CAUSE_CODES")
    damage_causes = 'TRT_DAMAGE_CAUSE_CODES' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    # 38k+ TurtleDamageObservations
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Data Table TRT_DAMAGE")
    damages = 'TRT_DAMAGE' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    # 167k+ AnimalEncounters (raw)
    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Data Table TRT_OBSERVATIONS")
    obs = 'TRT_OBSERVATIONS' %>%
        DBI::dbReadTable(con, .) %>%
        janitor::clean_names()

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Parsing TRT_OBSERVATIONS")
    o = obs %>%
        dplyr::mutate(
            o_date = lubridate::parse_date_time(corrected_date, orders = ord, tz = tz),
            o_time = lubridate::parse_date_time(observation_time, orders = ord, tz = tz),
            observation_datetime_gmt08 = o_date - lubridate::days(1) + lubridate::hours(hour(o_time)) + lubridate::minutes(minute(o_time)),
            observation_datetime_utc = lubridate::with_tz(observation_datetime_gmt08, tz = "UTC")
        ) %>%
        dplyr::select(
            -observation_date,
            -observation_date_old,
            -corrected_date,
            -observation_time,
            -o_date,
            -o_time
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
        dplyr::left_join(sites, by = c("place_code" = "name")) %>%
        dplyr::left_join(turtles, by = "turtle_id") %>%
        dplyr::mutate(
            latitude = ifelse(is.na(latitude), site_latitude, latitude),
            longitude = ifelse(is.na(longitude), site_longitude, longitude)
        )

    # TODO reconstruct empty DD from DMS or UTM or site coords

    encounters = o %>%
        dplyr::filter(!is.na(longitude)) %>%
        dplyr::filter(!is.na(latitude)) %>%
        dplyr::filter(!is.na(observation_datetime_utc)) %>%
        dplyr::arrange(desc(observation_datetime_utc))

    encounters_missing = o %>%
        dplyr::filter(is.na(longitude) |
                          is.na(latitude) | is.na(observation_datetime_utc)) %>%
        dplyr::arrange(desc(observation_datetime_utc))

    if (verbose == TRUE)
        wastdr::wastdr_msg_info("Done, closing DB connection.")
    DBI::dbDisconnect(con)

    if (verbose == TRUE)
        wastdr::wastdr_msg_success("Returning data")
    list(
        # Metadata
        downloaded_on = downloaded_on,
        w2_tables = w2_tables,

        # personnel
        persons = persons,

        # Data entry
        data_entry_batches = data_entry_batches,
        data_entry = data_entry,
        data_entry_operators = data_entry_operators,

        # Lookups
        lookup_beach_positions = beach_positions,
        lookup_body_parts = body_parts,
        lookup_conditions = conditions,
        lookup_damage_causes = damage_causes,
        lookup_damage_codes = damage_codes,
        lookup_datum_codes = datum_codes,
        lookup_egg_count_methods = egg_count_methods,
        lookup_id_types = id_types,
        lookup_measurement_types = measurement_types,
        lookup_pit_tag_states = pit_tag_states,
        lookup_sample_tissue_type = sample_tissue_type,
        lookup_tag_states = tag_states,

        # Sites
        sites = sites,

        # Encounters
        enc = encounters,
        enc_qa = encounters_missing,

        # Observations
        obs_flipper_tags = recorded_tags,
        obs_pit_tags = recorded_pit_tags,
        obs_damages = damages,
        obs_measurements = measurements,
        obs_samples = samples,

        # Reconstructed
        reconstructed_pit_tags = pit_tags,
        reconstructed_tags = tags,
        reconstructed_turtles = turtles
    )
}
