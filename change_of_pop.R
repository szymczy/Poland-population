#population change
pacman::p_load(
  tidyverse, terra, giscoR
)

#download zip from GHSL 
#https://human-settlement.emergency.copernicus.eu/download.php?ds=pop
y2005 <- https://jeodpp.jrc.ec.europa.eu/ftp/jrc-opendata/GHSL/GHS_POP_GLOBE_R2023A/GHS_POP_E2005_GLOBE_R2023A_4326_30ss/V1-0/GHS_POP_E2005_GLOBE_R2023A_4326_30ss_V1_0.zip
y2025 <- https://jeodpp.jrc.ec.europa.eu/ftp/jrc-opendata/GHSL/GHS_POP_GLOBE_R2023A/GHS_POP_E2025_GLOBE_R2023A_4326_30ss/V1-0/GHS_POP_E2025_GLOBE_R2023A_4326_30ss_V1_0.zip