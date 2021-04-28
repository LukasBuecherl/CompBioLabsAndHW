# EBIO 5420: Computational Biology
# Professor: Samuel Flaxman
# Student: Lukas Buecherl
# Final Project
###############################################################################

# Clear Environment 
rm(list = ls())

#################################################################
# Step 0: Get packages
#################################################################

# Setting the path for the working directory (Needs to be adjusted)
setwd(
  "/Users/lukas/Library/Mobile Documents/com~apple~CloudDocs/CU Boulder/Spring 2021/Computational Biology/CompBioLabsAndHW/Final_Project"
)

# Require needed packages
require("tidyverse")
require("ggpubr")
library("ggplot2")
library("dplyr")

# Source the lib file for accessing functions
source("lib.R")

#################################################################
# Step 1: Clean and check data
#################################################################


# Read in the data
WoodData <-
  read.csv(
    "sample_tree_growth_data_with_locations.csv",
    stringsAsFactors = F
  )

# Checking for NA
if (length(which(is.na(WoodData))) != 0) {
  print("NAs found")
  NA_index <- which(is.na(WoodData))
}

# Data overview
str(WoodData)

# Extract the important data for the project (ID, Secies, Year, Latitude, Elevation, Ring width, Stem diameter)
# Sort the data according to the tree ID and the year
Wood_Data_Im <-
  select(
    WoodData,
    Sample.tree.ID,
    Species,
    Year,
    Latitude,
    Elevation..m.,
    Ring.width..mm.,
    Stem.diameter..cm.
  ) %>%
  arrange(Sample.tree.ID, Year)

# Check for duplicated rows, if found delete duplicate rows
if (length(which(duplicated(Wood_Data_Im) == TRUE)) != 0) {
  Wood_Data_Im <- Wood_Data_Im %>% distinct()
}

# Check if numbers of entries for each year match (i.e. for every year there should be the same number of rows)
# Preallocate a vector and count all the occurrences belonging to a year
years <- unique(Wood_Data_Im$Year) %>% sort(decreasing = FALSE)
occ_years <- rep(NA, length(years))

# Find all rows for year (i.e. year = 1992 find all rows with year 1992)
for (i in 1:length(years)) {
  occ_years[i] <- length(which(Wood_Data_Im$Year == years[i]))
}

# If not all the years have the same number of rows
if (length(unique(occ_years)) != 1) {
  # Select the year with the fewest rows
  fewest_year <- years[which.min(occ_years)]
  
  # Find the index of the individual tree that is missing a row
  # Iterate over the whole dataset 
  # Check for every row after the row of the fewest year if the previous row is the fewest year
  # i.e. if fewest year is 1992 check for every row of 1993 if the row before it is 1992 
  # If that is not the case save the index
  for (i in 1:length(Wood_Data_Im$Year)) {
    if (Wood_Data_Im$Year[i] == fewest_year + 1) {
      if (Wood_Data_Im$Year[i - 1] != fewest_year) {
        index <- i
      }
    }
  }
}

# Delete the rows of the individual with the missing entry
# Calculate the number of rows that need to be deleted
del_rows <- max(years) - min(years) - 1

# Delete the rows from the found index up to the last entry of that individual tree
Wood_Data_Im <- Wood_Data_Im[-1 * seq(i, i + del_rows), ]



# There are many typos in the dataset. With the delete function the user can
# specify the minimum ring width (mm) and the minimum stem diameter (cm) that
# the individual trees are required to have
# i.e. some trees have one entry of 0.0006 mm as ring width which impossible
Wood_Data_Im <- Delete(Wood_Data_Im, 0.05, 0)


#################################################################
# Step 2: Reformatting the data and calculating the growth rate
#################################################################

# Store the names of the species 
Species_names <- unique(Wood_Data_Im$Species)

# Create a new matrix and fill it with the data
# Add two columns to the matrix to store the growth rate for the ring width and the stem diameter
Wood_Data_Growth_Rate <-
  cbind(Wood_Data_Im, matrix(nrow = dim(Wood_Data_Im)[1], ncol =  2))
colnames(Wood_Data_Growth_Rate) <-
  c(colnames(Wood_Data_Im), "GrowthRateRing", "GrowthRateStem")

