# Analysis of the growth rate of five species of tree in the western US

### Biological question
Trees grow in layers, increasing their stem diameter every year. This process results in the formation of rings that marks one year of growth. Therefore, the number of rings of a tree can be used to determine its age. Importantly, besides age, the ring growth is influenced by other factors like the climate and vegetation habit [1]. This leads to the central research question of this project: _How has the average annual growth rate of both ring width and stem diameter of the trees changed in the years between 1992 and 2011?_ In this project, the ring width and stem diameter growth of five common species of trees in the Rocky Mountains in the United States is analyzed.

### Context (introduction)
Human influence on the climate system of Earth may result in dangers for various aspects of life on our planet [2]. The explained annual tree growth is therefore an interesting way to quantify the effects of climate change on our planet. In dendrochronology, the ring width of a tree for past years can be determined without having to cut the tree down. The measurement of the ring width of the past years can be seen as documentation of the tree's environment during that year. A larger ring width corresponds to a more favorable environment in that year resulting in more tree growth compared to a year with a smaller ring width. Therefore, the growth rate of trees can be one indicator for studying the effects of climate on the trees over a longer time [3]. My driving questions are:
* How did the growth rate (both ring width and stem diameter) change in relation to the elevation of the individuals among five different tree species between 1992 and 2011?
* How did the growth rate (both ring width and stem diameter) change in relation to the location (_latitude_) of the individuals among five different tree species between 1992 and 2011?   


### Methods
##### The source of the original data:

The data was originally published by Arne Buechling et al [3]. It was collected from trees of five different species from five collection sides from the southern beginning of the Rocky Mountains in New Mexico up to the Canadian border in Montana. The following tree species were sampled:

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

The data was collected in 2012 and 2013. Damaged trees or saplings were not sampled.  The stem diameter at breast height (1.3 _m_) and the annual radial increment over the last 20 years were measured. An average of 2.4 cores was collected per tree at a height of 30 _cm_. The original data is stored as comma-separated values (_.csv_). The final sample size ranges between 131 to 179 samples per species and the data is stored in a table with 15440 rows and 14 columns and a file size of 2.2 _megabytes_. Each individual tree has its own identification number, measurements for the ring width, stem diameter, as well as the information listed above stored in the corresponding columns in 20 rows starting with the year 1992 ranging to the year 2011. Working with the data resulted in encountering a few challenges. At first, the data seemed very cleaned and complete. However, after working on the data it was found that the original data included duplicated rows, missing rows, and typos.


##### Work on the data by the original authors:
The original study published by Arne Buechling et al [3], investigates the leading contributors to the diameter growth of five common tree species in the Rocky Mountains in the western US. The work is based on nonlinear regression models, estimating the effects of precipitation, temperature, and biotic interactions. In their results, the authors claim that the effect of climate change will be complex and specific to the species.  

##### Work on the data in this project:
To answer my central research question stated in the introduction, I followed a three-step approach. My first step was importing, sorting, and cleaning the data. The data was sorted by tree ID and year. Following, the data were checked for missing values (_NAs_), for duplicated rows, and missing years with no measurements. If any of these were found, the corresponding data for the individual tree was deleted to assure a uniform dataset. The data also includes false measurements (i.e. ring widths of less than _0.0006 mm_). The user can specify a minimum ring width (_mm_) and the minimum stem diameter (_cm_) that the individual trees are required to have. In my work, I settled for a minimum ring width of _0.05 mm_ and a stem diameter larger than _0 cm_.

Secondly, for each individual tree, the growth increase was calculated by dividing the difference of the ring width of one year and its previous year by the ring width of the previous year. Simultaneously, the growth increase of the stem diameter for every individual and every year was calculated and stored in a matrix. In the next step, to determine the influence of location, I divided the data into two groups, one with a latitude below _45°_ and one with a latitude above _45°_. For each group, I calculated the average of the growth increase for both ring width and diameter separately for every year and species. The resulting two matrices have each 20 rows, one for each year from 1992 to 2011, and 6 columns. The first column stores the year and the remaining five, labeled with the species name, store the average growth in that year for that species either below or above the chosen threshold. The method was repeated to populate three matrices with the average growth increase of ring width and stem diameter for each species and year below _2000 m_, between _2000 m_ and _3000m_, and above _3000 m_ elevation.

