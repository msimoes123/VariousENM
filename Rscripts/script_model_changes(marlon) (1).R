library(raster)
setwd("D:/MODELS_Ready")

#####
# Changes in continuous suitabilities
### Deep
dir(pattern = "deep")

dirs <- c("arctic_deep", "nw_arctic_deep", "nw_deep") # are these all?

cont <- list()
for (i in 1:length(dirs)) {
  cont[[i]] <- list.files(path = dirs[i], pattern = "continuous_comparison.tif$", full.names = TRUE, recursive = TRUE)
}

cont <- unlist(cont)

ncl <- gregexpr(".*2050/.*26.*", cont); ncla <- regmatches(cont, ncl); y50_r26 <- unlist(ncla)
ncl <- gregexpr(".*2050/.*85.*", cont); ncla <- regmatches(cont, ncl); y50_r85 <- unlist(ncla)
ncl <- gregexpr(".*2100/.*26.*", cont); ncla <- regmatches(cont, ncl); y100_r26 <- unlist(ncla)
ncl <- gregexpr(".*2100/.*85.*", cont); ncla <- regmatches(cont, ncl); y100_r85 <- unlist(ncla)

c5026 <- raster(y50_r26[1])
c5085 <- raster(y50_r85[1])
c10026 <- raster(y100_r26[1])
c10085 <- raster(y100_r85[1])

for (j in 1:(length(y50_r26) - 1)) {
  c5026 <- c5026 + raster(y50_r26[j + 1])
  c5085 <- c5085 + raster(y50_r85[j + 1])
  c10026 <- c10026 + raster(y100_r26[j + 1])
  c10085 <- c10085 + raster(y100_r85[j + 1])
  cat("\tsum", j, "of", (length(y50_r26) - 1), "\n")
}

c5026 <- c5026 / length(y50_r26)
c5085 <- c5085 / length(y50_r26)
c10026 <- c10026 / length(y50_r26)
c10085 <- c10085 / length(y50_r26)

dir.create("Model_changes")

writeRaster(c5026, filename = "Model_changes/cont_suitchan_deep_5026_avg.tif", format = "GTiff")
writeRaster(c5085, filename = "Model_changes/cont_suitchan_deep_5085_avg.tif", format = "GTiff")
writeRaster(c10026, filename = "Model_changes/cont_suitchan_deep_10026_avg.tif", format = "GTiff")
writeRaster(c10085, filename = "Model_changes/cont_suitchan_deep_10085_avg.tif", format = "GTiff")


### Shallow
dir(pattern = "shallow")

dirs <- c("arctic_shallow", "nw_arctic_shallow", "nw_shallow") # are these all?


cont <- list()
for (i in 1:length(dirs)) {
  cont[[i]] <- list.files(path = dirs[i], pattern = "continuous_comparison.tif$", full.names = TRUE, recursive = TRUE)
}

cont <- unlist(cont)

ncl <- gregexpr(".*2050/.*26.*", cont); ncla <- regmatches(cont, ncl); y50_r26 <- unlist(ncla)
ncl <- gregexpr(".*2050/.*85.*", cont); ncla <- regmatches(cont, ncl); y50_r85 <- unlist(ncla)
ncl <- gregexpr(".*2100/.*26.*", cont); ncla <- regmatches(cont, ncl); y100_r26 <- unlist(ncla)
ncl <- gregexpr(".*2100/.*85.*", cont); ncla <- regmatches(cont, ncl); y100_r85 <- unlist(ncla)

c5026 <- raster(y50_r26[1])
c5085 <- raster(y50_r85[1])
c10026 <- raster(y100_r26[1])
c10085 <- raster(y100_r85[1])

for (j in 1:(length(y50_r26) - 1)) {
  c5026 <- c5026 + raster(y50_r26[j + 1])
  c5085 <- c5085 + raster(y50_r85[j + 1])
  c10026 <- c10026 + raster(y100_r26[j + 1])
  c10085 <- c10085 + raster(y100_r85[j + 1])
  cat("\tsum", j, "of", (length(y50_r26) - 1), "\n")
}

c5026 <- c5026 / length(y50_r26)
c5085 <- c5085 / length(y50_r26)
c10026 <- c10026 / length(y50_r26)
c10085 <- c10085 / length(y50_r26)

writeRaster(c5026, filename = "Model_changes/cont_suitchan_shallow_5026_avg.tif", format = "GTiff")
writeRaster(c5085, filename = "Model_changes/cont_suitchan_shallow_5085_avg.tif", format = "GTiff")
writeRaster(c10026, filename = "Model_changes/cont_suitchan_shallow_10026_avg.tif", format = "GTiff")
writeRaster(c10085, filename = "Model_changes/cont_suitchan_shallow_10085_avg.tif", format = "GTiff")

#####
# Changes in binary suitable areas, losses and gains
### Deep
dir(pattern = "deep")

