#* All counted crimes for England in 2021/22.
#* 
#* @returns A data frame.
all_counted_crime_df <- map_df(file_names, \(x) {
  read_csv(x, show_col_types = FALSE) %>% 
    count(`LSOA code`, `LSOA name`, `Crime type`) 
}
) %>%
  group_by_at(- 4) %>% 
  summarise(n = sum(n)) %>% 
  ungroup()

#* Recorded crime data frame for England with crime ratio, danger severity score and score category.
#* 
#* @returns A data frame.
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
    value = (all_crimes / population)*10000,
    value = round(value),
    value = as.integer(value),
    score = round(scales::rescale(log(value)) * 9 + 1),
    score_category = case_when(
      score <= 3 ~ "low",  
      4 <= score & score <= 7 ~ "average",  
      score >= 8 ~ "high"
    )
  )

#* Final recorded crime data frame for England.
#* 
#* @returns A data frame.
#* @API /en-crime-by-po
english_recorded_crime_clean_df <- all_counted_crime_df %>% 
  janitor::clean_names() %>% 
  group_by(lsoa_code) %>% 
  slice_max(n, n = 6) %>% 
  arrange(lsoa_code) %>% 
  group_by(lsoa_code, lsoa_name) %>% 
  nest(crime_type = c(crime_type), n = c(n)) %>% 
  mutate(
    crime_type = map(crime_type, pull),
    n = map(n, pull),
  ) %>% 
  inner_join(all_aggregated_crime_df, by = c("lsoa_code", "lsoa_name")) %>% 
  rename(total_crime = value)


#* Look up table LSOA code by postcode.
#* 
#* @returns A data frame.
lsoa_lookup <- lsoa_df[c("pcd7","lsoa11cd","lsoa11nm")] %>% 
  mutate(pcd7 = gsub(' ', '', pcd7))
