test_that("nesting_success_per_area_day_species works", {
    data(wastd_data)
    x <- wastd_data %>% nesting_success_per_area_day_species()

    cols <- c("area_name", "turtle_date", "species", "emergences",
              "nesting_present", "nesting_unsure", "nesting_absent",
              "nesting_success_optimistic" ,
              "nesting_success_pessimistic")
    expect_equal(names(x), cols)
})
