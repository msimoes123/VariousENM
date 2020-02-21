#Extracting the species of Hanis list from the folder of potential species to be modeled
#8/23/2019
setwd("C:\\Users\\admin\\Desktop\\Mollusca_\\datasets\\Subset\\Final_shallow_deep\\30\\Final_shallow1") # Your folder

path <- "C:\\Users\\admin\\Desktop\\Mollusca_\\datasets\\Subset\\Final_shallow_deep\\30\\Potential_Shallow\\"

spvector <- as.character(read.csv("C:\\Users\\admin\\Desktop\\Mollusca_\\datasets\\Subset\\Final_shallow_deep\\30\\Mollusc_Modeling_NOGastNOBiv.csv")[, 1])# binomial names

folder <-list()

j=1
i=1
for (i in 1:length(spvector)) {
  folder <-  paste0("C:\\Users\\admin\\Desktop\\Mollusca_\\datasets\\Subset\\Final_shallow_deep\\30\\Potential_Shallow\\",
                                     spvector[i], '\\')
  for (j in 1:length(folder)) {
  csv <-  read.csv(paste(folder[j], spvector[i], '.csv', sep=''))
  csv$Maxdepth <- NULL
  dir.create(paste(spvector[i], collapse = "_"))
  write.csv(csv, paste(paste(spvector[i], collapse = '_'), '\\',
                            paste(spvector[i], collapse = '_'), ".csv", sep = ""), row.names = FALSE)
  
  }
}
