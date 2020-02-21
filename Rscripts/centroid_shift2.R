#Calling New Binary (Binary - MOP)

devtools::install_github("marlonecobos/ellipsenm")
library(ellipsenm)
library(raster)

setwd('D:\\MODELS_Ready\\nw_arctic_deep')
sps <- dir()
exclude <- c("Variables", "G_variables")  #exclude g_variables and variables
sps <- sps[!sps %in% exclude]

#var_list <- list(stack(list.files("D:/nw_shallow/Variables/set1/present", pattern = ".asc", full.names = TRUE)))

#vars <- raster::stack(list.files("D:/nw_shallow/Variables/set1/present", pattern = ".asc", full.names = TRUE))


fut_new_bin <- list.files(pattern = '^2.*bin.tif$', full.names = T, recursive = T) #Binary models - MOPS - future ones 
fut_new_bin
fut_new_bin_ex <- list.files(pattern = '^2.*bin.tif2.*bin.tif$', full.names = T, recursive = T) #Binary models - MOPS - future ones 
fut_new_bin <- fut_new_bin[!fut_new_bin %in% fut_new_bin_ex]

#ex <- seq(1, 455, 2) #change the middle number for the number of "bin_files"
#ne <- seq(2, 455, 2)

#exs <- ex[!ex %in% ne]
#fut_new_bin <- fut_new_bin[-exs]
#fut_new_bin <- fut_new_bin[-231]
#fut_new_bin <- fut_new_bin[-232]

pres_new_bin <- list.files(pattern = '^present_bin.tif$', full.names = T, recursive = T) #Binary models - MOPS - Present ones 
pres_new_bin

sp_occ <- list.files(pattern = 'joint.csv$', full.names = T, recursive = T)
sp_occ

pres_centroid <- list()
fut_centroid <- list()

i=36
j=1

for (i in 1:length(pres_new_bin)) {
  
  sp1 <- read.csv(sp_occ[i])
  sub1 <- subset(sp1, sp1$decimalLongitude < -180, sp1$decimalLongitude > 180) 
  sub2 <- subset(sp1, sp1$decimalLatitude < -90, sp1$decimalLatitude > 90) 
  sp2 <- sp1[ !(sp1 %in% sub1), ]
  sp <- sp2[ !(sp2 %in% sub2), ]
  
  pol <- concave_area(data = sp, longitude = "decimalLongitude", latitude = "decimalLatitude", 
                      length_threshold = 25, buffer_distance = 200)

  pres <- raster::raster(pres_new_bin[i])
  pres <- raster::mask(crop(pres,pol), pol)
  pres[pres[] == 0] <- NA
  pres_centroid[[i]] <- colMeans(xyFromCell(pres, which(pres[] == 1)))
  cents <- list()
  dist <- vector()
  NS <- vector()
  
  ifut <- ifelse(i == 1, 1, ((i - 1) * 4 + 1))
  lfut <- i * 4
  
  f_new_bin <- fut_new_bin[ifut:lfut]
    
  for (j in 1:length(f_new_bin)) {
   
      fut <- raster::raster(f_new_bin[j]) #calling present raster and transforming to poly
      fut <- raster::mask(crop(fut, pol), pol)
      fut[fut[] == 0] <- NA
      cents[[j]] <- colMeans(xyFromCell(fut, which(fut[] == 1)))
      
      #Distance from centroids
      
      dist[j] <-  pointDistance(pres_centroid[[i]], cents[[j]], lonlat=T)/1000 #distance in Km
      NS[j] <- ifelse(pres_centroid[[i]][2] > cents[[j]][2], 'South', 'North')
       
      }
  
  fut_centroid[[i]] <- data.frame(paste0(pres_new_bin[i], f_new_bin), 
                                  matrix(pres_centroid[[i]], nrow = 1), do.call(rbind, cents), dist, NS)
cat(i, 'of', length(pres_new_bin), '\n')
}
i=1
result <- do.call(rbind, fut_centroid)
write.csv(result, 'D:/MODELS_Ready/nw_arctic_deep_CENTROID.csv', row.names = F)

#Centroid Shift through time
#Calc centroid
#centroid <- rgeos::gCentroid(occ_sp, byid = FALSE)

#Transform Raster to Polygon 
#m <- raster::raster("raster_file.tif")
#m[m[] == 0] <- NA
#m <- raster::trim(m)
#shpm <- raster::rasterToPolygons(m, dissolve = TRUE)
