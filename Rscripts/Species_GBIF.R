
##Code to extract GBIF, OBIS, BENEFICIAL- merge, split, bend datasets-----------------
#Simoes, MVP
# Multiple species GBIF ---------------

##
# loading needed package
if(!require(rgbif)){
  install.packages("rgbif")
  library(rgbif)
}


# defining working directory
## project forlder
setwd("C:\\Users\\admin\\Desktop\\Crusti_New") # Your folder

x<-read.csv('NW_spp.csv')
dim(x1)
x1<-unique(x$scientific)
write.csv(x1, 'NW_uniq_spp.csv')
x2 <- read.csv('NW_uniq_spp.csv')

spvector <- as.character(read.csv("NW_uniq_spp.csv")[, 1])# binomial names

## Getting info species by species 
occ_count <- list() # object to save info on number of georeferenced records per species 

for (i in 1:length(spvector)) {
  sps <- try(name_lookup(query = spvector[i], rank = "species", 
                         return = "data", limit = 100), silent = TRUE) # information about the species
  
  sps_class <- class(sps)
  
  # avoiding errors from GBIF (e.g., species name not in GBIF)
  if(sps_class[1] == "try-error") {
    occ_count[[i]] <- c(Species = spvector[i], keys = 0, counts = 0) # species not in GBIF
    cat("species", spvector[i], "is not in the GBIF database\n")
    
  }else {
    keys <- sps$key # all keys returned
    counts <- vector() # object to save info on number of records per key
    
    for (j in 1:length(keys)) { # testing if keys return records
      counts[j] <- occ_count(taxonKey = keys[j], georeferenced = TRUE) 
    }
    
    if (sum(counts) == 0) { # if no info, tell the species
      occ_count[[i]] <- c(Species = spvector[i], keys = "all", counts = 0) # species not in GBIF
      cat("species", spvector[i], "has no goereferenced data\n")
      
    }else { # if it has info, use the key with more records, which is the most useful
      if (length(keys) == 1) { # if it is only one key
        key <- keys # detecting species key 
        occ_count[[i]] <- cbind(spvector[i], counts) # count how many records
        
      }else { # if its more than one key
        keysco <- cbind(keys, counts)
        keysco <- keysco[order(keysco[, 2]), ]
        key <- keysco[dim(keysco)[1], 1] # detecting species key that return information
        occ_count[[i]] <- c(Species = spvector[i], keysco[dim(keysco)[1], ])# count how many records
      }
      
      occ <- try(occ_search(taxonKey = key, return = "data", limit = 10000), silent = TRUE) # getting the data from GBIF
      occ_class <- class(occ)
      
      # avoiding errors from GBIF
      while (occ_class[1] == "try-error") {
        occ <- try(occ_search(taxonKey = key, return = "data", limit = 10000), silent = TRUE) # getting the data from GBIF
        occ_class <- class(occ)
        
        if(occ_class[1] != "try-error") {
          break()
        }
      }
      
      # following steps
      occ_g <- occ
      occ_g <- occ_g[, c(1, 2, 4, 3, 5:dim(occ_g)[2])] # reordering longitude and latitude
      
      # keeping only unique georeferenced records. IF NO FILTERING IS NEEDED, PUT A # IN FRONT OF THE NEXT 3 LINES
      occ_g <- occ_g[!is.na(occ_g$decimalLatitude) & !is.na(occ_g$decimalLongitude), ] # excluding no georeferences
      occ_g <- occ_g[!duplicated(paste(occ_g$name, occ_g$decimalLatitude, # excluding duplicates
                                       occ_g$decimalLongitude, sep = "_")), ]
      
      # writting file
      file_name <- paste(gsub(" ", "_", spvector[i]), "csv", sep = ".") # csv file name per each species
      write.csv(occ_g, file_name, row.names = FALSE) # writing inside each genus folder
      
      cat(i, "of", length(spvector), "species\n") # counting species per genus 
    }
  }
}

genus_data <- do.call(rbind, occ_count) # making the list of countings a table
genus_data <- data.frame(genus_data[, 1], genus_data[, 2], as.numeric(genus_data[, 3])) # making countings numeric
names(genus_data) <- c("Species", "Key", "N_records") # naming columns

# writing the table
file_nam <- "Species_record_count.csv" # csv file name for all species
write.csv(genus_data, file_nam, row.names = FALSE) # writing inside each genus folder

