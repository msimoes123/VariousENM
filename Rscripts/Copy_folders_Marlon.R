# Getting info for mops out

# directory
setwd("E:\\")

dirs <- list.dirs(recursive=F, full.names = F)[c(-1,-7,-8,-9)] # folders with groups MAKE SURE THERE IS NOTHING ELSE THAN GROUP FOLDERS IN THIS DIRECTORY


dir.create("MOP_Marianna") # new directory, info for mops

for (i in 1:length(dirs)) {
  # existent directories
  spvec <- dir(dirs[i], full.names = TRUE)
  exclude <- paste0(dirs[i], c("/Variables", "/G_variables"))
  spvector <- spvec[!spvec %in% exclude]
  
  # new directories
  spnames <- gsub(paste0(dirs[i], "/"), "", spvector)
  dir.create(paste0("MOP_Marianna/", dirs[i]))
  
  # copy G_variables
  dir.create(paste0("MOP_Marianna/", dirs[i], "/G_variables"))
  sets <- dir(paste0(dirs[i], "/G_variables"))
  
  for (j in 1:length(sets)) {
    dir.create(paste0("MOP_Marianna/", dirs[i], "/G_variables/", sets[j]))
    
    scens <- dir(paste0(dirs[i], "/G_variables/", sets[j]))
    
    for (k in 1:length(scens)) {
      dir.create(paste0("MOP_Marianna/", dirs[i], "/G_variables/", sets[j], "/", scens[k]))
      
      ascs <- list.files(path = paste0(dirs[i], "/G_variables/", sets[j], "/", scens[k]),
                         pattern = ".asc$", full.names = TRUE)
      ascsn <- list.files(path = paste0(dirs[i], "/G_variables/", sets[j], "/", scens[k]),
                          pattern = ".asc$")
      
      newascs <- paste0(paste0("MOP_Marianna/", dirs[i],  "/G_variables/", sets[j], "/", scens[k], "/", ascsn))
      
      file.copy(from = ascs, to = newascs)
      
    }
    cat('\t',j, "of", length(sets), '\n')
  }
  
  

  for (j in 1:length(spvector)) {
    # new directory inside new directory
    dir.create(paste0("MOP_Marianna/", dirs[i], "/", spnames[j]))
    
    # calibration result
    dir.create(paste0("MOP_Marianna/", dirs[i], "/", spnames[j],  "/Calibration_results1"))# CHECK NAME!!!!!!!!!!!
    
    files <- list.files(path = paste0(dirs[i], "/", spnames[j], "/Calibration_results1"), pattern = "best", full.names = TRUE)# CHECK NAME!!!!!!!!!!!
    filesn <- list.files(path = paste0(dirs[i], "/", spnames[j],  "/Calibration_results1"), pattern = "best")# CHECK NAME!!!!!!!!!!!
    
    newfiles <- paste0(paste0("MOP_Marianna/", dirs[i], "/", spnames[j],  "/Calibration_results1/", filesn))# CHECK NAME!!!!!!!!!!!
    
    file.copy(from = files, to = newfiles)
    
    # M variables
    dir.create(paste0("MOP_Marianna/", dirs[i], "/", spnames[j],  "/M_variables"))
    
    sets <- dir(paste0(dirs[i], "/", spnames[j], "/M_variables"))
    
    for (k in 1:length(sets)) {
      dir.create(paste0("MOP_Marianna/", dirs[i],"/", spnames[j], "/M_variables/", sets[k]))
      
      ascs <- list.files(path = paste0(dirs[i], "/", spnames[j], "/M_variables/", sets[k]),
                         pattern = ".asc$", full.names = TRUE)
      ascsn <- list.files(path = paste0(dirs[i], "/", spnames[j], "/M_variables/", sets[k]),
                          pattern = ".asc$")
      
      newascs <- paste0(paste0("MOP_Marianna/", dirs[i], "/", spnames[j], "/M_variables/", sets[k], "/", ascsn))
      
      file.copy(from = ascs, to = newascs)
    }
    cat('\t',j, "of", length(spvector), '\n')
  }
  cat(i, "of", length(dirs), '\n')
}
