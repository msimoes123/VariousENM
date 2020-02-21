setwd('D:\\MODELS_Ready\\nw_arctic_shallow')
sps <- dir()
exclude <- c("Variables", "G_variables")  #exclude g_variables and variables
sps <- sps[!sps %in% exclude]

  
fut_new_bin <- list.files(pattern = '^2.*bin.tif$', full.names = T, recursive = T) #Binary models - MOPS - future ones 
fut_new_bin

pres_new_bin <- list.files(pattern = '^present_bin.tif$', full.names = T, recursive = T) #Binary models - MOPS - Present ones 
pres_new_bin


pres_centroid <- list()
fut_centroid <- list()
dist <- list()

#MEANS - the distances are being calculated from the i= the all the js. So its comparing the raster of different species also...I couldnt change it to make 
#it calculate from Presnet of sp1 to Fut1, Fut2, Fut3, Fut4 of Sp1...and so on

for (i in 1:length(pres_new_bin)) {
  
 pres <- raster::raster(pres_new_bin[i]) #calling present raster and transforming to poly
  pres[pres[] == 0] <- NA
  pres_centroid[[i]] <- colMeans(xyFromCell(pres, which(pres[] == 1)))
  cents <- list()
  
for (j in 1:length(fut_new_bin)) {
    
    fut <- raster::raster(fut_new_bin[j]) #calling future raster
    fut[fut[] == 0] <- NA
    cents[[j]] <- colMeans(xyFromCell(fut, which(fut[] == 1)))
    dist <-  pointDistance(pres_centroid[[i]], cents[[j]], lonlat=T)/1000 #distance in Km
  }
  
  fut_centroid[[i]] <- cents
  
}


#MEDIAN - I did present and future in different loops

library(robustbase)
for (i in 1:length(pres_new_bin)) {
  
  pres <- raster::raster(pres_new_bin[i]) 
  pres[pres[] == 0] <- NA
  pres_centroid[[i]] <- colMedians(xyFromCell(pres, which(pres[] == 1)),)
  
  
}

names(pres_centroid) <- pres_new_bin
Present_centroids <- do.call("rbind", pres_centroid)

fut_centroid <- list()
for (j in 1:length(fut_new_bin)) {
  
  fut <- raster::raster(fut_new_bin[j]) 
  fut[fut[] == 0] <- NA
  fut_centroid[[j]] <- colMedians(xyFromCell(fut, which(fut[] == 1)),)
}

names(fut_centroid) <- fut_new_bin
Future_centroids <- do.call("rbind", fut_centroid)

#rbnid results
total <- rbind(Present_centroids,Future_centroids)
write.csv(total, "D:\\MODELS_Ready\\Cent_Med_arctic_deep.csv", row.names = T)
