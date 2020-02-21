library(raster)
setwd("D:/MODELS_Ready")

#####
# Changes in continuous suitabilities
### Deep
dir(pattern = "deep")

dirs <- c("arctic_deep", "nw_arctic_deep", "nw_deep") # are these all?

cont <- list()
for (i in 1:length(dirs)) {
  cont[[i]] <- list.files(path = dirs[i], pattern = "var_emi_scenarios.tif$", full.names = TRUE, recursive = TRUE)
}
cont1 <- list()
for (i in 1:length(dirs)) {
  cont1[[i]] <- list.files(path = dirs[i], pattern = "0_var_replicates.tif$", full.names = TRUE, recursive = TRUE)
}

cont <- unlist(cont)
cont1 <- unlist(cont1)
cont <- list(cont, cont1)
nam <- c("_emi_scenarios.tif", "_replicates.tif")

for (i in 1:length(cont)) {
  ncl <- gregexpr(".*2050_var.*", cont[[i]]); ncla <- regmatches(cont[[i]], ncl); y50 <- unlist(ncla)
  ncl <- gregexpr(".*2100_var.*", cont[[i]]); ncla <- regmatches(cont[[i]], ncl); y100 <- unlist(ncla)
  
  c50 <- raster(y50[1])
  c100 <- raster(y100[1])
  
  for (j in 1:(length(y50) - 1)) {
    c50 <- c50 + raster(y50[j + 1])
    c100 <- c100 + raster(y100[j + 1])
    cat("\tsum", j, "of", (length(y50) - 1), "\n")
  }
  
  c50 <- c50 / length(y50)
  c100 <- c100 / length(y100)
  
  writeRaster(c50, filename = paste0("Model_changes/var_deep_2050_avg", nam[i]), format = "GTiff")
  writeRaster(c100, filename = paste0("Model_changes/var_deep_2100_avg", nam[i]), format = "GTiff") 
  cat("source", i, "of", length(cont), "\n")
}


### Shallow
dir(pattern = "shallow")

dirs <- c("arctic_shallow", "nw_arctic_shallow", "nw_shallow") # are these all?

cont <- list()
for (i in 1:length(dirs)) {
  cont[[i]] <- list.files(path = dirs[i], pattern = "var_emi_scenarios.tif$", full.names = TRUE, recursive = TRUE)
}
cont1 <- list()
for (i in 1:length(dirs)) {
  cont1[[i]] <- list.files(path = dirs[i], pattern = "0_var_replicates.tif$", full.names = TRUE, recursive = TRUE)
}

cont <- unlist(cont)
cont1 <- unlist(cont1)
cont <- list(cont, cont1)
nam <- c("_emi_scenarios.tif", "_replicates.tif")

for (i in 1:length(cont)) {
  ncl <- gregexpr(".*2050_var.*", cont[[i]]); ncla <- regmatches(cont[[i]], ncl); y50 <- unlist(ncla)
  ncl <- gregexpr(".*2100_var.*", cont[[i]]); ncla <- regmatches(cont[[i]], ncl); y100 <- unlist(ncla)
  
  c50 <- raster(y50[1])
  c100 <- raster(y100[1])
  
  for (j in 1:(length(y50) - 1)) {
    c50 <- c50 + raster(y50[j + 1])
    c100 <- c100 + raster(y100[j + 1])
    cat("\tsum", j, "of", (length(y50) - 1), "\n")
  }
  
  c50 <- c50 / length(y50)
  c100 <- c100 / length(y100)
  
  writeRaster(c50, filename = paste0("Model_changes/var_shallow_2050_avg", nam[i]), format = "GTiff")
  writeRaster(c100, filename = paste0("Model_changes/var_shallow_2100_avg", nam[i]), format = "GTiff") 
  cat("source", i, "of", length(cont), "\n")
}