# Calculate the growth rate of the ring width and the stem diameter by looping over the whole data frame
for (i in 1:dim(Wood_Data_Growth_Rate)[1]) {
  
  # The first year does not have a previous year for reference so set it to 0 (won't be plotted later)
  if (Wood_Data_Growth_Rate$Year[i] == min(Wood_Data_Growth_Rate$Year)) {
    Wood_Data_Growth_Rate$GrowthRateRing[i] = 0
    Wood_Data_Growth_Rate$GrowthRateStem[i] = 0
    
  } else{
  # Calculate the growth rate by: (MeasurementCurrentYear - MeasurementYearBefore) / |MeasurementYearBefore|
  # Store the result in the data frame in the two added columns
    Wood_Data_Growth_Rate$GrowthRateRing[i] = (
      Wood_Data_Growth_Rate$Ring.width..mm.[i] -  Wood_Data_Growth_Rate$Ring.width..mm.[i - 1]
    ) / abs(Wood_Data_Growth_Rate$Ring.width..mm.[i - 1])
    Wood_Data_Growth_Rate$GrowthRateStem[i] = (
      Wood_Data_Growth_Rate$Stem.diameter..cm.[i] - Wood_Data_Growth_Rate$Stem.diameter..cm.[i - 1]
    ) / abs(Wood_Data_Growth_Rate$Stem.diameter..cm.[i - 1])
    
  }
}

#################################################################
# Step 3: Analyzing the Ring Growth Rate by Latitude
#################################################################

# Select a threshold for the Latitude (I chose the median) that is used to divide the data in two categories (one below and one above the threshold)
latitude_treshold <- round(median(Wood_Data_Growth_Rate$Latitude))

# Condition for separating the data
con <-  Wood_Data_Growth_Rate$Latitude >= latitude_treshold

# Calculates the average of all individuals per species per year that fulfill the condition (i.e. returns a matrix with rows = number of years and col = number of species
# and the rows contain the average growth rate in that year of individuals of the different species that fulfill the condition (here latitude >= 40))
Ring_Growth_Lat_over_40 <-
  Calculate_Growth_Ring(Wood_Data_Growth_Rate, con, Species_names)

# Condition for separating the data
con <-  Wood_Data_Growth_Rate$Latitude < latitude_treshold

# Calculates the average of all individuals per species per year that fulfill the condition
Ring_Growth_Lat_under_40 <-
  Calculate_Growth_Ring(Wood_Data_Growth_Rate, con, Species_names)

# First plot for fulfilling the first condition (growth rate of trees below the threshold)
p_ring_under_40 <-
  ggplot(data.frame(Ring_Growth_Lat_under_40), aes(x = Year)) +
  geom_line(aes(y = Ring_Growth_Lat_under_40[, 2], color = colnames(Ring_Growth_Lat_under_40)[2])) +
  geom_line(aes(y = Ring_Growth_Lat_under_40[, 3], color = colnames(Ring_Growth_Lat_under_40)[3])) +
  geom_line(aes(y = Ring_Growth_Lat_under_40[, 4], color = colnames(Ring_Growth_Lat_under_40)[4])) +
  geom_line(aes(y = Ring_Growth_Lat_under_40[, 5], color = colnames(Ring_Growth_Lat_under_40)[5])) +
  geom_line(aes(y = Ring_Growth_Lat_under_40[, 6], color = colnames(Ring_Growth_Lat_under_40)[6])) +
  scale_color_discrete(name = "Species") +
  ggtitle("Ring Growth Rate compared by year \n in the South") +
  xlab("Year") + ylab("Ring Width Increase") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Second plot for fulfilling the second condition (growth rate of trees above the threshold)
p_ring_over_40 <-
  ggplot(data.frame(Ring_Growth_Lat_over_40), aes(x = Year)) +
  geom_line(aes(y = Ring_Growth_Lat_over_40[, 2], color = colnames(Ring_Growth_Lat_over_40)[2])) +
  geom_line(aes(y = Ring_Growth_Lat_over_40[, 3], color = colnames(Ring_Growth_Lat_over_40)[3])) +
  geom_line(aes(y = Ring_Growth_Lat_over_40[, 4], color = colnames(Ring_Growth_Lat_over_40)[4])) +
  geom_line(aes(y = Ring_Growth_Lat_over_40[, 5], color = colnames(Ring_Growth_Lat_over_40)[5])) +
  scale_color_discrete(name = "Species") +
  ggtitle("Ring Growth Rate compared by year \n in the North") +
  xlab("Year") + ylab("Ring Width Increase") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Arrange the two plots in one figure
figure_ring_latitude <- ggarrange(
  p_ring_under_40,
  p_ring_over_40,
  labels = c("A", "B"),
  ncol = 2,
  nrow = 1
)

# Show the figure
#figure_ring_latitude

#################################################################
# Step 4: Analyzing the Ring Growth Rate by Elevation
#################################################################

# Selecting two thresholds to separate the data in three parts according to their elevation 
# I divided the data in three equal parts 
min_treshold_elevation <- 2000
max_treshold_elevation <- 3000

