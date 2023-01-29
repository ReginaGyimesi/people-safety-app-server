#* Get Scottish crime data by local authority.
#* @param la Name of local authority e.g Glasgow
#* @post /scot-crime-by-la
function(la) {
  tryCatch({
  scottish_recorded_crime_clean_df %>%
    filter(area_name == la)
  }, error = function(e) "No data found for local authority.")
}

#* Filter LSOA code by post code and return English crime data
#* @param po Name of post code e.g. SE12SS
#* @post /en-crime-by-po
function(po) {
  tryCatch({
    searched_lsoa <- lsoa_lookup %>%
      filter(pcd7 == po) %>% 
      pull(lsoa11cd)
    english_recorded_crime_clean_df %>%
      filter(lsoa_code == searched_lsoa) 
  }, error = function(e) "No data found for post code.")
}

#* Get local authority neighbouring areas, and respective longitudes and latitudes
#* @param la Name of local authority e.g. Glasgow
#* @post /scot-get-neighbouring-areas
function(la) {
  tryCatch({
    scottish_local_neighbour_df %>%
      filter(local_auth == la) 
  }, error = function(e) "No data found for local authority.")
}

#* Get postcode neighbouring areas, and respective longitudes and latitudes
#* @param po Name of post code e.g. SE12SS
#* @post /en-get-neighbouring-areas
function(po) {
  tryCatch({
    searched_lsoa <- lsoa_lookup %>%
      filter(pcd7 == po) %>% 
      pull(lsoa11cd)
    english_local_neighbour_df %>%
      filter(lsoa_code == searched_lsoa) 
  }, error = function(e) "No data found for post code.")
}

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "http://localhost:19006")
  plumber::forward()
}