The third and last step of the project was the visualization of the results using the R package ggplot2 [4]. Other packages that were used in this project are tidyverse's dplyr [5] and ggpubr [6]. All work was done using the R programming language (_Version 4.0.2_) and RStudio (_Version 1.4.1103_).

Contrary to my work, the authors of the original study [3] used the data they collected to construct and fit independent regression models for each species estimating the effects of precipitation, temperature, and biotic interactions on the response variable ring growth. In their results, the authors claim that the effect of climate change will be complex and specific to the species.  

### Results and conclusions

The results for the ring growth increase show a high growth for the years 2003, 2005, and 2007.

![Figure1](https://github.com/LukasBuecherl/CompBioLabsAndHW/blob/30c947e1eddfe4051b0786a9070debb77ae5b12b/Final_Project/Results/RingEle.png?raw=true "Figure 1")

 Figure 1 shows the growth increase of the ring width for the five different species compared by elevation. It is interesting to note, that the species _Pinus ponderosa_ and _Pseudotsuga menziesii_ have a strong growth in the mentioned years, compared to the other species. The growth increase also decreases with a higher elevation. When compared by the location, the years 2003 and 2007 again were very successful for tree growth in the South. However in the North (above _45°_) ring growth increase was fluctuating by year as seen in Figure 2.

 ![Figure2](https://github.com/LukasBuecherl/CompBioLabsAndHW/blob/30c947e1eddfe4051b0786a9070debb77ae5b12b/Final_Project/Results/RingLat.png?raw=true "Figure 2")

 Contrary to the ring width, the increase of stem diameter growth decreased since 1992, especially below _3000m_. In addition, as seen in Figure 3, the stem diameter increase of _Pinus ponderosa_ above _3000m_ is more fluctuating compared to the increase of the other species.

 ![Figure3](https://github.com/LukasBuecherl/CompBioLabsAndHW/blob/30c947e1eddfe4051b0786a9070debb77ae5b12b/Final_Project/Results/StemEle.png?raw=true "Figure 3")

 When looking at the stem growth increase according to location, both Nord and South show a decreasing behavior as seen in Figure 4.

 ![Figure4](https://github.com/LukasBuecherl/CompBioLabsAndHW/blob/30c947e1eddfe4051b0786a9070debb77ae5b12b/Final_Project/Results/StemLat.png?raw=true "Figure 4")

Overall, concluding the project, it is very interesting to see that the ring width increase shows peaks for certain years, whereas the stem diameter increase seems to decrease over time. Future work should be done to connect the years of high ring width increase to the average temperature of that year and investigate the decrease in stem diameter increase.

### References

1. Cherubini, P., Gartner, B.L., Tognetti, R., Braeker, O.U., Schoch, W. and Innes, J.L., Identification, measurement and interpretation of tree rings in woody species from mediterranean climates. Biological Reviews, 78: 119-148 (2003). [https://doi.org/10.1017/S1464793102006000](https://doi.org/10.1017/S1464793102006000)

2. Lorenzoni, I., Pidgeon, N.F. Public Views on Climate Change: European and USA Perspectives. Climatic Change 77, 73–95 (2006). [https://doi.org/10.1007/s10584-006-9072-z](https://doi.org/10.1007/s10584-006-9072-z)

3. Buechling, A., Martin, P.H. and Canham, C.D., Climate and competition effects on tree growth in Rocky Mountain forests. J Ecol, 105: 1636-1647 (2017). [https://doi.org/10.1111/1365-2745.12782](https://doi.org/10.1111/1365-2745.12782)

4. Wickham H. An introduction to ggplot: An implementation of the grammar of graphics in R. Statistics. 2006 Feb 27.[http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.469.6875&rep=rep1&type=pdf](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.469.6875&rep=rep1&type=pdf)

5. Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G, Hayes A, Henry L, Hester J, Kuhn M. Welcome to the Tidyverse. Journal of Open Source Software. 2019 Nov 21;4(43):1686. [https://joss.theoj.org/papers/10.21105/joss.01686](https://joss.theoj.org/papers/10.21105/joss.01686)

6. Kassambara A, Kassambara MA. Package ‘ggpubr’.  [https://mran.microsoft.com/snapshot/2017-04-22/web/packages/ggpubr/ggpubr.pdf](https://mran.microsoft.com/snapshot/2017-04-22/web/packages/ggpubr/ggpubr.pdf)
