library(drake)
library(pointblank)
library(gt)

drake::loadd(user_mapping)

#' Turn a string of names into individual Markdown search links to WAStD Users.
#'
#' @param s A string, e.g. "Florian Mayer" or "Flo and Joe".
#' @return A single string of whitespace separated Markdown links to search
#'   WAStD Users.
#' @export
make_search_links <- function(s) {
    parts <- s %>%
        stringr::str_replace_all(",", "") %>%
        stringr::str_replace_all("/", "") %>%
        stringr::str_replace_all(" and ", " ") %>%
        stringr::str_replace_all("&", " ") %>%
        stringr::str_squish() %>%
        stringr::str_split(" ") %>% {
            purrr::map(., function(x)
                '[{x}](https://wastd.dbca.wa.gov.au/admin/users/user/?q={x})' %>%
                    glue::glue()
            )
        } %>%
        unlist() %>%
        paste(collapse = " ")
}

#' Annotate the output of make_user_mapping with Markdown links to WAStD Users.
#'
#' @param user_mapping The output of \code{\link{user_mapping}}
#' @return The annotated user_mapping tibble
#' @export
annotate_user_mapping <- function(user_mapping){
    user_mapping %>%
        dplyr::arrange(-dist, username) %>%
        dplyr::rowwise() %>%
        dplyr::mutate(
            wastd_matched = glue::glue(
                '[{name}](https://wastd.dbca.wa.gov.au/admin/users/user/{pk})'
            ),
            search_wastd = odkc_username %>% make_search_links
        ) %>%
        dplyr::select(
            odkc_username,
            wastd_matched,
            search_wastd,
            dist,
            role,
            pk,
            username,
            name,
            nickname,
            aliases,
            email,
            phone
        ) %>%
        tibble::as_tibble()
}

# # Create user agent
# a <- user_mapping %>%
#     pointblank::create_agent() %>%
#     pointblank::col_vals_lt("dist", 0.10) %>%
#     interrogate()
#
# # Display high level report
# a
#
# # Extract failed rows as raw HTML table
# dissimilar_mappings <- a %>%
#     pointblank::get_data_extracts() %>%
#     magrittr::extract2(1) %>%
#     gt::gt() %>%
#     gt::fmt_markdown(columns = TRUE) %>%
#     gt::as_raw_html()
#
# # Preview QA report email
# a %>% pointblank::email_preview(
#     msg_body = paste(
#         pointblank::stock_msg_body(),
#         "<h3>Please review these mappings</h3>",
#         "<p>For each incorrectly mapped odkc_username,",
#         " add that odkc_username to the correct WAStD user's ",
#         "'alias'.</p>",
#         dissimilar_mappings
#     )
# )

