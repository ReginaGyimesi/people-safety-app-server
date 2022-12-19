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

#* Get score by la
#* @param a The first number to add
#* @post /scot-crime-by-la
function(la) {
  assign_score_to_la %>%
    filter(area_name == la)
}

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "http://localhost:19006")
  plumber::forward()
}