# EBIO 5420: Computational Biology 
# Prof: Samuel Flaxman
# Student: Lukas Buecherl
# Lab 11
###############################################################################


###############################################################################
# Part 1: Getting set up to work with the data
###############################################################################

# Read in the data
WoodDensity <- read.csv("/Users/lukas/Library/Mobile Documents/com~apple~CloudDocs/CU Boulder/Spring 2021/Computational Biology/CompBioLabsAndHW/Labs/Lab11/GlobalWoodDensityDatabase.csv", stringsAsFactors = F)
# Rename unhandy columname 
colnames(WoodDensity)[4] <- "Density"

###############################################################################
# Part 2: Working with density data
###############################################################################

# Removing rows with missing data
# Finding the rows with NA as density value
row_index <- which(is.na(WoodDensity$Density))
# Delete the rows with NA as density value
WoodDensity <- WoodDensity[-row_index,]


# Dealing with one kind of pseudo-replication
library("dplyr")
# Collapse dataFrame to mean density by species 
DensitybyBinomial <- summarise( group_by(WoodDensity, Binomial, Family), Density = mean(Density),.groups = "drop")
# Check the dimensions 
dim(DensitybyBinomial)[1] == length(unique(WoodDensity$Binomial))

# Contrasting most and least dense families
Family_MeanDensity <- summarise( group_by(DensitybyBinomial, Family), MeanDensity = mean(Density),.groups = "drop")
# Check dimensions 
dim(Family_MeanDensity)[1] == length(unique(WoodDensity$Family))

# Sort the mean desnity by family in decreasing order
Family_MeanDensity_Sorted <- arrange(Family_MeanDensity, desc(MeanDensity))

# Getting the eight families with the highest density
Eight_Highest_Density <- Family_MeanDensity_Sorted[1:8,]

# Getting the eight families with the lowest density
temp <- dim(Family_MeanDensity_Sorted)[1]
Eight_Lowest_Density <- Family_MeanDensity_Sorted[(temp - 7): temp,]


# Part 3: Plotting
###############################################################################
library("ggplot2")

# Plotting densities of most and least dense families with facets
keepRows_highest <- (DensitybyBinomial$Family %in% Eight_Highest_Density$Family)
ggplot(DensitybyBinomial[keepRows_highest,], aes(x = Family, y = Density)) + geom_boxplot() + facet_wrap(facets = ~Family, scale="free_x")

keepRows_lowest <- (DensitybyBinomial$Family %in% Eight_Lowest_Density$Family)
ggplot(DensitybyBinomial[keepRows_lowest,], aes(x = Family, y = Density)) + geom_boxplot() + facet_wrap(facets = ~Family, scale="free_x")


# Facilitating comparison with graphics
ggplot(DensitybyBinomial[keepRows_highest,], aes(x = Family, y = Density)) + geom_boxplot() + coord_flip()
ggplot(DensitybyBinomial[keepRows_lowest,], aes(x = Family, y = Density)) + geom_boxplot() + coord_flip()








