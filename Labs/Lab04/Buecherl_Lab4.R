# EBIO 5420: Computational Biology 
# Prof: Samuel Flaxman
# Student: Lukas Buecherl
# Lab 4
###############################################################################


# Part 1: Practice writing "for loops"

# Lab step #1: for loop that prints hi 10 times
for(index in rep("hi",10)){
  print(index)
}


# Lab step #2: Tim and his piggy bank problem
piggyBank <- 10 # Dollars
allowance <- 5 # Dollars
gumCost <- 2 * 1.34 # Cost of 2 packs of gum per week
weeks <- 8 # Relevant time frame

for(i in 1:weeks){
  piggyBank <- piggyBank + allowance - gumCost
}

print(piggyBank)


# Lab step #3: Help for the conservation biologist
current_population <- 2000 # Number of individuals
shrink_percentage <- 0.05 # Shrinkage of population
years <- 7 # Relevant time frame 

for(current_year in 1:years){
  # Use round since there is no half individual
  current_population <- round(current_population * (1 - shrink_percentage))
  print(current_population)
}


# Lab step #4: The discrete-time logistic growth equation
t_final <- 12 # Relevant time frame
n <- rep(NA, t_final) # Pre-allocate
n[1] <- 2500 # Abundance of the population
K <- 10000 #  Environmental carrying capacity for the population
r <- 0.8 #  Intrinsic growth rate of the population

for(t in 2:t_final){
  n[t] = n[t-1] + ( r * n[t-1] * (K - n[t-1])/K )
}

print(n)


# Part 2: Practice writing “for loops” AND practice storing the data produced 
# by your loops in arrays

# Lab step #5: 
# Part 5a): Create vector of zeros with length 18
three_i <- rep(0,18) # Pre-allocate
print(three_i)

# Part 5b): Vector of multiples of three
for(i in seq(1:length(three_i))){
  three_i[i] <- i * 3
}

print(three_i)

# Part 5c): Create storage for part d)
storage <- rep(0,18) # Pre-allocate
storage[1] <- 1 # Set first value
print(storage)

# Part 5d): Code a sequence of x(t) = 1 + x(t-1) * 2
for(i in 2:length(storeage)){
  storage[i] <- 1 + storage[i-1] * 2
}

print(storage)


# Lab step #6: The Fibonacci sequence
final_step <- 20 # Overall number of calculated elements
fibonacci <- rep(NA, final_step) # Pre-Allocate
fibonacci[1] <- 0 # Define first element
fibonacci[2] <- 1 # Define second element

for(i in 3:final_step){
  fibonacci[i] <- fibonacci[i - 1] + fibonacci[i - 2]
}

print(fibonacci)


# Lab step #7: Plotting the data

t_final <- 12 # Relevant time frame
time <- 1:t_final
n <- rep(NA, t_final) # Pre-allocate
n[1] <- 2500 # Abundance of the population
K <- 10000 #  Environmental carrying capacity for the population
r <- 0.8 #  Intrinsic growth rate of the population

for(t in 2:t_final){
  n[t] = n[t-1] + ( r * n[t-1] * (K - n[t-1])/K )
}

plot(time,n, xlab = "Timepoints", ylab = "Abundance", main = "Abundance Over Time")


# Part 3:  Optional challenge problems (not required for full credit, 
# but encouraged; a few bonus points may be awarded for really nice work)

# Lab step #8: Time for some extra work! 
# Part 8a)
# Set the path
setwd("/Users/lukas/Library/Mobile Documents/com~apple~CloudDocs",
      "/CU Boulder/Spring 2021/Computational Biology/CompBioSandbox",
      "/CompBio_on_git/Labs/Lab04")


# Part 8b) 
# Using the first elegant way
CO2_data <- read.csv("CO2_data_cut_paste.csv", 
                    colClasses=c('integer','numeric','numeric','numeric',
                                 'numeric','numeric','numeric','numeric'))

# Using the second elegant way 
for(column in 2:length(CO2_data)){
  CO2_data[column] <- as.numeric(CO2_data[[column]])
}

str(CO2_data) # Controlling the data type for the columns

# Part 8c)

# Formular to caluclate percentgae incerase:
# Increase = New Number - Original Number
# %_increase = Increase / Original Number × 100

# Using for-loops
data_loop <- CO2_data
for(column in 2:ncol(CO2_data)){
  for(row in 2:nrow(CO2_data)){
    data_loop[row,column] <- (CO2_data[row,column] - CO2_data[row - 1, column]) / CO2_data[row - 1, column] * 100
  }
}

# Deleting the first row since it does not contain percentage information
data_loop <- data_loop[-1,]

# Using matrix operations
data_matrix_oper <- CO2_data[2:nrow(CO2_data),]
data_matrix_oper[,2:ncol(data_matrix_oper)] <- (CO2_data[2:nrow(CO2_data),2:ncol(CO2_data)] - CO2_data[1:nrow(CO2_data) - 1, 2:ncol(CO2_data)]) / CO2_data[1:nrow(CO2_data) - 1, 2:ncol(CO2_data)] * 100

# Replace NAs with zeros
data_loop[is.na(data_loop)]<-0
data_matrix_oper[is.na(data_matrix_oper)]<-0

# Checking for equality
all(data_loop ==data_matrix_oper)


# Part 8d)
# Writing to file
write.csv(data_loop,"YearlyPercentChangesInCO2.csv")


# Part 8e)

# Define data.frame as storage
data_matrix_first_year <- CO2_data[2:nrow(CO2_data),]

# Define a vector that contains the first not NA value for all columns
first_value <- rep(NA, ncol(CO2_data - 1))
for(col in 2:ncol(CO2_data)){
  NonNAindex <- which(!is.na(CO2_data[,col]))
  firstNonNA <- min(NonNAindex)
  first_value[col] <- CO2_data[firstNonNA,col]
}

# Calculate percentage increase compared to first not NA year
for(column in 2:ncol(CO2_data)){
  for(row in 2:nrow(CO2_data)){
    data_matrix_first_year[row,column] <- (CO2_data[row,column] - first_value[column]) / first_value[column] * 100
  }
}

# Write to file
write.csv(data_loop,"YearlyPercentChangesInCO2ComparedFirstYear.csv")



