library(tidyverse)
library(knitr)
#install.packages("arules")
#install.packages("arulesViz")
library(arules)
library(arulesViz)

# create a list of baskets
market_basket <-  
  list(  
    c("apple", "milk", "rice", "meat"),
    c("apple", "milk", "rice"),
    c("apple", "milk"), 
    c("apple", "pear"),
    c("cheese", "milk", "rice", "meat"), 
    c("cheese", "milk", "rice"), 
    c("cheese", "milk"),
    c("cheese", "pear")
  )

# set transaction names (T1 to T8)
names(market_basket) <- paste("T", c(1:8), sep = "")
market_basket

## Convert into transaction database
trans <- as(market_basket, "transactions")
trans

# Inspect dimension
dim(trans)

#Obtain a list of the distinct items in the data:
itemLabels(trans)

# View summary
summary(trans)

#Take a look at all transactions and items in a matrix like fashion:
# Binary incidence matrix 
image(trans)

#Display the relative item frequency:
  
itemFrequencyPlot(trans, topN=10,  cex.names=1)

# A-priori Algorithm
rules <- apriori(trans, 
                 parameter = list(supp=0.3, conf=0.5, 
                                  maxlen=10, 
                                  target= "rules"))

summary(rules)
inspect(rules)

# Remove LHS blank brackets
rules <- apriori(trans, 
                 parameter = list(supp=0.3, conf=0.5, 
                                  maxlen=10, 
                                  minlen=2,
                                  target= "rules"))
inspect(rules)

# Analysing specifc rule
milk_rules_rhs <- apriori(trans, 
                          parameter = list(supp=0.3, conf=0.5, 
                                           maxlen=10, 
                                           minlen=2),
                          appearance = list(default="lhs", rhs="milk"))
inspect(milk_rules_rhs)
