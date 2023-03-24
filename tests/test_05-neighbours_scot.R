source("../05-neighbours_scot.R", chdir = TRUE)
library(testthat)

test_that("find_centroid returns the expected output", {
  output  <- slice_head(local_authority_shapes, n=1) %>% 
    find_centroid(local_auth)
  expected_output <- data.frame(local_auth = "Clackmannanshire", lon =  -3.7422, lat = 56.1505) %>% 
    as_tibble()
  expect_equal(output, expected_output,
               check.attributes = FALSE)
})

test_that("find_centroid returns error", {
  output  <- slice_head(local_authority_shapes, n=1) %>% 
    find_centroid(local_auth)
  expected_output <- data.frame(local_auth = "Glasgow City", lon =  -4.2531, lat = 55.8579) %>% 
    as_tibble()
  expect_false(isTRUE(all_equal(output, expected_output)))
})

test_that("find_neighbours returns the expected output", {
  output <- local_authority_shapes %>% 
    find_neighbours(local_auth) %>%
    slice(2:2)
  neighbours <- c("Moray", "Aberdeen City", "Angus", "Highland", "Perth and Kinross")
  expected_output <- data.frame(local_auth = "Aberdeenshire", neighbour = neighbours) %>% 
    group_by_at(1) %>% 
    summarise(neighbour = list(neighbour))
  expect_equal(output, expected_output,
               check.attributes = FALSE)
})

test_that("find_neighbours returns error", {
  output <- local_authority_shapes %>% 
    find_neighbours(local_auth) %>%
    slice(2:2)
  neighbours <- c("Aberdeen City", "Angus", "Highland", "Perth and Kinross")
  expected_output <- data.frame(local_auth = "Aberdeenshire", neighbour = neighbours) %>% 
    group_by_at(1) %>% 
    summarise(neighbour = list(neighbour))
  expect_false(isTRUE(all_equal(output, expected_output)))
})