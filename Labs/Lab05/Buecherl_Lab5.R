# EBIO 5420: Computational Biology 
# Prof: Samuel Flaxman
# Student: Lukas Buecherl
# Lab 5
###############################################################################

# Part 1: Practice some simple conditionals

# Lab step #1: First if-statement !
x <- 42 # Number to check
threshold <- 5 # Chosen threshold 

if(x > threshold){
  sprintf("%s is bigger than %s", x, threshold)
}else{
  sprintf("%s is smaller than or equal %s", x, threshold)
}

# Lab step #2: Working on some data
# Import data set
ExampleData <- read.csv("~/Library/Mobile Documents/com~apple~CloudDocs/CU Boulder/Spring 2021/Computational Biology/CompBioSandbox/CompBio_on_git/Labs/Lab05/ExampleData.csv", sep="")

# Change data set to vector
data <- ExampleData$x

# Part 2a): Getting rid of negativity 
for(i in seq(1:length(data))){
  if(data[i] < 0){
    data[i] <- NA # Replace negative numbers with NA 
  }
}

# Part 2b): Replacing NA with NaN
index <- is.na(data) # Logical indexing
data[index] <- NaN  

# Part 2c): Back to zero
index <- which(is.nan(data)) # Integer indexing
data[index] <- 0

# Part 2d): Number of elements in specified range
lower_tresh <- 50
upper_tresh <- 100
in_range <- which(data > lower_tresh & data < upper_tresh)
len_in_range <- length(in_range)

# Part 2e): Storing the in range values
FiftyToOneHundred <- data[in_range]

# Part 2f): Storing the in range values
# Set path to own Labs and HW directory
setwd("/Users/lukas/Library/Mobile Documents/com~apple~CloudDocs/CU Boulder/Spring 2021/Computational Biology/CompBioLabsAndHW/Labs/Lab05")

# Export data set
write.csv(x = FiftyToOneHundred, file = "FiftyToOneHundred.csv")


# Lab step #3: Going be to climate change !
# Import data set
CO2_data <- read.csv("~/Library/Mobile Documents/com~apple~CloudDocs/CU Boulder/Spring 2021/Computational Biology/CompBioSandbox/CompBio_on_git/Labs/Lab04/CO2_data_cut_paste.csv")

# Part 3a): First year emissions on Gas were non-zero
first_non_zero_gas <- min(which(CO2_data$Gas != 0))

# Part 3b): Years with total emission between 200 and 300 million metric tons
lower_tresh <- 200
upper_tresh <- 300
index <- which(CO2_data$Total > lower_tresh & CO2_data$Total < upper_tresh)
years <- CO2_data$Year[index]


# Part 2:  Loops + conditionals + biology

totalGenerations <- 1000
initPrey <- 100 	# initial prey abundance at time t = 1
initPred <- 10		# initial predator abundance at time t = 1
a <- 0.01 		# attack rate
r <- 0.2 		# growth rate of prey
m <- 0.05 		# mortality rate of predators
k <- 0.1 		# conversion constant of prey into predators

time <- seq(1:totalGenerations)
n <- c(initPrey, rep(NA, length(time) - 1))
p <- c(initPred, rep(NA, length(time) - 1))

for (t in 2:length(time)) {
  
  n[t] <- n[t-1] + (r * n[t-1]) - (a * n[t-1] * p[t-1])
  p[t] <- p[t-1] + (k * a * n[t-1] * p[t-1]) - (m * p[t-1])
  
  # Catch if prey population drops below 0
  if(n[t] < 0){
    n[t] <- 0
  }
  
  # Catch if predators population drops below 0
  if(p[t] < 0){
    p[t] <- 0
  }
  
}

# Create plot of data
plot(time,n, type = "l", col = "red", xlab = "Abundance", ylab = "Time", main = "Abundance of prey and predators over time")
lines(time,p, col = "blue")

legend(700,700, legend=c("Prey", "Predator"),
       col=c("red", "blue"), lty=1)

# Store data in matrix
myResults <- cbind(time, n, p)
colnames(myResults) <- c("TimeStep", "PreyAbundance", "PredatorAbundance")

# Safe data as .csv
write.csv(x = myResults, file = "PredPreyResults.csv")


# Part 3: Bonus problem: a parameter study

# Define function that calculates the LotkaVolterra model
LotkaVolterra <- function(totalGenerations, initPrey, initPred, a, r, m, k){
  
  time <- seq(1:totalGenerations)
  n <- c(initPrey, rep(NA, length(time) - 1))
  p <- c(initPred, rep(NA, length(time) - 1))
  
  for (t in 2:length(time)) {
    
    n[t] <- n[t-1] + (r * n[t-1]) - (a * n[t-1] * p[t-1])
    p[t] <- p[t-1] + (k * a * n[t-1] * p[t-1]) - (m * p[t-1])
    
    # Catch if prey population drops below 0
    if(n[t] < 0){
      n[t] <- 0
    }
    
    # Catch if predators population drops below 0
    if(p[t] < 0){
      p[t] <- 0
    }
    
  }
  
  return(cbind(time, n, p))
  
}

# Set the specific parameters for the LotkaVolterra model
totalGenerations <- 1000
initPred <- 10		# initial predator abundance at time t = 1
a <- 0.01 		# attack rate
r <- 0.2 		# growth rate of prey
m <- 0.05 		# mortality rate of predators
k <- 0.1 
initPreyVec <- seq(from = 10, to = 100, by = 10) # vector of initial prey abundances at time t = 1

# Initialize list to storage the results
list_diff_prey <- vector(mode = "list", length = length(initPreyVec))

# Iterate over the initial prey vector and store the result as data.frame in the list
for (i in 1:length(initPreyVec)) {
  temp <- LotkaVolterra(totalGenerations, initPreyVec[i], initPred, a, r, m, k)
  data_storage <- data.frame("TimeStep" = temp[,1], "PreyAbundance" = temp[,2], "PredatorAbundance" = temp[,3])
  list_diff_prey[[i]] <- data_storage
  
  # Name each list entry according to the inital prey abundance 
  names(list_diff_prey)[i] <- sprintf("Inital Prey: %s", initPreyVec[i])
}



