library(tidyverse)
library(opendatascot)
library(ukpolice)

# The following code is based on https://github.com/dc27/scotland_stats_maps/blob/main/scripts/cleaning.R
datazones <- read_csv("~/people-safety-app-scotland-server/data/raw_data/DataZone2011lookup_2022-05-31.csv")
spec(datazones)

datazone_lookup <- datazones %>% 
  select(area_code = LA_Code, area_name = LA_Name) %>% 
  unique()

# la_datazones

# dz_datazones <- datazones %>% 
#   select(area_code = DZ2011_Code, area_name = DZ2011_Name) %>% 
#   unique()
# 
# # dz_datazones
# 
# datazone_lookup <- bind_rows(list("Local Authority" = la_datazones,
#                                   "Data Zone" = dz_datazones),
#                              .id = "area_type")
datazone_lookup %>% 
  write_csv("~/people-safety-app-scotland-server/data/datazone_lookup.csv")

# Filter by local authorities.
recorded_crime_la <- ods_dataset(
  "recorded-crime", measureType="ratio", geography = "la"
)

recorded_crime_clean_la <- recorded_crime_la %>% 
  janitor::clean_names() %>% 
  rename(area_code = ref_area) %>%
  left_join(datazone_lookup, by = c("area_code" = "area_code")) %>%
  select(area_code,
         area_name,
         ref_period,
         crime_or_offence,
         measure_type,
         value)

all_crimes_by_la <- recorded_crime_clean_la %>% 
  filter(crime_or_offence == "all-crimes") %>% 
  filter(ref_period == "2021/2022")

assign_score_to_la <- all_crimes_by_la %>% 
  mutate(
    score = round(scales::rescale(value) * 9 + 1),
    area_name = case_when(
      area_name == "City of Edinburgh" ~ "Edinburgh",
      area_name == "West Dunbartonshire" ~ "West Dunbartonshire Council",
      area_name == "Dundee City" ~ "Dundee City Council",
      area_name == "Highland" ~ "Highland Council",
      area_name == "East Renfrewshire" ~ "East Renfrewshire Council",
      TRUE ~ area_name
    ),
    score_category = case_when(
      score <= 3 ~ "low",  
      4 <= score & score <= 7 ~ "average",  
      score >= 8 ~ "high"
    )
  )

# Rest of UK data cleaning
file_names <- list.files("/Users/gyimesiregina/Downloads/uk-crime-data", full.names = TRUE) %>% 
  map(list.files, full.names = TRUE) %>% 
  reduce(c)

count_crime <- function(x) {
  read_csv(x) %>% 
    count(`LSOA code`, `LSOA name`, `Crime type`) 
}

all_counted_crime_df <- map_df(file_names, count_crime)

all_counted_crime_df <- all_counted_crime_df %>% 
  group_by_at(- 4) %>% 
  summarise(n = sum(n)) %>% 
  ungroup()

lsoa_population_df <- read.csv("/Users/gyimesiregina/Downloads/lsoa_population.csv", sep=";") %>% 
  janitor::clean_names()
spec(lsoa_population_df)

all_aggregated_crime_df <- all_counted_crime_df %>% 
  janitor::clean_names() %>% 
  group_by(`lsoa_code`, `lsoa_name`) %>% 
  summarise(n = sum(n)) %>% 
  ungroup() %>% 
  inner_join(lsoa_population_df, by = c("lsoa_code", "lsoa_name")) %>%
  select(lsoa_code, lsoa_name, all_crimes = n, population = all_ages) %>%
  mutate(
    population = str_remove(population, " "),
    population = as.numeric(population),
    value = all_crimes / population*10000,
    value = round(value),
    value = as.integer(value),
    score = round(scales::rescale(log(value)) * 9 + 1),
    score_category = case_when(
      score <= 3 ~ "low",  
      4 <= score & score <= 7 ~ "average",  
      score >= 8 ~ "high"
    )
    )


lsoa_df <- read_csv("/Users/gyimesiregina/Downloads/PCD_OA_LSOA_MSOA_LAD_MAY22_UK_LU.csv")
lsoa_lookup <- lsoa_df[c("pcd7","lsoa11cd","lsoa11nm")] %>% 
  mutate(pcd7 = gsub(' ', '', pcd7))
