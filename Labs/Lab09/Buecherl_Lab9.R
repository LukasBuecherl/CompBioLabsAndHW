# EBIO 5420: Computational Biology 
# Prof: Samuel Flaxman
# Student: Lukas Buecherl
# Lab 9
###############################################################################

# Read in data
camData <- read.csv("/Users/lukas/Library/Mobile Documents/com~apple~CloudDocs/CU Boulder/Spring 2021/Computational Biology/CompBioSandbox/CompBio_on_git/Datasets/Cusack_et_al/Cusack_et_al_random_versus_trail_camera_trap_data_Ruaha_2013_14.csv", stringsAsFactors = F)
str(camData)

# Problem 1
# Using the as.POSIXlt function to convert the DateTime column to time format with specified format
camData$DateTime <- as.POSIXlt(camData$DateTime, format = "%d/%m/%Y %H:%M", tz = "")
str(camData)

# Problem 2 & Problem 3

# Iterating over the whole column and check the internal time difference. Time is stored compared to 
# reference 01/01/1970. So if the returned number is negative, we know that the format is wrong. For 
# example here some are year 13 instead of year 2013

for(i in seq(1:length(camData$DateTime))){
  
  if(camData$DateTime[i] < 0){
    
    # If wrong format convert back to characters
    temp <-strftime(camData$DateTime[i], format = "00%y-%m-%d %H:%M")
    # And reformat back to correct time format
    camData$DateTime[i]  <- strptime(temp, format = "00%y-%m-%d %H:%M", tz = "")
    
  } 
}

# Problem 4

# Define Function:
AverageTime <- function(Season, Station, Species){
  
  # Function calculates the average time between observations
  # Input characters:
  # Season
  # Station
  # Species
  # Output:
  # Average time in hours
  
  # Create sub-dataFrame that only includes the specified observations
  sub <- camData[camData$Season == Season & camData$Station == Station & camData$Species == Species ,  ]
  
  # Pre-allocate
  times <- rep(NA, dim(sub)[1]-1)
  
  # Calculate the time difference between occurring observations
  for(i in seq(2, dim(sub)[1])){
    
    times[i-1] <- sub$DateTime[i] - sub$DateTime[i-1]
    
  }
  
  # Return the average time difference in hours
  return(sprintf("The average time between oberservations of %s during season %s at station %s is %f hours", Species, Season, Station, sum(times) / length(times)))
  
}

AverageTime("D", "47", "Impala")




