# EBIO 5420: Computational Biology
# Prof: Samuel Flaxman
# Student: Lukas Buecherl
# Lab 8
###############################################################################

# Lab step #3: 

# Set working directory 
setwd("/Users/lukas/Library/Mobile Documents/com~apple~CloudDocs/CU Boulder/Spring 2021/Computational Biology/CompBioLabsAndHW/Labs/Lab08")


# Define the funciton:
discreteTimeLogisticGrowthEquation <- function(r, K, generations, initPop){
  
  # Function to calculate the discrete-time logistic growth model 
  # Inputs:
  # r: Intrinsic growth rate of the population
  # K: Environmental carrying capacity for the population
  # generations: Number of generations to be calculated
  # initPop: Initial abundance of the first generation
  # Output:
  # Plot of abundance over time
  
  
  time <- 1:generations # Timeframe
  n <- rep(NA, generations) # Pre-allocate
  n[1] <- initPop # Abundance of the population first generation
  
  for(t in 2:generations){
    n[t] = n[t-1] + ( r * n[t-1] * (K - n[t-1])/K )
  }
  
  plot(time,n, xlab = "Generations", ylab = "Abundance", main = "Abundance Over Time")
  
  result <- cbind(time, n)
  colnames(result) <- c("generations", "abundance")
  write.csv(result,"discreteTimeLogisticGrowth.csv")
}



# Test the function:
K <- 10000 
r <- 0.8
generations <- 20
initPop <- 200


# Save the data
discreteTimeLogisticGrowthEquation(r, K, generations, initPop)