##Merging  files from gbif--------------------------------------------
##Extracting Name, Long, Lat from all csv files 
##When the list of species is too long (e.g.3000), it stops and I have to re-run the code to finish up 
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\gbif\\Mariana\\Mariana') ##setting path
path <- "C:\\Users\\admin\\Desktop\\Crusti_New\\gbif\\Mariana\\Mariana\\csv\\"
filenames <- list.files(path= path, full.names=TRUE)
spvector <- filenames

for (i in 1:length(spvector)) {
  all <- read.csv(paste(spvector[i], sep = ","))
  myvars <- c("name", "decimalLongitude", "decimalLatitude")
  table <- all[myvars]
  write.csv(table, paste(spvector[i], ".csv", sep = ""),row.names = FALSE)
}  


##Merging files from GBIF ---------------------------------------
#sp_list <- list(list.files("C:\\Users\\admin\\Desktop\\Crusti_New\\gbif\\Mariana\\Mariana\\", pattern = ".csv", full.names = TRUE))
              
# Grab the filienames,
path <- "C:\\Users\\admin\\Desktop\\Crusti_New\\gbif\\Mariana\\Mariana\\csv\\"
filenames <- list.files(path= path, full.names=TRUE)

All <- lapply(filenames,function(filename){
  print(paste("Merging",filename,sep = " "))
  read.csv(filename)
})
#rbind all files
df <- do.call(rbind.data.frame, All)
write.csv(df,'C:\\Users\\admin\\Desktop\\Crusti_New\\gbif\\Mariana\\Mariana\\csv\\gbif_dataset.csv')



##OBIS data------------------------------------------------------
# CRAN
install.packages("robis")
library(robis)
# latest development version
install.packages("devtools")
devtools::install_github("iobis/robis")

setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\obis')
sp <- read.csv("NW_uniq_spp_2.csv", stringsAsFactors = FALSE)
dim(sp)
names <- sp$scientific[1:3416]

spdata <- lapply(names, function(name) {
  
  message(name)
  
  return(robis::occurrence('Crustacea'))
  
})

data <- dplyr::bind_rows(spdata)


#Loading data downloaded by peter -----------------------------------------------------------
#All crustacea from our list of species from teh NW Pacific
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\obis')
load('obis.dat')
head(data) 
str(data)
#Subsetting Obis dataset -
write.csv(data, 'obis.csv')
x<-read.csv('obis.csv', header = T)
str(x)
myvars <-c('class', 'order', 'family', 'genus', 'scientificName', 'species', 'decimalLongitude', 'decimalLatitude') #subsetting Obis columns 
obis_thin <- x[myvars] #creating obis_thin dataframe
head(obis_thin)
str(obis_thin)
# Number of species in the 
length(unique(obis_thin[["scientificName"]])) #Obis had 3087 species out of from 3416 species in our list 'NW_uniq_spp_2.csv' - I used the colum scientific na,mes instead of species bcs it has the complete name of teh species
write.csv(obis_thin, 'obis_thin.csv')

#Merging OBIS to GBIF
cols<-c('scientificName', 'decimalLongitude', 'decimalLatitude')
obis_thin_merge <- obis_thin[cols] 
colnames(obis_thin_merge) <- c('name', 'decimalLongitude', 'decimalLatitude')
head(obis_thin_merge)
dim(obis_thin_merge)
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\obis')
write.csv(obis_thin_merge, 'obis_thin_merge.csv', row.names=F)

#import Gbif dataset 
gbif <- read.csv('C:\\Users\\admin\\Desktop\\Crusti_New\\gbif\\Mariana\\Mariana\\csv\\GBIF_result\\gbif_dataset.csv')
str(gbif)
dim(gbif)
NW_Crustis <- merge(obis_thin_merge, gbif)
head(NW_Crustis)
write.csv(NW_Crustis, 'C:\\Users\\admin\\Desktop\\Crusti_New\\Obis_Gbif_NW_Crust.csv')

#Merging beneficial--------------------
#Subsetting name, longitude and Latitude from each file .csv
path <- "C:\\Users\\admin\\Desktop\\Crusti_New\\Beneficial\\Subset_csv\\"
filenames <- list.files(path= path, pattern = ".csv", full.names=TRUE)
spvector <- filenames
head(filenames)

for (i in 1: length(spvector)) {
  all <- read.csv(paste(spvector[i], sep = ","))
  myvars <- c("scientific", "decimalLon", "decimalLat") #gotta change the names_molacostraca has differnt names
  table <- all[myvars]
  write.csv(table, paste(spvector[i], ".csv", sep = ""),row.names = FALSE)
}  

#Merging all beneficial-------------------

