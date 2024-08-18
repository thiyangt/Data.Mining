#install.packages('arules')
library(arules)
library(arules)
Red <- c(1, 0, 0, 1, 1, 0, 1, 1, 1, 0)
White <- c(1, 1, 1, 1, 0, 1, 0, 1, 1, 0)
Blue <- c(0, 0, 1, 0, 1, 1, 1, 1, 1, 0)
Orange <- c(0, 1, 0, 1, 0, 0, 0, 0, 0, 0)
Green <- c(1, 0, 0, 0, 0, 0, 0, 1, 0, 0)
Yellow <- c(rep(0, 9), 1)
mat <- matrix(c(Red, White, Blue,
                Orange, Green, Yellow), nrow=10)

colnames(mat) = c("Red", "White", "Blue", "Orange", "Green", "Yellow")
mat

fp.trans <- as(mat, "transactions")
inspect(fp.trans)

rules <- apriori(fp.trans,
                 parameter = list(supp=0.2,
                                  conf=0.5,
                                  target = "rules"))

inspect(head(sort(rules, by="lift"), n=6))


###
data(Groceries)
head(Groceries)

inspect(Groceries[1:5])
summary(Groceries)

rules.transactions<-apriori(Groceries,
                            parameter=list(support = 0.05, 
                                          confidence = 0.25)) 
library(arules)
library(ggplot2)
library(dplyr)
library(tidyr)
library(tidyverse)
# Load the data
data(Groceries)

# Get the item frequency
item_freq <- itemFrequency(Groceries, type = "absolute")

# Convert to a data frame
item_freq_df <- as.data.frame(item_freq) %>%
  rownames_to_column(var = "item") %>%
  arrange(desc(item_freq)) %>%
  head(10)

# Rename columns
colnames(item_freq_df) <- c("item", "frequency")
# Plot the top 10 most frequent items
ggplot(item_freq_df, aes(x = reorder(item, frequency), y = frequency)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 10 Most Frequent Items in Groceries Dataset",
       x = "Items",
       y = "Frequency") +
  theme_minimal()

