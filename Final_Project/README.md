# Analysis of the growth rate of five species of tree in the western US

## Introduction

Human influence on the climate system of Earth may result in dangers for various aspects of life on our planet [1]. One way to quantify the effects of climate change on our planet is by looking at the planets forests. More specifically, the growth rate of trees is an indicator to study the effects of the climate on the trees over a longer time period [2]. In this final project, I will analyze the ring width of five common species of trees in the Rocky Mountains in the United States. My driving questions for this project are:
* Comparing the growth rate in relation to the elevation of the individuals among five different tree species
* Comparing the growth rate in relation to the location (_latitude_) of the individuals among five different tree species


<hr>

## Summary of Data to be Analyzed

### Goals of original study that produced the data
The original study published by Arne Buechling et al [2], investigates the leading contributors to the diameter growth of five common tree species in the Rocky Mountains in the western US. The work is based on nonlinear regression models, estimating the effects of precipitation, temperature, and biotic interactions. In their results, the authors claim that the effect of climate change will be complex and specific to the species.  

### Brief description of methodology that produced the data

The data was collected from trees of five different species from five collection sides from the southern beginning of the Rocky Mountains in New Mexico up to the Canadian border in Montana. The following tree species were sampled:

* Abies lasiocarpa
* Picea engelmannii
* Pinus contorta
* Pinus ponderosa
* Pseudotsuga menziesii

at the following sides:

* Lincoln National Forest (_New Mexico_)
* San Isabel National Forest (_Colorado_)
* Roosevelt National Forest (_Colorado_)
* Bighorn National Forest (_Wyoming_)
* Glacier National Park (_Montana_)

For each tree the following data was collected:
* Species
* Year of Growth
* Collection side
* Longitude
* Latitude
* Elevation (_m_)
* Dominant terrain aspect in degrees from north
* Terrain slope (_%_)
* Stem diameter (_cm_)
* Age (_years_)
* Ring width (_mm_)
* Date collected

The data was collected in 2012 and 2013. Damaged trees or saplings were not samlped.  The stem diameter at breast hight (1.3 _m_) and the annual radial increment over the last 20 years was measured. An average of 2.4 cores were collected per tree at a height of 30 _cm_.

### Type of data in this data set:  

#### Format of data  

The data is stored as comma-separated values (_.csv_).

#### Size of data (i.e., megabytes, lines, etc.)

The final sample size ranges between 131 to 179 samples per species. The data is stored in a table with 15440 rows and 14 columns and a file size of 2.2 _megabytes_.


#### Any inconsistencies in the data files?  Anything that looks problematic?  

So far by looking over the data no inconsistencies could be found.

#### What the data represent about the biology?

The number of rings of a tree can be used to determine the age of the tree. However, tree rings do not have to be annual. Besides age, the climate, and vegetation habit also influence tree ring width and formation  [3].


<hr>

## Detailed Description of Analysis to be Done and Challenges Involved

The work revolves around using the _R_ package **tidyverse**, specifically dplyr and tidyr, and the package **ggplot2** to analyze and plot the data. The following steps show the outline of the project:
1. Importing the data and checking for inconsistencies
2. Calculate the average growth rate by taking the mean of ring width increase per year over 20 years using **tidyverse**
3. Find a way to visualize the average growth rate for the five tree species in dependence of elevation and location using **ggplot2**
4. If steps 1-3 are completed early, the authors also provide an additional dataset containing information of the neighboring trees of the individuals in the original dataset within a 15 meter radius. If time allows, this additional dataset can be explored to see how competition influences the growth rate of an individual. In that case, this README file will be updated.

Finally, it will be interesting to compare the outcome to the expected results. I expect the average growth rate to increase in high elevation and former colder climates.


<hr>

## References

1. Lorenzoni, I., Pidgeon, N.F. Public Views on Climate Change: European and USA Perspectives. Climatic Change 77, 73–95 (2006). [https://doi.org/10.1007/s10584-006-9072-z](https://doi.org/10.1007/s10584-006-9072-z)

2. Buechling, A., Martin, P.H. and Canham, C.D., Climate and competition effects on tree growth in Rocky Mountain forests. J Ecol, 105: 1636-1647 (2017). [https://doi.org/10.1111/1365-2745.12782](https://doi.org/10.1111/1365-2745.12782)

3. CHERUBINI, P., GARTNER, B.L., TOGNETTI, R., BRÄKER, O.U., SCHOCH, W. and INNES, J.L., Identification, measurement and interpretation of tree rings in woody species from mediterranean climates. Biological Reviews, 78: 119-148 (2003). [https://doi.org/10.1017/S1464793102006000](https://doi.org/10.1017/S1464793102006000)