# Condition for separating the data
con <-  Wood_Data_Growth_Rate$Elevation..m. < min_treshold_elevation

# Calculates the average of all individuals per species per year that fulfill the condition (i.e. returns a matrix with rows = number of years and col = number of species
# and the rows contain the average growth rate in that year of individuals of the different species that fulfill the condition (i.e. elevation < 2000))
Ring_Growth_Ele_under_2000 <-
  Calculate_Growth_Ring(Wood_Data_Growth_Rate, con, Species_names)

# Condition for separating the data
con <-
  (
    Wood_Data_Growth_Rate$Elevation..m. > min_treshold_elevation &
      Wood_Data_Growth_Rate$Elevation..m. < max_treshold_elevation
  )

# Calculates the average of all individuals per species per year that fulfill the condition
Ring_Growth_Ele_over_2000 <-
  Calculate_Growth_Ring(Wood_Data_Growth_Rate, con, Species_names)

# Condition for separating the data
con <-  Wood_Data_Growth_Rate$Elevation..m. > max_treshold_elevation

# Calculates the average of all individuals per species per year that fulfill the condition
Ring_Growth_Ele_over_3000 <-
  Calculate_Growth_Ring(Wood_Data_Growth_Rate, con, Species_names)

# First plot for fulfilling the first condition (growth rate of trees below the min threshold)
p_ring_under_2000 <-
  ggplot(data.frame(Ring_Growth_Ele_under_2000), aes(x = Year)) +
  geom_line(aes(y = Ring_Growth_Ele_under_2000[, 2],color = colnames(Ring_Growth_Ele_under_2000)[2])) +
  geom_line(aes(y = Ring_Growth_Ele_under_2000[, 3],color = colnames(Ring_Growth_Ele_under_2000)[3])) +
  geom_line(aes(y = Ring_Growth_Ele_under_2000[, 4],color = colnames(Ring_Growth_Ele_under_2000)[4])) +
  geom_line(aes(y = Ring_Growth_Ele_under_2000[, 5],color = colnames(Ring_Growth_Ele_under_2000)[5])) +
  geom_line(aes(y = Ring_Growth_Ele_under_2000[, 6],color = colnames(Ring_Growth_Ele_under_2000)[6])) +
  scale_color_discrete(name = "Species") +
  ggtitle(sprintf("Ring Growth Rate compared by year \n under %s m",min_treshold_elevation)) +
  xlab("Year") + ylab("Ring Width Increase") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Second plot for fulfilling the second condition (growth rate of trees between the thresholds)
p_ring_over_2000 <-
  ggplot(data.frame(Ring_Growth_Ele_over_2000), aes(x = Year)) +
  geom_line(aes(y = Ring_Growth_Ele_over_2000[, 2], color = colnames(Ring_Growth_Ele_over_2000)[2])) +
  geom_line(aes(y = Ring_Growth_Ele_over_2000[, 3], color = colnames(Ring_Growth_Ele_over_2000)[3])) +
  geom_line(aes(y = Ring_Growth_Ele_over_2000[, 4], color = colnames(Ring_Growth_Ele_over_2000)[4])) +
  geom_line(aes(y = Ring_Growth_Ele_over_2000[, 5], color = colnames(Ring_Growth_Ele_over_2000)[5])) +
  geom_line(aes(y = Ring_Growth_Ele_over_2000[, 6], color = colnames(Ring_Growth_Ele_over_2000)[6])) +
  scale_color_discrete(name = "Species") +
  ggtitle(sprintf("Ring Growth Rate of compared by year \n between %s m and %s m",min_treshold_elevation,max_treshold_elevation)) +
  xlab("Year") + ylab("Ring Width Increase") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Third plot for fulfilling the second condition (growth rate of trees above the max threshold)
p_ring_over_3000 <-
  ggplot(data.frame(Ring_Growth_Ele_over_3000), aes(x = Year)) +
  geom_line(aes(y = Ring_Growth_Ele_over_3000[, 2], color = colnames(Ring_Growth_Ele_over_3000)[2])) +
  geom_line(aes(y = Ring_Growth_Ele_over_3000[, 3], color = colnames(Ring_Growth_Ele_over_3000)[3])) +
  geom_line(aes(y = Ring_Growth_Ele_over_3000[, 4], color = colnames(Ring_Growth_Ele_over_3000)[4])) +
  geom_line(aes(y = Ring_Growth_Ele_over_3000[, 5], color = colnames(Ring_Growth_Ele_over_3000)[5])) +
  geom_line(aes(y = Ring_Growth_Ele_over_3000[, 6], color = colnames(Ring_Growth_Ele_over_3000)[6])) +
  scale_color_discrete(name = "Species") +
  ggtitle(sprintf("Ring Growth Rate compared by year \n over %s m",max_treshold_elevation)) +
  xlab("Year") + ylab("Ring Width Increase") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Arrange the three plots in one figure