library(dplyr)
library(readr)

df <- list.files(path= path, pattern = ".csv", full.names=TRUE) %>% 
  lapply(read_csv) %>% 
  bind_rows
head(df)
colnames(df) <- c('name', 'decimalLongitude', 'decimalLatitude')
write.csv(df, 'beneficial.csv') #exclude firts column manually

#Merging all beneficial_GBIF_OBIS---------------
path3 <- "C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\"
all <- list.files(path= path3, pattern = ".csv", full.names=TRUE) %>% 
  lapply(read_csv) %>% 
  bind_rows
str(all)
setwd("C:\\Users\\admin\\Desktop\\Crusti_New\\Total")
write.csv(all, 'total_dataset.csv', row.names = F)

#Subsetting Deep and Shallow from the total dataset---------------
#deep <- read.csv("C:\\Users\\admin\\Desktop\\Crusti_New\\List_deep.csv", header=T)
#shallow <- read.csv("C:\\Users\\admin\\Desktop\\Crusti_New\\List_shallow.csv", header=T)
#total <- read.csv('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\deep_shallow_total_dataset.csv', header=T)
#retain <- deep$scientific
#deep_total <- total[total$name %in% retain, ] #retain the vector created #1154937 obs
#write.csv(deep_total,'C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\deep_total.csv', row.names = F)
#retain_shallow <- shallow$scientific
#shallow_total <- total[total$name %in% retain_shallow, ] #2655955 obs head(shallow_total)
#write.csv(shallow_total,'C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\shallow_total.csv', row.names = F)

#Excluding duplicates from total -----------------------------------------------
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total')

x <- read.csv('deep_shallow_total_dataset.csv', header=T)
head(x)
dim(x)
x_duplicated <- x[!duplicated(paste(x$name, x$decimalLongitude, # excluding duplicates
                                    x$decimalLatitude, sep = "_")), ]
head(x_duplicated)
dim(x_duplicated)
write.csv(x_duplicated, "Crust_total_unique.csv", row.names = F)


#Make folders with csv files of species with  >30 records ----------------------------------------------------
#Note> I created another folder to extract the species and occ that beneficial dataset had _
#The merged datasets of Isopods n>20 occ, is in Ku_ENM2
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp')
#x <- read.csv('deep_shallow_total_dataset.csv') #head(x)
sp <- unique(x_duplicated$name) #str(sp)

n = 30 #number of records 
cols = 1:3 # columns extracted from dataset - species, long, lat
for (i in 1:length(sp)) {
  sptable <- x_duplicated[x_duplicated$name == sp[i], cols]
  if (dim(sptable)[1] >= n) {
    dir.create(paste(sp[i], collapse = "_"))
    write.csv(sptable, paste(paste(sp[i], collapse = '_'), '\\',
                             paste(sp[i], collapse = '_'), ".csv", sep = ""), row.names = FALSE)
  }
  
}

#make a excel / csv list  with names of species with more than 30occ ----------------------------------------------------

path <- 'C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\'
list_total_spp<-list.files(path = path, pattern = NULL, all.files = FALSE,
                           full.names = FALSE, recursive = FALSE,
                           ignore.case = FALSE, include.dirs = FALSE)
str(list_total_spp)
write.csv(list_total_spp, 'list_total_suitable_30.csv', row.names = F)

#Worms- to ger orders--------

#Subsetting Deep and Shallow from the worms list ---------------
deep <- read.csv("C:\\Users\\admin\\Desktop\\Crusti_New\\List_deep_matched.csv", header=T)
deep <- deep$ScientificName
str(deep) #1024
shallow <- read.csv("C:\\Users\\admin\\Desktop\\Crusti_New\\List_shallow_matched.csv", header=T)
shallow <- shallow$ScientificName
str(shallow) #2744
worms <- read.csv('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\list_total_suitable_30_worms.csv', header=T)
head(worms)  #1505 species with exact match 

#retain_deep <- deep$scientific
#str(retain_deep) #1024
#deep_suitable <- worms[worms$ScientificName %in% deep, ] #str(deep_suitable)
#str(deep_suitable)
#retain <- shallow$scientific

#shallow_suitable <- worms[worms$ScientificName %in% shallow, ] #str(shallow_suitable)

#intersection <- intersect(deep_suitable$ScientificName, shallow_suitable$ScientificName)# 357 intersection_deep and shallow share 403 species
#str(intersection) # 357 intersection_deep and shallow share 
#write.csv(intersection, 'intersection_overlap.csv', row.names = F)

