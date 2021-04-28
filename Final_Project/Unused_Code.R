#####################################################################################################################################
# OLD Functions
#####################################################################################################################################



Func_Average_Growth<- function(data, Species){
  # Function to calcualte the average growth
  # Inputs:
  # Data with Ring Gowth, Speceis ID, Year, Stem Grwoth
  # Species containing IDs
  # Output Average Growth of individual over 20 years
  
  # Get all IDs
  Individual <-
    unique(Species$Sample.tree.ID)
  
  # Preallocate with number of rows = number of all individuals and two columns (one for ID one for average growth of that tree)
  Average_Growth <-
    matrix(nrow = length(Individual), ncol = 2)
  
  #Iterate over all individuals
  for (i in seq(1:length(Individual))) {
    # Get ID
    ID <- Individual[i]
    # Get all rows with that ID
    index <- which(Species$Sample.tree.ID == ID)
    
    # Calculate the Average Growth over all years
    Average <-
      sum(Species$Ring.width..mm.[index[1]:index[length(index)]]) / length(index)
    # Store ID in matrix
    Average_Growth[i, 1] <- ID
    # Store average growth in matrix
    Average_Growth[i, 2] <- Average
  }
  
  # Return data
  return(Average_Growth)
}



Func_Calculate_Growth_Rates <- function(Secies_data, Average_Growth){
  # Function to compare the growth of a year to the average growth of that tree over 20 years
  # Inputs: 
  # Data with, ID, growth of ring, year, latitude, elevation
  # Average growth of all individual trees (ID, Average Growth)
  
  # Preallocate: Matrix with size of original data and six columns for ID, Year, 
  # GrowthComparedAverage, GrowthComparedYear, Elevation, and Latitude
  Growth_by_Year <-
    matrix(nrow = dim(Secies_data)[1],
           ncol = 6)
  
  # Iterate over all rows (all years of all individuals)
  for (i in seq(1:dim(Growth_by_Year)[1])) {
    # Add current ID in first column
    Growth_by_Year[i, 1] <-
      Secies_data$Sample.tree.ID[i]
    # Add current year in second column
    Growth_by_Year[i, 2] <- Secies_data$Year[i]
    # Find index of the Average Growth in the Average Growth matrix
    k <-
      which(Average_Growth == Secies_data$Sample.tree.ID[i])
    
    # Calculate increase/decrease compared to average growth 
    Growth_by_Year[i, 3] <-
      (Secies_data$Ring.width..mm.[i] - as.numeric(Average_Growth[k, 2])) / abs(as.numeric(Average_Growth[k, 2]))
    
    # Protection of index error
    if (i + 1 < dim(Growth_by_Year)[1]) {
      # First year does not have reference year so calculate only for years unequal to first year
      if (Secies_data$Year[i + 1] != min(Secies_data$Year)) {
        # Calculate the increase compared to the previous year
        Growth_by_Year[i + 1, 4] <-
          (
            Secies_data$Ring.width..mm.[i + 1] - Secies_data$Ring.width..mm.[i]
          ) / Secies_data$Ring.width..mm.[i]
      }
    }
    # Add elevation to matrix
    Growth_by_Year[i, 5] <-Secies_data$Elevation..m.[i]
    # Add latitude to matrix
    Growth_by_Year[i, 6] <-Secies_data$Latitude[i]
  }
  
  # Rename columns of final matrix
  colnames(Growth_by_Year) <- c("ID","Year", "GrowthComparedAverage", "GrowthComparedYear", "Elevation", "Latitude")
  
  # Delete rows containint nas
  Growth_by_Year[is.na(Growth_by_Year)] <- 0
  
  # Format matrix to data.frame
  Growth_by_Year <- data.frame(Growth_by_Year)
  
  
}