figure_ring_elevation <- ggarrange(
  p_ring_under_2000,
  p_ring_over_2000,
  p_ring_over_3000,
  labels = c("A", "B", "C"),
  ncol = 1,
  nrow = 3
)

# Show the figure
# figure_ring_elevation

#################################################################
# Step 5: Analyzing the Stem Growth Rate by Latitude
#################################################################

# Select a threshold for the Latitude (I chose the median) that is used to divide the data in two categroies (one below and one above the threshold)
latitude_treshold <- round(median(Wood_Data_Growth_Rate$Latitude))

# Condition for separating the data
con <-  Wood_Data_Growth_Rate$Latitude >= latitude_treshold

# Calculates the average of all individuals per species per year that fulfill the condition
Stem_Growth_Lat_over_40 <-
  Calculate_Growth_Stem(Wood_Data_Growth_Rate, con, Species_names)

# Condition for separating the data
con <-  Wood_Data_Growth_Rate$Latitude < latitude_treshold

# Calculates the average of all individuals per species per year that fulfill the condition
Stem_Growth_Lat_under_40 <-
  Calculate_Growth_Stem(Wood_Data_Growth_Rate, con, Species_names)

# First plot for fulfilling the first condition (growth rate of trees below the threshold)
p_stem_under_40 <-
  ggplot(data.frame(Stem_Growth_Lat_under_40), aes(x = Year)) +
  geom_line(aes(y = Stem_Growth_Lat_under_40[, 2], color = colnames(Stem_Growth_Lat_under_40)[2])) +
  geom_line(aes(y = Stem_Growth_Lat_under_40[, 3], color = colnames(Stem_Growth_Lat_under_40)[3])) +
  geom_line(aes(y = Stem_Growth_Lat_under_40[, 4], color = colnames(Stem_Growth_Lat_under_40)[4])) +
  geom_line(aes(y = Stem_Growth_Lat_under_40[, 5], color = colnames(Stem_Growth_Lat_under_40)[5])) +
  geom_line(aes(y = Stem_Growth_Lat_under_40[, 6], color = colnames(Stem_Growth_Lat_under_40)[6])) +
  scale_color_discrete(name = "Species") +
  ggtitle("Stem Growth Rate compared by year \n in the South") +
  xlab("Year") + ylab("Stem Diameter Increase") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Second plot for fulfilling the second condition (growth rate of trees above the threshold)
p_stem_over_40 <-
  ggplot(data.frame(Stem_Growth_Lat_over_40), aes(x = Year)) +
  geom_line(aes(y = Stem_Growth_Lat_over_40[, 2], color = colnames(Stem_Growth_Lat_over_40)[2])) +
  geom_line(aes(y = Stem_Growth_Lat_over_40[, 3], color = colnames(Stem_Growth_Lat_over_40)[3])) +
  geom_line(aes(y = Stem_Growth_Lat_over_40[, 4], color = colnames(Stem_Growth_Lat_over_40)[4])) +
  geom_line(aes(y = Stem_Growth_Lat_over_40[, 5], color = colnames(Stem_Growth_Lat_over_40)[5])) +
  scale_color_discrete(name = "Species") +
  ggtitle("Stem Growth Rate compared by year \n in the North") +
  xlab("Year") + ylab("Stem Diameter Increase") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Arrange the two plots in one figure
figure_stem_latitude <- ggarrange(
  p_stem_under_40,
  p_stem_over_40,
  labels = c("A", "B"),
  ncol = 2,
  nrow = 1
)

# Show the figure
#figure_stem_latitude

#################################################################
# Step 6: Analyzing the Stem Growth Rate by Elevation
#################################################################

# Selecting two thresholds to separate the data in three parts according to their elevation 
min_treshold_elevation <- 2000
max_treshold_elevation <- 3000

# Condition for separating the data
con <-  Wood_Data_Growth_Rate$Elevation..m. < min_treshold_elevation

# Calculates the average of all individuals per species per year that fulfill the condition
Stem_Growth_Ele_under_2000 <-
  Calculate_Growth_Stem(Wood_Data_Growth_Rate, con, Species_names)

# Condition for separating the data
con <-
  (
    Wood_Data_Growth_Rate$Elevation..m. > min_treshold_elevation &
      Wood_Data_Growth_Rate$Elevation..m. < max_treshold_elevation
  )

