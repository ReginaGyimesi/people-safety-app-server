# Data zone codes with their respective names.
datazones_df <- read_csv("data/raw_data/DataZone2011lookup_2022-05-31.csv") %>% 
  select(area_code = LA_Code, area_name = LA_Name) %>% 
  unique()

# Extract all recorded crimes for local authorities for the period 2021-2022.
recorded_crime_la_df <- ods_dataset("recorded-crime", measureType="ratio", geography = "la", ) %>% 
  janitor::clean_names() %>% 
  rename(area_code = ref_area) %>%
  left_join(datazones_df, by = c("area_code" = "area_code")) %>%
  select(area_code,
         area_name,
         ref_period,
         crime_or_offence,
         measure_type,
         value) %>% 
  filter(ref_period == "2021/2022") %>% 
  mutate(
    crime_or_offence = str_remove(crime_or_offence, ".*\\d-"),
    crime_or_offence = str_replace_all(crime_or_offence, "-", " "),
    crime_or_offence = str_to_sentence(crime_or_offence),
  )

# Extract all recorded crimes for local authorities.
all_recorded_crimes_la <- ods_dataset("recorded-crime", measureType="ratio", geography = "la", )  %>% 
  janitor::clean_names() %>% 
  rename(area_code = ref_area) %>%
  left_join(datazones_df, by = c("area_code" = "area_code")) %>%
  select(area_code,
         area_name,
         ref_period,
         crime_or_offence,
         measure_type,
         value) %>% 
  mutate(
    crime_or_offence = str_remove(crime_or_offence, ".*\\d-"),
    crime_or_offence = str_replace_all(crime_or_offence, "-", " "),
    crime_or_offence = str_to_sentence(crime_or_offence),
  )
