# EBIO 5420: Computational Biology
# Prof: Samuel Flaxman
# Student: Lukas Buecherl
# Lab 6
###############################################################################

#############################################
# Part 1: Let's get the Area of a triangle
#############################################

# Function definition:
triangleArea <- function(base, height) {
  # Function to calculate the area of a triangle
  # Inputs: length of the base and the height of the triangle
  # Output: are of the triangle
  
  return(0.5 * base * height)
}

# Demonstration of usage:
triangleArea(10, 9)



#############################################
# Part 2: Let's get some absolute values
#############################################

# Function definition:
myAbs <- function(value) {
  
  # Function to calculate the absolute value
  # Input: scalar or vector
  # Output: absolute value of the input
  
  # Get index of all negativ elements
  index <- which(value < 0)
  
  # Multiply negative elements with -1
  value[index] <- value[index] * -1

  # Return the absolute value
  return(value)
  
}

# Demonstration of usage:
myAbs(5)
myAbs(-2.3)
myAbs(c(1.1, 2, 0,-4.3, 9,-12))



#############################################
# Part 3: Back to my favorite sequence
#############################################

# Function definition:
fibonacciSeq <- function(n, start) {
  
  # Function to calculate the fibonacci sequence
  # Inputs:
  # n: number of returned elements of fibonacci sequence 
  # start: defines if sequence starts with 0 or 1
  # Output: Vector of fibonacci sequence
  
  # Check if if length is 1 or 2 and return defined values for these special
  # cases
  if (n == 1) {
    return(start)
  } else if (n == 2) {
    return(start + 1)
  }
  
  # Check if inputs are integers
  if (n != round(n) | start != round(start)) {
    return("Error: Inputs are not integers")
  }
  
  # Check if number of elements to return is larger than 0
  if (n <= 0) {
    return("Error: Length of sequence is less or equal to 0")
  }
  
  # Check if start value is either 0 or 1 as required 
  if (start < 0 | start >= 3) {
    return("Error: start has to be 0 or 1")
  }
  
  # Pre allocate result vector
  fib <- rep(NA, n)
  
  # Set first to elements
  fib[1] <- start
  fib[2] <- 1
  
  # Calculate rest of the sequence
  for (index in 3:n) {
    fib[index] <- fib[index - 2] + fib[index - 1]
  }
  
  # Return the sequence
  return(fib)
  
}

# Demonstration of usage:
fibonacciSeq(5, 0)
fibonacciSeq(5, 1)
fibonacciSeq(20, 1)
fibonacciSeq(2.3, 1)
fibonacciSeq(-4, 1)
fibonacciSeq(5, 4)

#############################################
# Part 4: Writing some math functions
#############################################

####
#4a)
####

# Function definition:
squareDiff <- function(x, y) {
  
  # Function to calculate the squared difference of two values
  return((x - y) ^ 2)
}

# Demonstration of usage:
squareDiff(3, 5)
squareDiff(c(2, 4, 6), 4)

####
#4b)
####

# Function definition:
OwnAver <- function(x) {
  
  # Function to calculate the mean of an input vector
  return(sum(x) / length(x))
}

# Demonstration of usage:
OwnAver(c(5, 15, 10))

ExampleData <-
  read.csv(
    "~/Library/Mobile Documents/com~apple~CloudDocs/CU Boulder/Spring 2021/Computational Biology/CompBioSandbox/CompBio_on_git/Labs/Lab07/DataForLab07.csv",
    sep = ""
  )

OwnAver(ExampleData[[1]])

####
#4c)
####

# Function definition:
SumSquares <- function(x) {
  
  # Function to calculate the sum of squares of an input vector
  
  mean <- OwnAver(x) # Calculate the mean
  return(sum(squareDiff(x, mean)))
}


# Demonstration of usage:

SumSquares(ExampleData[[1]])
