#####################################################################################################################################
# OLD Functions
#####################################################################################################################################

Func_Average_Growth<- function(data, Species){
  
  Individual <-
    unique(Species$Sample.tree.ID)
  
  
  Average_Growth <-
    matrix(nrow = length(Individual), ncol = 2)
  
  for (i in seq(1:length(Individual))) {
    ID <- Individual[i]
    index <- which(Species$Sample.tree.ID == ID)
    Average <-
      sum(Species$Ring.width..mm.[index[1]:index[length(index)]]) / length(index)
    Average_Growth[i, 1] <- ID
    Average_Growth[i, 2] <- Average
  }
  
  return(Average_Growth)
}


Func_Calculate_Growth_Rates <- function(Secies_data, Average_Growth){
  
  Growth_by_Year <-
    matrix(nrow = dim(Secies_data)[1],
           ncol = 6)
  
  for (i in seq(1:dim(Growth_by_Year)[1])) {
    Growth_by_Year[i, 1] <-
      Secies_data$Sample.tree.ID[i]
    Growth_by_Year[i, 2] <- Secies_data$Year[i]
    k <-
      which(Average_Growth == Secies_data$Sample.tree.ID[i])
    Growth_by_Year[i, 3] <-
      (Secies_data$Ring.width..mm.[i] - as.numeric(Average_Growth[k, 2])) / abs(as.numeric(Average_Growth[k, 2]))
    
    if (i + 1 < dim(Growth_by_Year)[1]) {
      if (Secies_data$Year[i + 1] != min(Secies_data$Year)) {
        Growth_by_Year[i + 1, 4] <-
          (
            Secies_data$Ring.width..mm.[i + 1] - Secies_data$Ring.width..mm.[i]
          ) / Secies_data$Ring.width..mm.[i]
      }
    }
    
    Growth_by_Year[i, 5] <-Secies_data$Elevation..m.[i]
    Growth_by_Year[i, 6] <-Secies_data$Latitude[i]
  }
  
  colnames(Growth_by_Year) <- c("ID","Year", "GrowthComparedAverage", "GrowthComparedYear", "Elevation", "Latitude")
  
  Growth_by_Year[is.na(Growth_by_Year)] <- 0
  
  Growth_by_Year <- data.frame(Growth_by_Year)
  
  
}

Func_Seperate_by_Elevation <- function(Species_Growth_Rates, min, max){
  
  
  Rate_Elevation <- matrix(nrow = length(unique(Species_Growth_Rates$Year)), ncol = 4)
  Rate_Elevation[, 1] <- unique(Species_Growth_Rates$Year)
  
  for (i in seq(1, length(unique(Species_Growth_Rates$Year)))) {
    Rate_Elevation[i,2] <- sum(as.numeric(Species_Growth_Rates$GrowthComparedAverage[which(Species_Growth_Rates$Elevation < min & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i])])) / length(which(Species_Growth_Rates$Elevation < min & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i]))
  }
  
  for (i in seq(1, length(unique(Species_Growth_Rates$Year)))) {
    Rate_Elevation[i,3] <- sum(as.numeric(Species_Growth_Rates$GrowthComparedAverage[which(Species_Growth_Rates$Elevation > max & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i])])) / length(which(Species_Growth_Rates$Elevation > max & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i]))
  }
  
  for (i in seq(1, length(unique(Species_Growth_Rates$Year)))) {
    Rate_Elevation[i,4] <- sum(as.numeric(Species_Growth_Rates$GrowthComparedAverage[which(Species_Growth_Rates$Elevation < max & Species_Growth_Rates$Elevation > min &Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i])])) / length(which(Species_Growth_Rates$Elevation > max & Species_Growth_Rates$Elevation > min & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i]))
  }
  
  
  Rate_Elevation <- data.frame(Rate_Elevation)
  Rate_Elevation[,1] <- as.numeric(Rate_Elevation[,1])
  Rate_Elevation[,2] <- as.numeric(Rate_Elevation[,2])
  Rate_Elevation[,3] <- as.numeric(Rate_Elevation[,3])
  Rate_Elevation[,4] <- as.numeric(Rate_Elevation[,4])
  
  return(Rate_Elevation)
  
}



