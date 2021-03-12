# Discrete-Time Logistic Growth Model

This directory includes code to calculate the discrete-time logistic growth model written in R. The model calculates the abundance of a population over a specified number of generations. The script was coded as part of the course **EBIO 5420 -Computational Biology** at the University of Colorado Boulder. The source file for the lab can be found [here](https://github.com/LukasBuecherl/CompBio_on_git/blob/main/Labs/Lab08/Lab08_documentation_and_metadata.md).

#### Inputs
* _r_ : Intrinsic growth rate of the population
* _K_ :  Environmental carrying capacity for the population
* _Generations_ : Number of generations to be calculated
* _InitPop_ : Initial abundance of the first generation

#### Output

The model plots the calculated abundance over the specified number of generations and saves the results as a comma-separated values file (_.csv_). An example plot can be seen here:

![ExamplePlot](https://user-images.githubusercontent.com/60665186/110983576-2739e180-8327-11eb-9cc0-79c43a956292.png)



