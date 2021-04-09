# EBIO 5420: Computational Biology 
# Prof: Samuel Flaxman
# Student: Lukas Buecherl
# Lab 12
###############################################################################


###############################################################################
# Part 1: (Finish) Getting the data into shape
###############################################################################

# Setting the working directory and importing the data
setwd("/Users/lukas/Library/Mobile Documents/com~apple~CloudDocs/CU Boulder/Spring 2021/Computational Biology/CompBioSandbox/CompBio_on_git/Datasets/COVID-19/CDPHE_Data/CDPHE_Data_Portal/")

stateStatsData <- read.csv("DailyStateStats2/CDPHE_COVID19_Daily_State_Statistics_2_2021-04-02.csv", 
                           stringsAsFactors = F)
require("tidyverse")

# Parsing the data
ColoradoData <- stateStatsData %>%
  filter( Name == "Colorado") %>%
  select(Date, Cases, Deaths) %>%
  mutate( Date = strptime( Date, format = "%m/%d/%Y", tz = "") ) %>%
  arrange( Date ) %>%
  filter( Date < as.POSIXlt("2020-05-15") ) # dt defined above

###############################################################################
# Part 2: Make plots in R using the data from Part 1
###############################################################################

library("ggplot2")

# Plotting Cases/Deaths over time (logarithmic scale)
CasesPlot <- ggplot(ColoradoData, aes(x = as.POSIXct(Date), y = Cases)) + geom_line() + scale_y_log10() + labs(x = "Date") 
DeathsPlot <- ggplot(ColoradoData, aes(x = as.POSIXct(Date), y = Deaths)) + geom_line() + scale_y_log10() + labs(x = "Date")

###############################################################################
# Part 3: Write a function for adding doubling times
###############################################################################

addDoublingTimeRefLines <- function( myPlot, doublingTimeVec, Dates, Data) {
  # Function to plot reference lines 
  # Inputs:
  # Plot
  # vector containing the doubling times
  # vector for x-Axis
  # vector for y-axis
  
  timeZero <- min(Dates)
  nInit <- Data[Dates == timeZero ]
  maxTime <- max(Dates) 
  
  for (i in 1:length(doublingTimeVec)) {
    
    # Defining time vector and doubling numbers 
    TimePoints <- ColoradoData$Date[seq(1, length(ColoradoData$Date), doublingTimeVec[i]),]
    doublingEvents <- 0:(length(TimePoints) - 1)
    DoubleRefNums <- 2^(doublingEvents) * nInit 
    # Defnining reference data frame
    ReferenceData <- data.frame(TimePoints, DoubleRefNums)
    
    # Adding refrence line to plot
    myPlot <- myPlot + geom_line( data = ReferenceData, 
                           mapping = aes(x = as.POSIXct(TimePoints), y = DoubleRefNums), color = "maroon", 
                           linetype = "dashed"  ) 
  }
  
  # Plot the graph
  myPlot
}


# Testing the function
doublingTimeVec <- c(2,3,5,7,10)

addDoublingTimeRefLines(CasesPlot, doublingTimeVec, ColoradoData$Date, ColoradoData$Cases )
addDoublingTimeRefLines(DeathsPlot, doublingTimeVec, ColoradoData$Date, ColoradoData$Deaths )



###############################################################################
# Note: 
# Could not figure out in time on how to label the reference lines nicely and 
# how to add the starting from to the function
###############################################################################






