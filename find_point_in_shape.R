local_authority_shapes |> 
  pull(geometry) |> 
  (\(x) st_distance(x[1], x[2])) ()

# Find point in local authority shapes.
find_point_in_la_shape <- function(lat, lon) {
  pnts = data.frame(latitude = c(lat),longitude=c(lon))
  
  sp_points = st_as_sf(pnts,coords = c('longitude',"latitude")) # Make points spatial
  sp_points
  st_crs(sp_points)= 4326 # Give the points a coordinate reference system (CRS)
  sp_points=st_transform(sp_points,crs = st_crs(local_authority_shapes)) # Match the point and polygon CRS
  
  sp_points$local_auth <- apply(st_intersects(local_authority_shapes, sp_points, sparse = FALSE), 2, 
                                function(col) {local_authority_shapes[which(col), ]$local_auth}) 
  
  sp_points
}

# find_point_in_la_shape(55.8473, -4.4401)

# Find point in LSOA shapes.
find_point_in_lsoa_shape <- function(lat, lon) {
  
  sp_points <- tibble(latitude = lat, longitude = lon) |> 
    st_as_sf(coords = c('longitude',"latitude")) |> 
    st_set_crs(4326)
  
  in_this <- safely(\(x) st_intersects(x, sp_points, sparse = FALSE), otherwise = NA)
  
  st_covers(lsoa_shapes$geometry, sp_points)
  
  tryCatch({
    identified_lsoa <- lsoa_shapes |> 
      pull(geometry) |> 
      st_set_crs(4326) |> 
      map(in_this) |> 
      map(1) |> 
      map_lgl(~ .[1, 1]) |> 
      which() |> 
      slice(.data = lsoa_shapes) |> 
      pull(lsoa_name)
  })
  if (length(identified_lsoa) == 0) {
    
    identified_lsoa <- "No data found."
  }
  
  c(lat, lon, identified_lsoa)
  
}

# find_point_in_lsoa_shape(lat = 51.509865, lon = -0.136439)