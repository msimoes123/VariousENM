#Gather all occourances from folders 
setwd('C:\\Users\\admin\\Desktop\\Mollusca_\\datasets\\Subset\\Final_shallow_deep\\30\\Clean\\Deep\\Deep') #Directory containing the folders of species
folders <- dir()[file.info(dir())$isdir]  #Name of folders
#i=1
df <- NULL
for (i in 1:length(folders)) {

  occ <- list.files(path = paste(folders[i], sep = "/"), pattern = ".csv$", full.names = TRUE)
  occ_ <- read.csv(occ)
  df <- rbind(df, occ_) #Row bind
}

df
write.csv(df, 'C:\\Users\\admin\\Desktop\\Mollusca_\\datasets\\Subset\\Final_shallow_deep\\30\\Clean\\Deep\\Deep_final_Occ.csv', row.names=F) #write csv with the info gathered after rbind

#Creating maps for every species
library(sf)
library(marmap)

setwd('C:\\Users\\admin\\Desktop\\Mollusca_\\datasets\\Subset\\Final_shallow_deep\\30\\Clean\\Deep')
occ_s <- read.csv('Deep_final_Occ.csv')
map_ <- raster('C:\\Users\\admin\\Desktop\\Mollusca_\\Past\\Bivalvia_deep\\Variables\\set2\\present\\etoporst.asc')
plot(map_)
world_shape <- st_read('C:\\Users\\admin\\Desktop\\Chryofaun\\WorldCountries.shp')
#map <- getNOAA.bathy(lon1 = -180, lon2 = 180,lat1 = -90, lat2 = 90, resolution = 10, keep = T)

species <- levels(occ_s$Species)

map <-   tm_shape(World, projection="robin") +  tm_fill() +   tm_borders() 

i=1
for(i in 1:length(species)){
  #open the file for writing
  pdf(paste0(species[i],".pdf"),width=5,height=4)
  #plot(map_, image = TRUE, land = TRUE, lwd = 0.1, bpal = list(c(0, max(map_), greys), c(min(map_), 0, blues)))
  #plot(map_, lwd = 0.8, deep = 0, shallow = 0, step = 0, add = TRUE) # highlight coastline
  #plot(map, )
  #plot(world_shape)
  #plot(wrld_simpl, axes=TRUE, col='light grey')
  tm_shape(World, projection="robin") +  tm_fill() +   tm_borders() 
  #box() #adds box around map
  #title(main=species[i]) #adds main title to map which should be the species name associated with the data
  points(occ_s$Long[occ_s$Species == species[i]],occ_s$Lat[occ_s$Species == species[i]], col='red', pch=20, bg="blue", cex=0.5)
  dev.off()
}

for(i in 1:length(species))  {
  #open the file for writing
  pdf(paste0(species[i],".pdf"),width=5,height=4)
  plot (map_, xlim=c(-180,180), ylim=c(-90,90), axes=TRUE, col='light grey')
  box() #adds box around map
  title(main=species[i]) #adds main title to map which should be the species name associated with the data
  points(occ_s$Long[occ_s$Species == species[i]],occ_s$Lat[occ_s$Species == species[i]], col='red', pch=20, bg="blue", cex=0.5)
  dev.off()
}



library(sf)
library(raster)
library(dplyr)
install.packages('spData')
library(spData)
install.packages('spDataLarge')
library(spDataLarge)
install.packages('tmap')
library(tmap)

data(World)

tm_shape(World, projection="robin") + 
  tm_polygons()  

  tm_shape(World, projection="robin") +
  tm_fill() +
  tm_borders() 

tm_shape(World, projection="robin")



for(i in 1:length(species))  {
  #open the file for writing
  pdf(paste0(species[i],".pdf"),width=5,height=4)
  #plot(raw_data)
  #box()
  #plot(x, maxpixels = ncell(x), col = col, colNA = "#818181", axes = FALSE, ylim=c(-90, 90))
  # Plotting the bathymetry with different colors for land and sea
  plot(map, image = TRUE, land =TRUE, lwd = 0,
       bpal = list(c(0, max(map), "darkgrey"),
                   c(min(map),0,blues)), deepest.isobath= -10725,
       shallowest.isobath = 0, step = 11000, col ="lightgrey",
       lty = 5, drawlabel =FALSE)
  legend.gradient(cbind(x = x - 150, y = y - 30),
                  cols = blues, title = "Depth", limits = c(-11000, 0), cex=0.4)
  #Map fetaures
  title(main=species[i], font.main=4, xlab = "Longitude", ylab = "Latitude") #adds main title to map which should be the species name associated with the data
  points(csv$decimalLongitude[csv$name == species[i]],csv$decimalLatitude[csv$name == species[i]], col='red', pch=18, bg="black", cex=0.4)
  dev.off()
}
for(i in 1:length(species))  {
  #open the file for writing