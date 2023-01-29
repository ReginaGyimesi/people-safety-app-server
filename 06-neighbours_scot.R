pacman::p_load("st", "sf")

# Read in local authority shapes.
local_authority_shapes <- st_read("data/raw_data/local_authority_boundaries/pub_las.shp") |> 
  tibble()

# Find neighbours for given shape.
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

# Find center of given shape.
find_centroid <- function(.data, geo) {
  .data |> 
    pull(geometry) |> 
    st_centroid() |> 
    st_transform(crs = 4326) |> 
    map_dfr(\(x) tibble(lon = x[1], lat = x[2])) |> 
    (\(x) bind_cols(select(.data, {{ geo }}), x)) ()
}

# Return neighbouring areas for Scotland.
# API: /scot-get-neighbouring-areas
scottish_local_neighbour_df <- local_authority_shapes |> 
  find_neighbours(local_auth) |> 
  unnest(neighbour) |> 
  left_join(
    local_authority_shapes |> 
      find_centroid(local_auth),
    by = c("neighbour" = "local_auth")
  ) |> 
  group_by(local_auth) |> 
  summarise_all(.funs = list)