Func_Seperate_by_Latitude <- function(Species_Growth_Rates, median){
  
  Rate_Latitude <- matrix(nrow = length(unique(Species_Growth_Rates$Year)), ncol = 3)
  Rate_Latitude[, 1] <- unique(Species_Growth_Rates$Year)
  
  for (i in seq(1, length(unique(Species_Growth_Rates$Year)))) {
    Rate_Latitude[i,2] <- sum(as.numeric(Species_Growth_Rates$GrowthComparedAverage[which(Species_Growth_Rates$Latitude < median & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i])])) / length(which(Species_Growth_Rates$Latitude < median & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i]))
  }
  
  for (i in seq(1, length(unique(Species_Growth_Rates$Year)))) {
    Rate_Latitude[i,3] <- sum(as.numeric(Species_Growth_Rates$GrowthComparedAverage[which(Species_Growth_Rates$Latitude > median & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i])])) / length(which(Species_Growth_Rates$Latitude < median & Species_Growth_Rates$Year == unique(Species_Growth_Rates$Year)[i]))
  }
  
  
  Rate_Latitude <- data.frame(Rate_Latitude)
  Rate_Latitude[,1] <- as.numeric(Rate_Latitude[,1])
  Rate_Latitude[,2] <- as.numeric(Rate_Latitude[,2])
  Rate_Latitude[,3] <- as.numeric(Rate_Latitude[,3])
  
  return(Rate_Latitude)
  
  
}





#####################################################################################################################################
# OLD CODE
#####################################################################################################################################




Species_data_list <- list()

for (i in Species_names) {
  
  Species_Specific <- Wood_Data_Im %>%
    filter(Species == i) %>%
    arrange(Sample.tree.ID)
  
  
  Average_Growth_Individuals <- Func_Average_Growth(Wood_Data_Im, Species_Specific)
  
  Species_Growth_Rates <- Func_Calculate_Growth_Rates(Species_Specific, Average_Growth_Individuals)
  
  Species_Growth_Rates[,2] <- as.numeric(Species_Growth_Rates[,2])
  Species_Growth_Rates[,4] <- as.numeric(Species_Growth_Rates[,4])
  
  Species_data_list[[i]] <- Species_Growth_Rates
  
}

##################################
# Step 3: Separating by Elevation
##################################


Years <-
  seq(min(Species_data_list[[1]]$Year), max(Species_data_list[[1]]$Year))

Elevation <- matrix(nrow = length(Years), ncol = 6)
colnames(Elevation) <- c("Year", Species_names)
Elevation[, 1] <- Years


for (j in 1:length(Species_data_list)) {
  data <- Species_data_list[[j]]
  
  for (i in 1:length(Years)) {
    Year <- Years[i]
    Elevation[i, j + 1] <-
      mean(data$GrowthComparedYear[which(data$Year == Year &
                                           data$Elevation > 2000 & data$Elevation < 3000)])
  }
  
}

Elevation[, ] <- as.numeric(Elevation[, ])

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


Growth_Rate_by_Elevation <- Seperate_by_Elevation(Species_Growth_Rates, 2000, 3000)


ggplot(Growth_Rate_by_Elevation, aes(x = X1))  + geom_line(aes(y = X2, color = "darkred")) + geom_line(aes(y = X3, color = "steelblue")) + geom_line(aes(y = X4, color = "green")) +  scale_color_discrete(name = "Elevation in m", labels = c("< 2000", "> 3000", "2000 - 3000")) + ggtitle("Growth Rate by Elevation") +
  xlab("Year") + ylab("Growth Rate in %") 


##################################
# Step 4: Separating by Latitude
##################################

Growth_Rate_by_Latitude <- Seperate_by_Latitude(Species_Growth_Rates, 40)

ggplot(Growth_Rate_by_Latitude, aes(x = X1))  + geom_line(aes(y = X2, color = "darkred")) + geom_line(aes(y = X3, color = "steelblue")) +  scale_color_discrete(name = "Lattitude", labels = c("< 40", "> 40")) + ggtitle("Growth Rate by Latitude") +
  xlab("Year") + ylab("Growth Rate in %") 




####################
temp <- Wood_Data_Growth_Rate[which(Wood_Data_Growth_Rate$Species == Species_names[4]),]
temp <- temp[which(temp$Year == 2002 | temp$Year == 2003), ]

t <- 0
for (i in 2:dim(temp)[1]) {
  diff <- temp$Ring.width..mm.[i] - temp$Ring.width..mm.[i - 1] 
  t <- t + diff
}


l <- matrix(nrow =dim(temp)[1],1)

for(i in seq(2,dim(temp)[1],2)){
  l[i,1] <- (temp$Ring.width..mm.[i] -  temp$Ring.width..mm.[i - 1]) / abs(temp$Ring.width..mm.[i - 1])
}

t/(dim(temp)[1] / 2)



