library(tidymodels)

#Data Sampling
#The initial_split() function is specially 
#built to separate the data set into a training 
#and testing set. By default, it holds 3/4 of 
#the data for training and the rest for testing. 
#That can be changed by passing the prop argument. 
#This function generates an rplit object, 
#not a data frame. 


iris_split <- initial_split(iris, prop = 0.6)
iris_spli

#To access the observations reserved for training

iris_split %>%
  training() %>%
  glimpse()

# Your turn
# Extract test set


## Reciepe and prep

#recipe
#A recipe is a blueprint that defines a 
#series of data preprocessing steps. 
#These steps can include operations 
#such as normalization, imputation, 
#one-hot encoding, etc. 
#When you create a recipe, 
#you specify what transformations 
#you want to apply to your data,
#but the transformations themselves 
#are not actually applied to the data 
#until the recipe is prepared.

#recipe: Defines the preprocessing 
# steps without applying them.

## Prep
#prep: Uses the training data to 
#calculate the required parameters 
#(e.g., mean and standard deviation)
                                                                   for scaling).

#Pre-process interface
#In tidymodels, the recipes package 
#provides an interface that specializes 
#in data pre-processing.

# recipe() - Starts a new set of transformations to 
#be applied, similar to the ggplot() command. 
#Its main argument is the model’s formula.

#prep() - Executes the transformations 
#on top of the data that is supplied
#(typically, the training data).


  
# step_corr() - Removes variables that have 
#large absolute correlations with other variables

# step_center() - Normalizes numeric data 
#to have a mean of zero

#step_scale() - Normalizes numeric data to have a
#standard deviation of one

iris_recipe <- training(iris_split) %>%
  recipe(Species ~.) %>%
  step_corr(all_predictors()) %>%
  step_center(all_predictors(), -all_outcomes()) %>%
  step_scale(all_predictors(), -all_outcomes()) %>%
  prep() # This gives receipe object

# iris_recipe - print details about the recipe.

# Execute the pre-processing
iris_testing <- iris_recipe %>%
  bake(testing(iris_split)) 

glimpse(iris_testing)

#################

# recipe: Just specifies the steps to 
#be taken.

# TASKS OF PREP

#prep: Estimates the necessary 
#parameters for the transformations 
#and prepares the recipe for application.

#prep: Uses the training data
#to calculate the 
#required parameters 
#(e.g., mean and standard 
#deviation for scaling).

#prep: Creates a prepped recipe 
#that can be applied to new data 
#via the bake function.

#Workflow
#1. Create a Recipe: Specify the 
#preprocessing steps.


#2. Prepare the Recipe: Use prep to 
#compute the necessary parameters.


#3. Apply the Prepared Recipe: 
#Use bake to apply 
#the transformations to the data.


##################

#Performing the same operation 
#over the training data is redundant, 
#because that data has already been prepped. 
#To load the prepared training data into a variable, 
#we use juice(). 
iris_training <- juice(iris_recipe)

glimpse(iris_training)

## Model Training
iris_ranger <- rand_forest(trees = 100, 
                           mode = "classification") %>%
  set_engine("ranger") %>%
  fit(Species ~ ., data = iris_training)

iris_rf <-  rand_forest(trees = 100, 
                        mode = "classification") %>%
  set_engine("randomForest") %>%
  fit(Species ~ ., data = iris_training)

## Prediction
predict(iris_ranger, iris_testing)

iris_ranger %>%
  predict(iris_testing) %>%
  bind_cols(iris_testing) %>%
  glimpse()

## Performance of the model
iris_ranger %>%
  predict(iris_testing) %>%
  bind_cols(iris_testing) %>%
  metrics(truth = Species, estimate = .pred_class)

iris_rf %>%
  predict(iris_testing) %>%
  bind_cols(iris_testing) %>%
  metrics(truth = Species, estimate = .pred_class)

iris_ranger %>%
  predict(iris_testing, type = "prob") %>%
  glimpse()

iris_probs <- iris_ranger %>%
  predict(iris_testing, type = "prob") %>%
  bind_cols(iris_testing)

glimpse(iris_probs)

iris_probs%>%
  gain_curve(Species, .pred_setosa:.pred_virginica) %>%
  glimpse()

iris_probs%>%
  gain_curve(Species, .pred_setosa:.pred_virginica) %>%
  autoplot()

iris_probs%>%
  roc_curve(Species, .pred_setosa:.pred_virginica) %>%
  autoplot()

predict(iris_ranger, iris_testing, type = "prob") %>%
  bind_cols(predict(iris_ranger, iris_testing)) %>%
  bind_cols(select(iris_testing, Species)) %>%
  glimpse()

predict(iris_ranger, iris_testing, type = "prob") %>%
  bind_cols(predict(iris_ranger, iris_testing)) %>%
  bind_cols(select(iris_testing, Species)) %>%
  metrics(Species, .pred_setosa:.pred_virginica, estimate = .pred_class)
