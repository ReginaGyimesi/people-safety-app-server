library(tidyverse)
library(plumber)
library(opendatascot)
library(ukpolice)

# plumber.R

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
  as.numeric(a) + as.numeric(b)
}

# Open data API https://github.com/DataScienceScotland/opendatascot
#* Get recorded crime data structure
#* @get /all-crimes-structure
function() {
  ods_structure("recorded-crime")
}

#* Get recorded crime data structure
#* @get /scot-get-all
function() {
  recorded_crime_clean_la
}

#* Get crime data by local authority
#* @param la Name of local authority
#* @post /scot-crime-by-la
function(la) {
  assign_score_to_la %>%
    filter(area_name == la)
}

#* Get lsoa code by post code
#* @param po Name of post code e.g. SE12SS
#* @post /crime-by-po
function(po) {
  tryCatch({
    searched_lsoa <- lsoa_lookup %>%
      filter(pcd7 == po) %>% 
      pull(lsoa11cd)
    all_aggregated_crime_df %>%
      filter(lsoa_code == searched_lsoa) 
  }, error = function(e) "No data found.")
}

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "http://localhost:19006")
  plumber::forward()
}