Func_Seperate_by_Elevation <- function(Species_Growth_Rates, min, max){
  # Function to separate the data into three parts according to given 
  # min and max threshold 
  # Inputs:
  # Data of one species with year, growth rates, latitude and elevation
  # min elevation threshold
  # max elevation threshold
  
  # Preallocate: Matrix with nrow = number of years
  Rate_Elevation <- matrix(nrow = length(unique(Species_Growth_Rates$Year)), ncol = 4)
  Rate_Elevation[, 1] <- unique(Species_Growth_Rates$Year)
  
  # Calculate the average of all individuals with elevation below min threshold
  for (i in seq(1, length(unique(Species_Growth_Rates$Year)))) {
    Rate_Elevation[i,2] <- sum(as.numeric(Species_Growth_Rates$GrowthComparedAverage[which(Species_Growth_Rates$Elevation < min & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i])])) / length(which(Species_Growth_Rates$Elevation < min & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i]))
  }
  
  # Calculate the average of all individuals with elevation above min threshold and below max threshold
  for (i in seq(1, length(unique(Species_Growth_Rates$Year)))) {
    Rate_Elevation[i,3] <- sum(as.numeric(Species_Growth_Rates$GrowthComparedAverage[which(Species_Growth_Rates$Elevation > max & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i])])) / length(which(Species_Growth_Rates$Elevation > max & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i]))
  }
  
  # Calculate the average of all individuals with elevation above max threshold
  for (i in seq(1, length(unique(Species_Growth_Rates$Year)))) {
    Rate_Elevation[i,4] <- sum(as.numeric(Species_Growth_Rates$GrowthComparedAverage[which(Species_Growth_Rates$Elevation < max & Species_Growth_Rates$Elevation > min &Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i])])) / length(which(Species_Growth_Rates$Elevation > max & Species_Growth_Rates$Elevation > min & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i]))
  }
  
  # Reformat data and return data frame
  Rate_Elevation <- data.frame(Rate_Elevation)
  Rate_Elevation[,1] <- as.numeric(Rate_Elevation[,1])
  Rate_Elevation[,2] <- as.numeric(Rate_Elevation[,2])
  Rate_Elevation[,3] <- as.numeric(Rate_Elevation[,3])
  Rate_Elevation[,4] <- as.numeric(Rate_Elevation[,4])
  
  return(Rate_Elevation)
  
}



Func_Seperate_by_Latitude <- function(Species_Growth_Rates, median){
  # Function to separate the data into two parts according to given 
  # threshold 
  # Inputs:
  # Data of one species with year, growth rates, latitude and elevation
  # median: treshold of dividing data in two parts (using median to get roughly to even groups)
  
  # Preallocate: Matrix with nrow = number of years
  Rate_Latitude <- matrix(nrow = length(unique(Species_Growth_Rates$Year)), ncol = 3)
  # Add yeats
  Rate_Latitude[, 1] <- unique(Species_Growth_Rates$Year)
  
  # Calculate the average of all individuals with latitude below threshold
  for (i in seq(1, length(unique(Species_Growth_Rates$Year)))) {
    Rate_Latitude[i,2] <- sum(as.numeric(Species_Growth_Rates$GrowthComparedAverage[which(Species_Growth_Rates$Latitude < median & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i])])) / length(which(Species_Growth_Rates$Latitude < median & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i]))
  }
  
  # Calculate the average of all individuals with latitude above threshold
  for (i in seq(1, length(unique(Species_Growth_Rates$Year)))) {
    Rate_Latitude[i,3] <- sum(as.numeric(Species_Growth_Rates$GrowthComparedAverage[which(Species_Growth_Rates$Latitude > median & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i])])) / length(which(Species_Growth_Rates$Latitude < median & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i]))
  }
  
  # Reformat data and return data frame
  Rate_Latitude <- data.frame(Rate_Latitude)
  Rate_Latitude[,1] <- as.numeric(Rate_Latitude[,1])
  Rate_Latitude[,2] <- as.numeric(Rate_Latitude[,2])
  Rate_Latitude[,3] <- as.numeric(Rate_Latitude[,3])
  
  return(Rate_Latitude)
  
  
}





#####################################################################################################################################
# OLD CODE
#####################################################################################################################################



# Create empty list
Species_data_list <- list()

# Iterate over all species
for (i in Species_names) {
  
  # Divide the data into a data set containing only the current species
  Species_Specific <- Wood_Data_Im %>%
    filter(Species == i) %>%
    arrange(Sample.tree.ID)
  
  # Calculate the average growth for all individuals of that species
  Average_Growth_Individuals <- Func_Average_Growth(Wood_Data_Im, Species_Specific)
  
  # Calculate the growth rates compare to average and compared year by year for the species
  Species_Growth_Rates <- Func_Calculate_Growth_Rates(Species_Specific, Average_Growth_Individuals)
  
  # Reformat
  Species_Growth_Rates[,2] <- as.numeric(Species_Growth_Rates[,2])
  Species_Growth_Rates[,4] <- as.numeric(Species_Growth_Rates[,4])
  
  # Add one entry to the list labeld with the species name containing all the calculated data
  # results in a list with five elements, one for each species
  Species_data_list[[i]] <- Species_Growth_Rates
  
}

