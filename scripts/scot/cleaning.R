library(tidyverse)
library(opendatascot)
library(ukpolice)

# The following code is based on https://github.com/dc27/scotland_stats_maps/blob/main/scripts/cleaning.R
datazones <- read_csv("~/people-safety-app-scotland-server/data/raw_data/DataZone2011lookup_2022-05-31.csv")

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

# all-crimes by local authorities for all periods
all_crimes_by_la <- recorded_crime_clean_la %>% 
  filter(crime_or_offence == "all-crimes") %>% 
  filter(ref_period == "2021/2022")

  
assign_score_to_la <- all_crimes_by_la %>% 
  mutate(
    norm_value = round(scales::rescale(value) * 9 + 1)
  )

crime_data <- ukp_crime(lat = 52.52618, lng = -1.897738, date = c("2021-03", "2021-09"))
crime_data