dirs <- c("arctic_deep", "nw_arctic_deep", "nw_deep") # are these all?

cont <- list()
for (i in 1:length(dirs)) {
  cont[[i]] <- list.files(path = dirs[i], pattern = "binary_comparison.tif$", full.names = TRUE, recursive = TRUE)
}

cont <- unlist(cont)

ncl <- gregexpr(".*2050/.*26.*", cont); ncla <- regmatches(cont, ncl); y50_r26 <- unlist(ncla)
ncl <- gregexpr(".*2050/.*85.*", cont); ncla <- regmatches(cont, ncl); y50_r85 <- unlist(ncla)
ncl <- gregexpr(".*2100/.*26.*", cont); ncla <- regmatches(cont, ncl); y100_r26 <- unlist(ncla)
ncl <- gregexpr(".*2100/.*85.*", cont); ncla <- regmatches(cont, ncl); y100_r85 <- unlist(ncla)

change <- c(1, 2) # gain = 1, loss = 2
nam <- c("_gain.tif", "_loss.tif")

for (i in 1:length(change)) {
  c5026 <- raster(y50_r26[1]) == change[i]
  c5085 <- raster(y50_r85[1]) == change[i]
  c10026 <- raster(y100_r26[1]) == change[i]
  c10085 <- raster(y100_r85[1]) == change[i]
  
  for (j in 1:(length(y50_r26) - 1)) {
    c5026 <- c5026 + (raster(y50_r26[j + 1]) == change[i])
    c5085 <- c5085 + (raster(y50_r85[j + 1]) == change[i])
    c10026 <- c10026 + (raster(y100_r26[j + 1]) == change[i])
    c10085 <- c10085 + (raster(y100_r85[j + 1]) == change[i])
    cat("\tsum", j, "of", (length(y50_r26) - 1), "\n")
  }
  
  writeRaster(c5026, filename = paste0("Model_changes/bin_suitchan_deep_5026", nam[i]), format = "GTiff")
  writeRaster(c5085, filename = paste0("Model_changes/bin_suitchan_deep_5085", nam[i]), format = "GTiff")
  writeRaster(c10026, filename = paste0("Model_changes/bin_suitchan_deep_10026", nam[i]), format = "GTiff")
  writeRaster(c10085, filename = paste0("Model_changes/bin_suitchan_deep_10085", nam[i]), format = "GTiff")
  
  cat("changes", i, "of", length(change), "\n")
}


### Shallow
dir(pattern = "shallow")

dirs <- c("arctic_shallow", "nw_arctic_shallow", "nw_shallow") # are these all?

cont <- list()
for (i in 1:length(dirs)) {
  cont[[i]] <- list.files(path = dirs[i], pattern = "binary_comparison.tif$", full.names = TRUE, recursive = TRUE)
}

cont <- unlist(cont)

ncl <- gregexpr(".*2050/.*26.*", cont); ncla <- regmatches(cont, ncl); y50_r26 <- unlist(ncla)
ncl <- gregexpr(".*2050/.*85.*", cont); ncla <- regmatches(cont, ncl); y50_r85 <- unlist(ncla)
ncl <- gregexpr(".*2100/.*26.*", cont); ncla <- regmatches(cont, ncl); y100_r26 <- unlist(ncla)
ncl <- gregexpr(".*2100/.*85.*", cont); ncla <- regmatches(cont, ncl); y100_r85 <- unlist(ncla)

change <- c(1, 2) # gain = 1, loss = 2
nam <- c("_gain.tif", "_loss.tif")

for (i in 1:length(change)) {
  c5026 <- raster(y50_r26[1]) == change[i]
  c5085 <- raster(y50_r85[1]) == change[i]
  c10026 <- raster(y100_r26[1]) == change[i]
  c10085 <- raster(y100_r85[1]) == change[i]
  
  for (j in 1:(length(y50_r26) - 1)) {
    c5026 <- c5026 + (raster(y50_r26[j + 1]) == change[i])
    c5085 <- c5085 + (raster(y50_r85[j + 1]) == change[i])
    c10026 <- c10026 + (raster(y100_r26[j + 1]) == change[i])
    c10085 <- c10085 + (raster(y100_r85[j + 1]) == change[i])
    cat("\tsum", j, "of", (length(y50_r26) - 1), "\n")
  }
  
  writeRaster(c5026, filename = paste0("Model_changes/bin_suitchan_shallow_5026", nam[i]), format = "GTiff")
  writeRaster(c5085, filename = paste0("Model_changes/bin_suitchan_shallow_5085", nam[i]), format = "GTiff")
  writeRaster(c10026, filename = paste0("Model_changes/bin_suitchan_shallow_10026", nam[i]), format = "GTiff")
  writeRaster(c10085, filename = paste0("Model_changes/bin_suitchan_shallow_10085", nam[i]), format = "GTiff")
  
  cat("changes", i, "of", length(change), "\n")
}
