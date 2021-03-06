######################Chapter 8 - Bagging and Random Forest###########################

##Here we apply Bagging and Random Forest to Boston data using randomForest package in R.
##Note that bagging is just a special case of random forest with m = p, hence the function randomForest() can be used to perform both random forest and bagging.

library(MASS) ##For Boston data set.
##install.packages("randomForest")
library(randomForest)

?Boston
data(Boston)
dim(Boston) ##A 506 x 14 variable data set.
summary(Boston)
str(Boston)
names(Boston)

set.seed(1)
train =sample(1:nrow(Boston), nrow(Boston)/2)
boston.test =Boston[-train, "medv"]

####Bagging#####
set.seed(1)
?randomForest
bag.boston =randomForest(medv~., data=Boston, subset =train, mtry=13, importance=TRUE)
## The argument mtry=13 indicates that all 13 variables should be considered at every split. i.e. Bagging must be done.
bag.boston
names(bag.boston)

##Now let us check how well bagging performs on test data.
yhat.bag =predict(bag.boston, newdata =Boston[-train, ])
plot(yhat.bag, boston.test)
abline(0, 1)
mean((yhat.bag-boston.test)^2)  ##13.47
##Test MSE associated with a bagged regression tree is 13.47 almost half of what is obtained by a optimally pruned single tree.
##We can change the number of tree grown by ntree argument.

bag.boston =randomForest(medv~., data=Boston, subset =train, mtry=13, ntree=25)
yhat.bag =predict(bag.boston, newdata =Boston[-train, ])
mean((yhat.bag-boston.test)^2) ##13.43

#### Random Forest ####
##Growing a random forest proceeds almost the same way except that we use a smaller value for mtry argument.

## By default, randomForest() uses mtry = p/3 when building a random forest of regression trees.
## and uses mtry =sqrt(p) when builing a random forest of classification trees.
set.seed(1)
rf.boston =randomForest(medv~., data =Boston, subset =train, mtry =6, importance =TRUE)
yhat.rf =predict(rf.boston, newdata =Boston[-train, ])
mean((yhat.rf-boston.test)^2) ##The test MSE is 11.31, which implies randfom forest provided an improvement over bagging.

##Using the importance() function we can veiw the importance of each variable.
?importance
importance(rf.boston)
##Two measures of variable importance are reported. 
##The former (%IncMSE) is based on mean decrease of accuracy in predictions on out of bag samples.
##The later is a measure of the total decrease in node impurity that results froms splits over that variable averaged over all trees.
##For regression trees, the node impurity is measured by training RSS while for classification trees by deviance.
##Plots of these measures can be generated by function varImpPlot().
?varImpPlot
varImpPlot(rf.boston)

rm(list =ls())