# Calculates the average of all individuals per species per year that fulfill the condition
Stem_Growth_Ele_over_2000 <-
  Calculate_Growth_Stem(Wood_Data_Growth_Rate, con, Species_names)

# Condition for separating the data
con <-  Wood_Data_Growth_Rate$Elevation..m. > max_treshold_elevation

# Calculates the average of all individuals per species per year that fulfill the condition
Stem_Growth_Ele_over_3000 <-
  Calculate_Growth_Stem(Wood_Data_Growth_Rate, con, Species_names)

# First plot for fulfilling the first condition (growth rate of trees below the min threshold)
p_stem_under_2000 <-
  ggplot(data.frame(Stem_Growth_Ele_under_2000), aes(x = Year)) +
  geom_line(aes(y = Stem_Growth_Ele_under_2000[, 2],color = colnames(Stem_Growth_Ele_under_2000)[2])) +
  geom_line(aes(y = Stem_Growth_Ele_under_2000[, 3],color = colnames(Stem_Growth_Ele_under_2000)[3])) +
  geom_line(aes(y = Stem_Growth_Ele_under_2000[, 4],color = colnames(Stem_Growth_Ele_under_2000)[4])) +
  geom_line(aes(y = Stem_Growth_Ele_under_2000[, 5],color = colnames(Stem_Growth_Ele_under_2000)[5])) +
  geom_line(aes(y = Stem_Growth_Ele_under_2000[, 6],color = colnames(Stem_Growth_Ele_under_2000)[6])) +
  scale_color_discrete(name = "Species") +
  ggtitle(sprintf("Stem Growth Rate compared by year \n under %s m ",min_treshold_elevation)) +
  xlab("Year") + ylab("Stem Diameter Increase") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Second plot for fulfilling the second condition (growth rate of trees between the thresholds)
p_stem_over_2000 <-
  ggplot(data.frame(Stem_Growth_Ele_over_2000), aes(x = Year)) +
  geom_line(aes(y = Stem_Growth_Ele_over_2000[, 2], color = colnames(Stem_Growth_Ele_over_2000)[2])) +
  geom_line(aes(y = Stem_Growth_Ele_over_2000[, 3], color = colnames(Stem_Growth_Ele_over_2000)[3])) +
  geom_line(aes(y = Stem_Growth_Ele_over_2000[, 4], color = colnames(Stem_Growth_Ele_over_2000)[4])) +
  geom_line(aes(y = Stem_Growth_Ele_over_2000[, 5], color = colnames(Stem_Growth_Ele_over_2000)[5])) +
  geom_line(aes(y = Stem_Growth_Ele_over_2000[, 6], color = colnames(Stem_Growth_Ele_over_2000)[6])) +
  scale_color_discrete(name = "Species") +
  ggtitle(sprintf("Stem Growth Rate compared by year \n between %s m and %s m",min_treshold_elevation,max_treshold_elevation)) +
  xlab("Year") + ylab("Stem Diameter Increase") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Third plot for fulfilling the second condition (growth rate of trees above the max threshold)
p_stem_over_3000 <-
  ggplot(data.frame(Stem_Growth_Ele_over_3000), aes(x = Year)) +
  geom_line(aes(y = Stem_Growth_Ele_over_3000[, 2], color = colnames(Stem_Growth_Ele_over_3000)[2])) +
  geom_line(aes(y = Stem_Growth_Ele_over_3000[, 3], color = colnames(Stem_Growth_Ele_over_3000)[3])) +
  geom_line(aes(y = Stem_Growth_Ele_over_3000[, 4], color = colnames(Stem_Growth_Ele_over_3000)[4])) +
  geom_line(aes(y = Stem_Growth_Ele_over_3000[, 5], color = colnames(Stem_Growth_Ele_over_3000)[5])) +
  geom_line(aes(y = Stem_Growth_Ele_over_3000[, 6], color = colnames(Stem_Growth_Ele_over_3000)[6])) +
  scale_color_discrete(name = "Species") +
  ggtitle(sprintf("Stem Growth Rate compared by year \n over %s m",max_treshold_elevation)) +
  xlab("Year") + ylab("Stem Diameter Increase") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Arrange the three plots in one figure
figure_stem_elevation <- ggarrange(
  p_stem_under_2000,
  p_stem_over_2000,
  p_stem_over_3000,
  labels = c("A", "B", "C"),
  ncol = 1,
  nrow = 3
)

# Show the figure
#figure_stem_elevation


#################################################################
# Step 7: Showing the figures
#################################################################

# Run commands to show the figures
figure_ring_latitude
figure_ring_elevation

figure_stem_latitude
figure_stem_elevation
