# Collaborative Filtering
## Source: https://github.com/BrandonHoeft/Recommender-System-R-Tutorial/blob/master/RecommenderLab_Tutorial.Rmd
## Packages
library(dplyr)
library(ggplot2)
library(recommenderlab)

## Available datasets in the package
help(package = "recommenderlab")
datasets_available <- data(package = "recommenderlab")
datasets_available$results[,4] # titles


## Load a dataset to work
data(MovieLense) 
class(MovieLense)
movie_r <- MovieLense 
remove(MovieLense)

## It is formatted as a `realRatingMatrix` class already,
#an object class created within `recommenderlab` 
##for efficient storage of user-item ratings matrices. 
##It's been optimized for storing sparse matrices, 
##where almost all of the elements are empty. 
##As an example, compare the object size of *Movielense*
##as a `realRatingMatrix` vs. a `matrix`. 
library(pryr)
object_size(movie_r)
object_size(as(movie_r, "matrix"))

##The `realRatingMatrix` for this particular
##dataset is about 9 times more efficient in 
##conserving memory than a traditional matrix object.

##Some of the different functions that can be 
##applied to the `realRatingMatrix` are: 
methods(class = "realRatingMatrix")