##################################
# Step 3: Separating by Elevation
##################################

# Create a vector starting at the min year counting up to the max year
Years <-
  seq(min(Species_data_list[[1]]$Year), max(Species_data_list[[1]]$Year))

# Preallocate: matrix with nrows = number of years and ncol = 6, one for year and five for the different speceis
Elevation <- matrix(nrow = length(Years), ncol = 6)
# Rename the columns
colnames(Elevation) <- c("Year", Species_names)
# Add the years to the first column
Elevation[, 1] <- Years

# Iterate over the list to get for each species the information
for (j in 1:length(Species_data_list)) {
  data <- Species_data_list[[j]]
  
  # Iterate over all years
  for (i in 1:length(Years)) {
    # Get current year
    Year <- Years[i]
    # Calculate the mean for the current year that fulfills the condition of having an elevation between 2000 and 3000
    Elevation[i, j + 1] <-
      mean(data$GrowthComparedYear[which(data$Year == Year &
                                           data$Elevation > 2000 & data$Elevation < 3000)])
  }
  
}

# Reformat the data
Elevation[, ] <- as.numeric(Elevation[, ])

# Plot the results
ggplot(data.frame(Elevation), aes(x = Year)) + 
  geom_line(aes(y = Elevation[, 2], color = colnames(Elevation)[2])) + 
  geom_line(aes(y = Elevation[, 3], color = colnames(Elevation)[3])) + 
  geom_line(aes(y = Elevation[, 4], color = colnames(Elevation)[4])) + 
  geom_line(aes(y = Elevation[, 5], color = colnames(Elevation)[5])) + 
  geom_line(aes(y = Elevation[, 6], color = colnames(Elevation)[6])) + 
  scale_color_discrete(name = "Species") + 
  ggtitle("Growth Rate compared by year \n under 2000m Elevation") +
  xlab("Year") + ylab("Growth Rate") + 
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5))


##################################
# Step 3: Separating by Elevation
##################################

# Separate the data by elevation
Growth_Rate_by_Elevation <- Seperate_by_Elevation(Species_Growth_Rates, 2000, 3000)

# Plot the results
ggplot(Growth_Rate_by_Elevation, aes(x = X1))  + geom_line(aes(y = X2, color = "darkred")) + geom_line(aes(y = X3, color = "steelblue")) + geom_line(aes(y = X4, color = "green")) +  scale_color_discrete(name = "Elevation in m", labels = c("< 2000", "> 3000", "2000 - 3000")) + ggtitle("Growth Rate by Elevation") +
  xlab("Year") + ylab("Growth Rate in %") 


##################################
# Step 4: Separating by Latitude
##################################

# Seperate the data by latitude
Growth_Rate_by_Latitude <- Seperate_by_Latitude(Species_Growth_Rates, 40)

# Plot the results
ggplot(Growth_Rate_by_Latitude, aes(x = X1))  + geom_line(aes(y = X2, color = "darkred")) + geom_line(aes(y = X3, color = "steelblue")) +  scale_color_discrete(name = "Lattitude", labels = c("< 40", "> 40")) + ggtitle("Growth Rate by Latitude") +
  xlab("Year") + ylab("Growth Rate in %") 




####################
# Code to experiment with the data to find problems or weird results

# Select data only from one species
temp <- Wood_Data_Growth_Rate[which(Wood_Data_Growth_Rate$Species == Species_names[4]),]
# Select only data from the years 2002 and 2003
temp <- temp[which(temp$Year == 2002 | temp$Year == 2003), ]

# Calculate the difference in ring width in 2002 and 2003 for all individuals and sum it up 
t <- 0
for (i in 2:dim(temp)[1]) {
  diff <- temp$Ring.width..mm.[i] - temp$Ring.width..mm.[i - 1] 
  t <- t + diff
}

# Preallocate
l <- matrix(nrow =dim(temp)[1],1)

# Calculate the increase
for(i in seq(2,dim(temp)[1],2)){
  l[i,1] <- (temp$Ring.width..mm.[i] -  temp$Ring.width..mm.[i - 1]) / abs(temp$Ring.width..mm.[i - 1])
}




