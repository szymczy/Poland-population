#LOADING PACKAGES
pacman::p_load(
  arcgis, geodata, sf, dots, tidyverse,
  plotly, viridis, gganimate, scales, ggrepel
)

#POPULATION DATA 
url <- "https://services1.arcgis.com/ZGrptGlLV2IILABw/arcgis/rest/services/Pop_Admin1/FeatureServer/0"
data <- arcgislayers::arc_open(url)

adm_population <-arcgislayers::arc_select(
  data,
  fields = c(
    "GID_1", "ISO2", "Population"
  ),
  where = "ISO2 = 'PL'"
) %>%
  sf::st_drop_geometry()

#ADMINISTRATIVE BOUNDARIES
country_adm_sf <- geodata::gadm(
  country = "PL",
  level = 1,
  path = getwd()
) %>%
  sf::st_as_sf() %>%
  sf::st_cast("MULTIPOLYGON")

# CRS, taken from page: 
crs <- "+proj=tmerc +lat_0=0 +lon_0=19 +k=0.9993 +x_0=500000 +y_0=-5300000 +ellps=GRS80 +units=m +no_defs +type=crs"

#
PL_adm_population <- dplyr::left_join(
  country_adm_sf,
  adm_population,
  by = "GID_1"
) %>%
  sf::st_transform(crs = crs) %>%
  mutate(popDensity = adm_population$Population / as.numeric(st_area(.)) * 1e6)

# DOT DENSITY
dotspopulation <- dots::dots_points(
  shp = PL_adm_population,
  col = "Population",
  engine = engine_sf_random,
  divisor = 100000
)

#any(is.na(PL_adm_population$Population))
#PL_adm_population$Population[is.na(PL_adm_population$Population)] <- mean(PL_adm_population$Population, na.rm = TRUE)
#CENTROIDS
centroids <- st_centroid(PL_adm_population)


p <- ggplot() +
  geom_sf(
    data = PL_adm_population,
    aes(geometry = geometry, fill = popDensity),
    #fill = "#2057fb",
    color = "#17202A",
    linewidth = .5
  ) +
  geom_sf(
    data = dotspopulation,
    aes(geometry = geometry),
    color = "#DFFF00",
    size = 0.1,
    alpha = 0.5
  ) +
  geom_sf_text(
    data = centroids,
    aes(label = NAME_1, geometry = geometry),
    size = 3,
    color = "white"
  ) +
  scale_fill_viridis(
    option = "plasma",
    name = "Population Density\n(per km²)",
    labels = scales::comma
  ) +
  coord_sf(crs = crs) +
  theme_minimal() +
  labs(
    title = "Population Distribution in Poland",
    subtitle = "Dot Density Map with Population Density Heatmap",
    caption = "Data source: ArcGIS REST Services"
  ) +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12),
    legend.position = "right"
  )


print(p)


# Convert ggplot to plotly
#p_interactive <- ggplotly(p, tooltip = c("NAME_1", "Population", "PopDensity"))

# Style the layout for better interactivity
#p_interactive <- p_interactive %>%
#  layout(
#    hoverlabel = list(bgcolor = "white", font = list(family = "Arial", size = 12)),
#    title = list(text = "Population Distribution in Poland",
#                 font = list(size = 20)),
#    annotations = list(
#      x = 1, y = -0.1, text = "Data source: ArcGIS REST Services",
#      showarrow = F, xref='paper', yref='paper',
#      xanchor='right', yanchor='auto', xshift=0, yshift=0,
#      font = list(size = 10)
#    )
#  )

# Display the plot
#print(p_interactive)
