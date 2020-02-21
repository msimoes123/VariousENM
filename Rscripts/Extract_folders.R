#Make folders with csv files of species with  >30 records ----------------------------------------------------
#Note> I created another folder to extract the species and occ that beneficial dataset had _
#The merged datasets of Isopods n>20 occ, is in Ku_ENM2
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp')
#x <- read.csv('deep_shallow_total_dataset.csv') #head(x)
sp <- unique(x_duplicated$name) #str(sp)

for (i in 1:length(sp)) {
  sptable <- x_duplicated[x_duplicated$name == sp[i], cols]
  if (dim(sptable)[1] >= n) {
    dir.create(paste(sp[i], collapse = "_"))
    file.copy(from=currentfiles, to=newlocation,               overwrite = TRUE, recursive = FALSE, 
              copy.mode = TRUE)
    write.csv(sptable, paste(paste(sp[i], collapse = '_'), '\\',
                             paste(sp[i], collapse = '_'), ".csv", sep = ""), row.names = FALSE)
  }
  
}

path <- 'C:\\Users\\admin\\Desktop\\Anja'
path2 <- 'C:\\Users\\admin\\Desktop\\test'
file.copy(from=path, to=path2, 
          overwrite = TRUE, recursive = FALSE, 
          copy.mode = TRUE)
current_folder <- "C:/Users/Bhabani2077/Desktop/Current"
new_folder <- "C:/Users/Bhabani2077/Desktop/Ins"
list_of_files <- list.files(current_folder, ".py$") 
# ".py$" is the type of file you want to copy. Remove if copying all types of files. 
file.copy(file.path(current_folder,list_of_files), new_folder)