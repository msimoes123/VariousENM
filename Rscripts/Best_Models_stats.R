#Best Models Statitics--------------------------
#we transferred all folders to a file in desktop to run kuenm

setwd('E:\\nw_deep') #Directory containing the folders of species

folders <- dir()[file.info(dir())$isdir]  #Name of folders
exclude <- c("Variables", "G_variables")  #exclude g_variables and variables
folders <- folders[!folders %in% exclude]  #folders minus g_variables and variables
df<-NULL
#i=1
for (i in 1:length(folders)) {
  
  best <- list.files(path = paste(folders[i], "Calibration_results1", sep = "/"), #list files csv inside calibrartion 1
                     pattern = "best", full.names = TRUE)
 
  best1 <- read.csv(best)
  
  df <- rbind(df, best1) #Row bind 
  
}  

write.csv(df, 'E:\\Best_nw_shallow.csv', row.names=F) #write csv with the info gathered after rbind
