library(raster)
setwd("D:/Black_HD/MOPS_Ready")

#####
# Changes in continuous suitabilities
### Deep
dir(pattern = "deep")

dirs <- c("arctic_deep", "nw_arctic_deep", "nw_deep") # are these all?

cont <- list()
for (i in 1:length(dirs)) {
  cont[[i]] <- list.files(path = dirs[i], pattern = "MOP.*tif$", full.names = TRUE, recursive = TRUE)
}

cont <- unlist(cont)

ncl <- gregexpr(".*2050.*26.*", cont); ncla <- regmatches(cont, ncl); y50_r26 <- unlist(ncla)
ncl <- gregexpr(".*2050.*85.*", cont); ncla <- regmatches(cont, ncl); y50_r85 <- unlist(ncla)
ncl <- gregexpr(".*2100.*26.*", cont); ncla <- regmatches(cont, ncl); y100_r26 <- unlist(ncla)
ncl <- gregexpr(".*2100.*85.*", cont); ncla <- regmatches(cont, ncl); y100_r85 <- unlist(ncla)
ncl <- gregexpr(".*present.*", cont); ncla <- regmatches(cont, ncl); present <- unlist(ncla)

c5026 <- raster(y50_r26[1]) == 0
c5085 <- raster(y50_r85[1]) == 0
c10026 <- raster(y100_r26[1]) == 0
c10085 <- raster(y100_r85[1]) == 0
cpresent <- raster(present[1]) == 0

for (j in 1:(length(y50_r26) - 1)) {
  c5026 <- c5026 + (raster(y50_r26[j + 1]) == 0)
  c5085 <- c5085 + (raster(y50_r85[j + 1]) == 0)
  c10026 <- c10026 + (raster(y100_r26[j + 1]) == 0)
  c10085 <- c10085 + (raster(y100_r85[j + 1]) == 0)
  cpresent <- cpresent + (raster(present[j + 1]) == 0)
  cat("\tsum", j, "of", (length(y50_r26) - 1), "\n")
}

#c5026 <- c5026 / length(y50_r26)
#c5085 <- c5085 / length(y50_r26)
#c10026 <- c10026 / length(y50_r26)
#c10085 <- c10085 / length(y50_r26)
#cpresent <- cpresent / length(y50_r26)

dir.create("MOP_sum")

writeRaster(c5026, filename = "MOP_sum/sum_deep_MOP_5026.tif", format = "GTiff")
writeRaster(c5085, filename = "MOP_sum/sum_deep_MOP_5085.tif", format = "GTiff")
writeRaster(c10026, filename = "MOP_sum/sum_deep_MOP_10026.tif", format = "GTiff")
writeRaster(c10085, filename = "MOP_sum/sum_deep_MOP_10085.tif", format = "GTiff")
writeRaster(cpresent, filename = "MOP_sum/sum_deep_MOP_present.tif", format = "GTiff")


### Shallow
dir(pattern = "shallow")

dirs <- c("arctic_shallow", "nw_arctic_shallow", "nw_shallow") # are these all?


cont <- list()
for (i in 1:length(dirs)) {
  cont[[i]] <- list.files(path = dirs[i], pattern = "MOP.*tif$", full.names = TRUE, recursive = TRUE)
}

cont <- unlist(cont)

ncl <- gregexpr(".*2050.*26.*", cont); ncla <- regmatches(cont, ncl); y50_r26 <- unlist(ncla)
ncl <- gregexpr(".*2050.*85.*", cont); ncla <- regmatches(cont, ncl); y50_r85 <- unlist(ncla)
ncl <- gregexpr(".*2100.*26.*", cont); ncla <- regmatches(cont, ncl); y100_r26 <- unlist(ncla)
ncl <- gregexpr(".*2100.*85.*", cont); ncla <- regmatches(cont, ncl); y100_r85 <- unlist(ncla)
ncl <- gregexpr(".*present.*", cont); ncla <- regmatches(cont, ncl); present <- unlist(ncla)

c5026 <- raster(y50_r26[1]) == 0
c5085 <- raster(y50_r85[1]) == 0
c10026 <- raster(y100_r26[1]) == 0
c10085 <- raster(y100_r85[1]) == 0
cpresent <- raster(present[1]) == 0

for (j in 1:(length(y50_r26) - 1)) {
  c5026 <- c5026 + (raster(y50_r26[j + 1]) == 0)
  c5085 <- c5085 + (raster(y50_r85[j + 1]) == 0)
  c10026 <- c10026 + (raster(y100_r26[j + 1]) == 0)
  c10085 <- c10085 + (raster(y100_r85[j + 1]) == 0)
  cpresent <- cpresent + (raster(present[j + 1]) == 0)
  cat("\tsum", j, "of", (length(y50_r26) - 1), "\n")
}

#c5026 <- c5026 / length(y50_r26)
#c5085 <- c5085 / length(y50_r26)
#c10026 <- c10026 / length(y50_r26)
#c10085 <- c10085 / length(y50_r26)
#cpresent <- cpresent / length(y50_r26)

writeRaster(c5026, filename = "MOP_sum/sum_shallow_MOP_5026.tif", format = "GTiff")
writeRaster(c5085, filename = "MOP_sum/sum_shallow_MOP_5085.tif", format = "GTiff")
writeRaster(c10026, filename = "MOP_sum/sum_shallow_MOP_10026.tif", format = "GTiff")
writeRaster(c10085, filename = "MOP_sum/sum_shallow_MOP_10085.tif", format = "GTiff")
writeRaster(cpresent, filename = "MOP_sum/sum_shallow_MOP_present.tif", format = "GTiff")
