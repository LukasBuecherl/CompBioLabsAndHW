# EBIO 5420: Computational Biology
# Prof: Samuel Flaxman
# Student: Lukas Buecherl
# Final Project
###############################################################################
#
# CODE WRITTEN BY LUKAS BUECHERL FOR THE FINAL PROJECT FOR COURSE EBIO 5420.
# CONTACT: lukas.buecherl@colorado.edu
# GitHub of project: https://github.com/LukasBuecherl/CompBioLabsAndHW/tree/main/Final_Project
# GitHub of assingment: https://github.com/flaxmans/CompBio_on_git/blob/main/Assignments/09_Independent_Project_Step2.md
# 
# This is a library file that contains functions needed for the analysis in 
# the file Buecherl_FinalProject.R
###############################################################################

# Needed Packages
require("tidyverse")
library("ggplot2")
library("dplyr")


Calculate_Growth_Ring <- function(data, con, Species_names) {
  # Function to calculate the average growth rate per year per species
  # Inputs:
  # data: data frame that includes the year, species, GrowthRateRing, and the data used for the condition
  # con: condition by which the data is selected (i.e. above selected threshold of latitude or elevation)
  # Species_names: vector containing the names of the species of trees
  
  # Preallocation
  # Matrix with number rows = years and number cols = number of species plus on column for the year
  Ring_Growth <-
    matrix(nrow = length(unique(data$Year)) ,
           ncol = length(Species_names) + 1)
  
  # Fill the column year with the years
  Ring_Growth[, 1] <- unique(data$Year)
  
  # Iterate over all species
  for (j in 1:length(Species_names)) {
    # Iterate over all years
    for (i in 1:dim(Ring_Growth)[1]) {
      # Year of current iteration
      year <- data$Year[i]
      # Name of species of current iteration
      name <- Species_names[j]
      # Find all rows of the current year, of the current species that fulfill the condition
      index <-
        which(data$Year == year &
                data$Species == name & con)
      
      # Calculate the mean of the ring growth rare and write it into the matrix
      Ring_Growth[i, j + 1] <-
        mean(data$GrowthRateRing[index])
      
    }
  }
  
  # Name the column names of the matrix
  colnames(Ring_Growth) <- c("Year", Species_names)
  
  # Check if there are any columns with NaNs
  if(length(which(is.nan(Ring_Growth))) != 0){
    
    # Find the linear index of the NaN
    index_nan <- which(is.nan(Ring_Growth))
    # Identify the right column by dividing the linear index by the number of rows and rounding up
    col_nan <- ceiling(index_nan[1] / dim(Ring_Growth)[1])
    # Delete that column
    Ring_Growth <- Ring_Growth[, - col_nan]
  }
  
  # Return the matrix
  return(Ring_Growth[2:dim(Ring_Growth)[1],])
}


Calculate_Growth_Stem <- function(data, con, Species_names) {
  # Function to calculate the average growth rate per year per species
  # Inputs:
  # data: data frame that includes the year, species, GrowthRateRing, and the data used for the condition
  # con: condition by which the data is selected (i.e. above selected threshold of latitude or elevation)
  # Species_names: vector containing the names of the species of trees
  
  # Preallocation
  # Matrix with number rows = years and number cols = number of species plus on column for the year
  Ring_Growth <-
    matrix(nrow = length(unique(data$Year)) ,
           ncol = length(Species_names) + 1)
  
  # Fill the column year with the years
  Ring_Growth[, 1] <- unique(data$Year)
  
  # Iterate over all species
  for (j in 1:length(Species_names)) {
    # Iterate over all years
    for (i in 1:dim(Ring_Growth)[1]) {
      # Year of current iteration
      year <- data$Year[i]
      # Name of species of current iteration
      name <- Species_names[j]
      # Find all rows of the current year, of the current species that fulfill the condition
      index <-
        which(data$Year == year &
                data$Species == name & con)
      
      # Calculate the mean of the ring growth rare and write it into the matrix
      Ring_Growth[i, j + 1] <-
        mean(data$GrowthRateStem[index])
      
    }
  }
  
  # Name the column names of the matrix
  colnames(Ring_Growth) <- c("Year", Species_names)
  
  # Check if there are any columns with NaNs
  if(length(which(is.nan(Ring_Growth))) != 0){
    # Find the linear index of the NaN
    index_nan <- which(is.nan(Ring_Growth))
    # Identify the right column by dividing the linear index by the number of rows and rounding up
    col_nan <- ceiling(index_nan[1] / dim(Ring_Growth)[1])
    # Delete that column
    Ring_Growth <- Ring_Growth[, - col_nan]
  }
  
  # Return the matrix
  return(Ring_Growth[2:dim(Ring_Growth)[1],])
}



Delete <- function(data, tresh_ring, tresh_stem) {
  # Function to delete false data
  # Inputs:
  # data: data frame that includes the year, species, Ring width, 
  # tresh_ring: threshold for ring width in mm. Only individuals with a ring width over the threshold are kept
  # tresj_stem: threshold for the stem diameter in cm. Only individuals with stem diameter over the threshold are kept
  
  # Find index of trees with a ring width or stem diameter below the chosen thresholds
  i <-
    which(data$Ring.width..mm. <= tresh_ring |
            data$Stem.diameter..cm. <= tresh_stem)
  
  # Get the IDs of the trees identified 
  ID <- data$Sample.tree.ID[i]
  
  # Delete the data of the identified trees
  for (i in ID) {
    data <- data[!(data$Sample.tree.ID == i), ]
  }
  
  # Return the data
  return(data)
  
}

