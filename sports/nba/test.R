source("config.R")

print(getwd())
library(datasets)
data(iris)
summary(iris)

write.csv(iris, "iris.csv")

