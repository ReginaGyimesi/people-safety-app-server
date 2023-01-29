# Read in all crime data for England for 2022.
file_names <- list.files("data/raw_data/uk-crime-data", full.names = TRUE) %>% 
  map(list.files, full.names = TRUE) %>% 
  reduce(c)

# Read in LSOA population.
lsoa_population_df <- read.csv("data/raw_data/lsoa_population.csv", sep=";") %>% 
  janitor::clean_names()

# Read in LSOA postcodes with their respective LSOA codes.
lsoa_df <- read_csv("data/raw_data/PCD_OA_LSOA_MSOA_LAD_MAY22_UK_LU.csv", show_col_types = FALSE)