##Create list of endemic specie sto shallow and deep 
#deep_potential3 - intesection
#shallow_potential3 - intersection 

#intersection <- read.csv('intersection_overlap.csv', header=T)
#str(intersection)
#intersection_omit <- intersection$x

##deep_unique <- deep_suitable[!deep_suitable$ScientificName %in% intersection_omit, ] #exclude species that intersect
#str(deep_unique)
#unique(deep_unique$ScientificName)
#shallow_unique <- shallow_suitable[!shallow_suitable$ScientificName %in% intersection_omit, ]
#str(shallow_unique)
#setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp')
#write.csv(deep_unique, 'deep_unique.csv', row.names=F)
#write.csv(shallow_unique, 'shallow_unique.csv', row.names=F)

#Organize by Zone of occurence_shallow_deep------------------------
#Getting LongLat for the species that are unique for shallow and deep from the tble with all clean occurences-------
#setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\subset_area\\nw_arctic_spp')
#total <- read.csv('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Crust_total_unique.csv', header=T) #all records with no duplicates
#head(total)
library(dplyr)
#deep
deep_unique <- read.csv('C:\\Users\\admin\\Desktop\\Crusti_New\\List_deep_exceledit_final.csv', header=T) #all records with no duplicates
deep_unique_spp <-deep_unique$ScientificName
str(deep_unique_spp)
total <- read.csv('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Crust_total_unique.csv')
occ <-total %>% filter(total$name %in% deep_unique_spp) #occ= deep species accourences - extract from total, the rows that match the names in the colum of deep_uniue_spp
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\subset_area')
write.csv(occ, 'deep_unique_occ.csv', row.names=F) #occurence of species that only occour in the deep sea
unique(occ$name) #181 species 
str(total)

#shallow
shallow_unique <- read.csv('C:\\Users\\admin\\Desktop\\Crusti_New\\List_shallow_exceledit_final.csv', header=T) #all records with no duplicates
shallow_unique_spp <-shallow_unique$ScientificName
str(shallow_unique_spp)
occ_s <-total %>% filter(total$name %in% shallow_unique_spp) #occ_s= shallow unique species accourences - 
head(occ_s)
unique(occ_s$name)
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\subset_area')
write.csv(occ_s, 'shallow_unique_occ.csv', row.names=F) #occurence of species that only occour in the deep sea

#Subset into Geographic regions
#1. NW_Arctic --------------
#simply subset from the common species list that nils  created
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\subsets\\nw_arctic_spp')
nw_arctic_spp <- read.csv('nw_arctic_spp.csv') #205 species btw NW and Arctic
dim(nw_arctic_spp)
nw_arctic_spp <-nw_arctic_spp$name
deep_nw_arctic <- occ %>% filter(occ$name %in% nw_arctic_spp) #extract from species unique to deep (occ), the species that are shared between Arctic and NW
shallow_nw_arctic <- occ_s %>% filter(occ_s$name %in% nw_arctic_spp)
str(deep_nw_arctic)
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\subset_area\\nw_arctic_spp')
write.csv(deep_nw_arctic, 'deep_nw_arctic.csv', row.names=F)
write.csv(shallow_nw_arctic, 'shallow_nw_arctic.csv', row.names=F)

#2. Subset Arctic----------------------
#WORK PLAN: 
#All species - decimalLat >70 = Arctic spp
#Arctic spp - shared species = Arctic unique
#Arctic unique : subset into DEEP and SHALLOW
#filter from total (deep_shallow_total_dataset.csv), all species that occour higher than 70
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\subset_area\\arctic_spp')
arctic <-filter(total, decimalLatitude > 70)  #subseting species that occour in the arctic from all species
head(arctic)
#subsetting arctic fauna =  arctic - common species (shared species btw NW and arctic)
#arctic (arctic) - common species between nw pacific (nw_arctic_spp)
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\subset_area\\nw_arctic_spp')
nw_arctic_spp <- read.csv('nw_arctic_spp.csv')
exclude <-nw_arctic_spp$name

arctic_endemic <- arctic[!arctic$name %in% exclude, ] #exclude species that intersect on NW and arctic #total list of species from the arctic

#2. extract deep species from arctic_endemic species 
retain <- occ$name
deep_arctic_endemic <- arctic_endemic %>% filter(arctic_endemic$name %in% retain) #from the species that are unique to the deep (retain- occ$name), exclude the ones that are ashared between NW and arctic -endemic deep arctic
str(deep_arctic_endemic)

