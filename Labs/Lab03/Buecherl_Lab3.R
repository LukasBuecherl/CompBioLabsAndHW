# EBIO 5420: Computational Biology 
# Prof: Samuel Flaxman
# Student: Lukas Buecherl
# Lab 3
###############################################################################

# Part 1: Basic Operations 
# Lab step #3: Total number of Chips, total number of guests 
num_bags_chips <- 5
num_guest <- 8

# Lab step #5: Average bags of Chips eaten by Guest
exp_aver_chips <- 0.4

# Lab step #7: Expected Amount of leftover chips (host eats 0.4 bag of chips too)
exp_chips_left <- num_bags_chips - (num_guest + 1) * exp_aver_chips



# Part 2: Practice with Objects and Built-in functions
#  Lab step #8: Rankings of the Star Wars Movies in order
self_rating <- c(7, 9, 8, 1, 2, 3, 4, 6, 5)
penny_rating <- c(5, 9, 8, 3, 1, 2, 4, 7, 6)
lenny_rating <- c(6, 5, 4, 9, 8, 7, 3, 2, 1)
stewie_rating <- c(1, 9, 5, 6, 8, 7, 2, 3, 4)

#  Lab step #9: Pennys and Lennys rank of Episode IV
PennyIV <- penny_rating[4]
LennyIV <- lenny_rating[4]

#  Lab step #10: Concatenate all ranking sets
all_rating <- cbind(self_rating, penny_rating, lenny_rating,stewie_rating)

#  Lab step #11: Comparison of PennyIV, penny_rating, and all_rating
str(PennyIV) 
#Output: num 3
str(penny_rating) 
#Output: num [1:9] 5 9 8 3 1 2 4 7 6
str(all_rating) 
#Output: num [1:9, 1:4] 7 9 8 1 2 3 4 6 5 5 ...
#- attr(*, "dimnames")=List of 2
#..$ : NULL
#..$ : chr [1:4] "self_rating" "penny_rating" "lenny_rating" "stewie_rating"

# All the objects a numerical. PennyIV is simply the number 3, penny_rating is 
# a row vector of the size nine, and all_rating is a matrix with nine rows and 
# four columns

#  Lab step #12: Creating a data frame of the rankings
ranking_data_vec <- data.frame(self_rating, penny_rating, lenny_rating, stewie_rating)
ranking_data_mat <- as.data.frame(all_rating)

dim(all_rating)
dim(ranking_data_mat)
# Both objects have the same dimensions 
str(all_rating)
str(ranking_data_mat)
# Both have named columns 
typeof(all_rating)
typeof(ranking_data_mat)
# The object from step 10 has the type double, whereas the object from step 12
# is a list. It also says in the environment, that the object from step 10 is 
# a matrix and the object from step 12 is a data.frame


# Lab step #14: Vector of strings for naming the episodes
epi_nam <- c("I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX")

# Lab step #15: Naming the rows for the objects of step #10 and #12:
row.names(all_rating) <- epi_nam
row.names(ranking_data_mat) <- epi_nam

# Lab step #16: Accessing third row of matrix from step 10
all_rating[3,]

# Lab step #17: Accessing fourth column of data.frame
ranking_data_mat[,4]

# Lab step #18: Accessing own ranking for Episode V
ranking_data_mat[5,1]
all_rating[5,1]

# Lab step #19: Pennys ranking for Episode II
ranking_data_mat[2,2]
all_rating[2,2]

# Lab step #20: All rankings for Episodes IV - VI
ranking_data_mat[4:6,]
all_rating[4:6,]

# Lab step #21: All rankings for Episodes II, V, VII
ranking_data_mat[c(2,5,7),]
all_rating[c(2,5,7),]

# Lab step #22: Penny and Stewies rankings for Episodes IV and VI
ranking_data_mat[c(4,6),c(2,4)]
all_rating[c(4,6),c(2,4)]

# Lab step #23: Switching Lennys ranking for Episode II and V
temp <- ranking_data_mat[2,3]
ranking_data_mat[2,3] <- ranking_data_mat[5,3]
ranking_data_mat[5,3] <- temp

# Lab step #24: Access using row and column names
all_rating["III", "penny_rating"]
ranking_data_mat["III", "penny_rating"]

# Lab step #25: Undo step 23 using row and column names
temp <- ranking_data_mat["II","lenny_rating"]
ranking_data_mat["II","lenny_rating"] <- ranking_data_mat["V","lenny_rating"]
ranking_data_mat["V","lenny_rating"] <- temp

# Lab step #26: Re-Undo step 25 using the $ operator
temp <- ranking_data_mat$lenny_rating[2]
ranking_data_mat$lenny_rating[2] <- ranking_data_mat$lenny_rating[5]
ranking_data_mat$lenny_rating[5] <- temp

