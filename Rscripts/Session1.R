library(kuenm)

setwd("D:\\MODELS_Ready\\nw_shallow")
dir()

spvec <- dir()
exclude <- c("Variables", "G_variables")
spvector <- spvec[!spvec %in% exclude]
sp1 <- spvector[21:27] # others are [27:63] and [64:78]
sp2 <- gsub(" ", "_", sp1)

sp_name <- sp2
fmod_dir <- paste(sp1, "Final_Models", sep = '/')
format <- "asc"
project <- TRUE
stats <- c("med", "range")
rep <- TRUE
scenarios <- c("present", "2050_rcp26", "2050_rcp85", "2100_rcp26", "2100_rcp85")
ext_type <- c("EC") # you can select only one type of extrapolation if needed
out_dir <- paste(sp1, "Final_Model_Stats", sep = '/')

# other arguments were defined before
occ <- paste(sp1, paste(sp1, "joint.csv", sep = '_'), sep = "/")
thres <- 5
curr <- "present"
emi_scenarios <- c("rcp26", "rcp85")
t_periods <- c("2050", "2100")
out_dir1 <-  paste(sp1, "Projection_Changes", sep = '/')
split <- 200 #partitioning the stack of models of different scenarios
out_dir2 <- paste(sp1, "Variation_from_sources", sep = '/')
i=1
for (i in 1:length(sp1)) {
  if(i != 1)    {
    kuenm_modstats(sp.name = sp_name[i], fmod.dir = fmod_dir[i], format = format, project = project, 
                   statistics = stats, replicated = rep, proj.scenarios = scenarios, 
                   ext.type = ext_type, out.dir = out_dir[i]) 
  }
  
  #kuenm_projchanges(occ = occ[i], fmod.stats = out_dir[i], threshold = thres, 
  #                  current = curr, emi.scenarios = emi_scenarios,  
  #                  time.periods = t_periods, ext.type = ext_type, out.dir = out_dir1[i])
  
  # kuenm_modvar(sp.name = sp_name[i], fmod.dir = fmod_dir[i], replicated = rep, format = format,  
  #             project = project, current = curr, emi.scenarios = emi_scenarios, 
  #             time.periods = t_periods, ext.type = ext_type, split.length = split, out.dir = out_dir2[i])
  
  cat("\n\nAnalyses for species", i, "of", length(sp1), "finished\n")
}