setwd("Your directory")

install.packages('devtools')
devtools::install_github("marlonecobos/kuenm", force=T) #pay attention to the numbers that will show ion your screen. Try to always update all packages
install.packages('raster')
install.packages('rgeos')
library(raster)
library(rgeos)
library(kuenm)


#calls M variables
mvars <- raster::stack(list.files(system.file("extdata", package = "kuenm"),
                                  pattern = "Mbio_", full.names = TRUE))

#calls areas or scenarios to which areas were transferred
gvars <- raster::stack(list.files(system.file("extdata", package = "kuenm"),
                                  pattern = "Gbio_", full.names = TRUE))

#percent of values sampled from te calibration region to calculate the MOP.								  
perc <- 10

mop <- kuenm_mop(M.stack = mvars, G.stack = gvars, percent = perc)

raster::plot(mop)