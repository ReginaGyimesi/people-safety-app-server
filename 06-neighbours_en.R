pacman::p_load("st", "sf")

#* Read in LSOA shapes.
#* 
#* @returns A data frame.
lsoa_shapes <- st_read("data/raw_data/lower_layer_super_output_areas/Lower_Super_Output_Area_(LSOA)_IMD2019__(WGS84).shp") %>%
  rename(
    lsoa_code = lsoa11cd,
    lsoa_name = lsoa11nm  
  ) %>%
  tibble()

#* Find neighbours for given shape.
#* 
#* @returns A data frame.
#* @param .data The given data frame.
#* @param geo Column name containing the location names.
#* @param geometry Column name containing the location data.
find_neighbours <- function(.data, geo = geo, geometry = geometry) {
  .data |> 
    pull({{ geometry }}) |> 
    st_touches(sparse = FALSE) |> 
    as_tibble() |> 
    mutate(x = row_number()) |> 
    pivot_longer(- x, names_to = "y", names_transform = parse_number) |> 
    filter(value) |> 
    select(- value) |> 
    mutate_all(\(x) map_chr(x, ~ pull(.data, {{ geo }})[.])) |> 
    purrr::set_names(deparse(substitute(geo)), "neighbour") |> 
    group_by_at(1) |>
    summarise(neighbour = list(neighbour))
}

#* Find center point of shapes.
#* 
#* @returns A data frame.
#* @param .data The given data frame.
#* @param geo Column name containing the location names.
find_centroid <- function(.data, geo) {
  .data |> 
    pull(geometry) |> 
    st_centroid() |> 
    st_transform(crs = 4326) |> 
    map_dfr(\(x) tibble(lon = x[1], lat = x[2])) |> 
    (\(x) bind_cols(select(.data, {{ geo }}), x)) ()
}

sf_use_s2(FALSE)


#* Return neighbouring areas for England.
#* 
#* @returns A data frame.
#* @API /en-get-neighbouring-areas
english_local_neighbour_df <- lsoa_shapes |> 
  find_neighbours(lsoa_name) |> 
  unnest(neighbour) |> 
  left_join(
    lsoa_shapes |> 
      find_centroid(lsoa_name),
    by = c("neighbour" = "lsoa_name")
  ) |> 
  group_by(lsoa_name) |> 
  summarise_all(.funs = list)