retain <- occ_s$name #names on list of species restricted to shallow
shallow_arctic_endemic <- arctic_endemic %>% filter(arctic_endemic$name %in% retain) #from the species that are unique to the shallow (retain- occ$name), exclude the ones that are ashared between NW and arctic -endemic deep arctic
str(shallow_arctic_endemic)
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\subset_area\\arctic_spp')
write.csv(deep_arctic_endemic, 'deep_arctic_endemic.csv', row.names=F)
write.csv(shallow_arctic_endemic, 'shallow_arctic_endemic.csv', row.names=F)


#3. Subset NW----------------
#WORK PLAN: 
#All species - decimalLat <70 = NW spp
#NW spp - shared species = NW unique
#NW unique : subset into DEEP and SHALLOW
#filter from total (deep_shallow_total_dataset.csv), all species that occour lower than 70
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\subsets\\nw_spp')
nw <-filter(total, decimalLatitude < 70)  #subseting species that occour in the arctic from all species
head(nw)
#subsetting arctic fauna =  arctic - common species (shared species btw NW and arctic)
#NW (NW) - common species between nw pacific (nw_arctic_spp)
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\subsets\\nw_arctic_spp')
nw_arctic_spp <- read.csv('nw_arctic_spp.csv')
exclude <-nw_arctic_spp$name

nw_endemic <- nw[!nw$name %in% exclude, ] #exclude species that intersect on NW and arctic #total list of species from the arctic

#extract deep species from arctic_endemic species 
retain <- occ$name
deep_nw_endemic <- nw_endemic %>% filter(nw_endemic$name %in% retain) #from the species that are unique to the deep (retain- occ$name), exclude the ones that are ashared between NW and arctic -endemic deep arctic
head(deep_nw_endemic)

retain <- occ_s$name #names on list of species restricted to shallow
shallow_nw_endemic <- nw_endemic %>% filter(nw_endemic$name %in% retain) #from the species that are unique to the shallow (retain- occ$name), exclude the ones that are ashared between NW and arctic -endemic deep arctic
str(shallow_nw_endemic)
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\subsets\\nw_spp')
write.csv(deep_nw_endemic, 'deep_nw_endemic.csv', row.names=F)
write.csv(shallow_nw_endemic, 'shallow_nw_endemic.csv', row.names=F)

##Create order lists for each area subset 
###make taxon match Wormswith the list of species with more than 20occ ----------------------------------------------------
##Loop creates files with list of species for each order- for deep and shallow
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\subsets\\arctic_spp')

deep_arctic <- read.delim("deep_arctic_endemic_worms_matched.txt", sep = ',')
deep_arctic$Order
shallow_arctic <-  read.delim("shallow_arctic_endemic_worms_matched.txt", sep = ',')
shallow_arctic$Order

spvector<-unique(deep_arctic$Order)
spvector<-unique(shallow_arctic$Order)
#Loop creates files with list of species for each order- for deep and shallow
#isopoda_deep <- deep[which(deep$Order=='Isopoda'),]
#decapoda_deep <- deep[which(deep$Order=='Decapoda'),]
#dim(decapoda_deep)
#Here, we are creating order files to see how many species we have to be used in models for each order
#With this we evealuate whic are the orders that are relevant to be included in the study
species <- read.delim('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\subset_area\\Area_subset\\nw_arctic_spp\\shallow_nw_arctic_worms_matched.txt', sep=',') #table hat contains column with taxa ranking
head(species)

setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\subset_area\\Area_subset\\nw_arctic_spp\\orders_shallow')
spvector<-unique(species$Order) #subset order from the table with taxa ranking

for (i in 1: length(spvector)) {
  order <- species[which(species$Order== spvector[i]),]  #subsetting species per order 
  write.csv(order, paste(spvector[i], ".csv", sep = ""),row.names = FALSE)
}  


#Adding long and Lat to list of Decapods so we can subset the groups  of decapods from shallow NW (588 spp)------------------------
setwd('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\subset_area\\Area_subset\\nw_spp\\orders_deep_nw')
total <- read.csv('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\deep_shallow_total_dataset.csv', header=T) #str(decapods)
amphiopoda <- read.csv('C:\\Users\\admin\\Desktop\\Crusti_New\\Total\\Suitable_spp\\subset_area\\Area_subset\\nw_spp\\orders_deep_nw\\nw_deep.csv', header=T)

decapods_long_lat <-merge.data.frame(amphiopoda, total, by.x = 'species', by.y = 'name')
dim(decapods_long_lat)
write.csv(decapods_long_lat, 'nw_deep.csv', row.names=F)
