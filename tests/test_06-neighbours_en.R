pacman::p_load("st", "sf")
source("../06-neighbours_en.R")
library(testthat)
sf_use_s2(FALSE)

test_that("find_centroid returns the expected output", {
  output  <- slice_head(lsoa_shapes, n=1) %>% 
    find_centroid(lsoa_name) 
  expected_output <- data.frame(local_auth = "City of London 001A", lon = -0.0968, lat = 51.518) %>% 
    as_tibble()
  expect_equal(output, expected_output,
               check.attributes = FALSE)
})

test_that("find_centroid returns error", {
  output  <- slice_head(lsoa_shapes, n=1) %>% 
    find_centroid(lsoa_name)
  expected_output <- data.frame(local_auth = "City of London 001B", lon = -0.0926, lat = 51.5182) %>% 
    as_tibble()
  expect_false(isTRUE(all_equal(output, expected_output)))
})

test_that("find_neighbours returns the expected output", {
  output <- lsoa_shapes %>% 
    find_neighbours(lsoa_name) %>% 
    filter(lsoa_name == "City of London 001B")
  neighbours <- c("City of London 001A", "City of London 001C", "Islington 023D", "City of London 001F")
  expected_output <- data.frame(local_auth = "City of London 001B", neighbour = neighbours) %>% 
    group_by_at(1) %>% 
    summarise(neighbour = list(neighbour))
  expect_equal(output, expected_output,
               check.attributes = FALSE)
})

test_that("find_neighbours returns error", {
  output <- local_authority_shapes %>% 
    find_neighbours(local_auth) %>%
    slice(2:2)
  neighbours <- c("City of London 001C", "Islington 023D", "City of London 001F")
  expected_output <- data.frame(local_auth = "City of London 001B", neighbour = neighbours) %>% 
    group_by_at(1) %>% 
    summarise(neighbour = list(neighbour))
  expect_false(isTRUE(all_equal(output, expected_output)))
})