# All recorded crimes for Scotland local authorities for the period 2021-2022.
# Also contains most commonly committed crimes and danger severity score and score category.
# API: /scot-crime-by-la
scottish_recorded_crime_clean_df <- recorded_crime_la_df %>% 
  arrange(area_code) %>% 
  group_by(area_code, area_name) %>% 
  rename(n = value) %>% 
  filter(crime_or_offence != "All crimes" & crime_or_offence != "All offences") %>% 
  mutate(total_crime = sum(n)) %>% 
  slice_max(n, n = 6) %>% 
  rename(crime_type = crime_or_offence) %>% 
  nest(
    crime_type = c(crime_type),
    n = c(n)
  ) %>% 
  ungroup() %>% 
  mutate_if(is.list, ~ map(., pull)) %>% 
  mutate(
    score = round(scales::rescale(log(total_crime)) * 9 + 1),
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
    ), 
  )

# All recorded crimes (All crimes and All offences) for Scotland local authorities.
# API: /scot-all-crimes-by-la
scottish_all_recorded_crime_clean_df <- all_recorded_crimes_la %>% 
  arrange(area_code) %>% 
  group_by(area_code, area_name, ref_period) %>% 
  rename(n = value) %>% 
  filter(crime_or_offence != "All crimes" & crime_or_offence != "All offences") %>% 
  mutate(total_crime = sum(n)) %>% 
  select(., area_code, area_name, total_crime) %>%
  group_by(area_code, area_name, ref_period, total_crime) %>% 
  summarize() %>% 
  nest(
    ref_period = c(ref_period),
    total_crime = c(total_crime)
  )  %>% 
  ungroup() %>% 
  mutate_if(is.list, ~ map(., pull)) %>% 
  mutate(
    area_name = case_when(
      area_name == "City of Edinburgh" ~ "Edinburgh",
      area_name == "West Dunbartonshire" ~ "West Dunbartonshire Council",
      area_name == "Dundee City" ~ "Dundee City Council",
      area_name == "Highland" ~ "Highland Council",
      area_name == "East Renfrewshire" ~ "East Renfrewshire Council",
      TRUE ~ area_name
    ),
  )
