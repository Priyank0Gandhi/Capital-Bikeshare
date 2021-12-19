library(tidyverse)
library(tidyr)
library(ggplot2)
library(GGally)
library(coefplot)
library(corrplot)
library(rpart)
library(rpart.plot)
library(DMwR2)
library(stringr)
library(data.table)
library(mltools)
library(olsrr)
library(leaps)
library(gridExtra)
library(dplyr)
library(randomForest)
library(MASS)
source('C:/Users/PRIYANK GANDHI/Desktop/STAT-515/R progs/eda_grid_funcs.R')


#reading the data into a dataframe and finding the classes of all variables:
d2<-read_csv('C:/Users/PRIYANK GANDHI/Desktop/STAT-515/Data/day.csv')
sapply(d2, class)


#EDA:
d2$weathersit<-as.factor(d2$weathersit)
d2$yr<-as.factor(d2$yr)
d2$mnth<-as.factor(d2$mnth)
d2$workingday<-as.factor(d2$workingday)
d2$weekday<-as.factor(d2$weekday)
d2$holiday<-as.factor(d2$holiday)
d2$season<-as.factor(d2$season)



options(scipen = 10000)

ggplot(d2, aes(x =weekday, y = cnt,fill = weekday)) +
  geom_col()+labs(title= "Barchart for Weekday vs Daily count",
                  y="Total Count", x = "Weekday")

ggplot(d2, aes(x =weekday, y = registered,fill = weekday)) +
  geom_col()+labs(title= "Barchart for Weekday vs Registered users count",
                  y="Registered Count", x = "Weekday")
ggplot(d2, aes(x =weekday, y = casual,fill = weekday)) +
  geom_col()+labs(title= "Barchart for Weekday vs Casual users count",
                  y="Casual users Count", x = "Weekday")

boxplot_grid(d2, 1,vars = c("casual", "registered", "cnt","windspeed","hum", "temp"), ncol=4, nrow = 4)

hist(d2$cnt, main = "Histogram for Bike Rental Counts", xlab = "Rental Counts",)
#Seems to be Normally distributed.

#Constructing the corrplot:

d2<-read_csv('C:/Users/PRIYANK GANDHI/Desktop/STAT-515/Data/day.csv')

vars <- dplyr::select(d2,`cnt`, everything(), -dteday)
corrplot(cor(vars[sapply(vars, function(x) !is.factor(x))]),type="upper", method="color", diag=FALSE,
         tl.srt=30, addCoef.col="black", main="Correlation Plot")


#ggpairs plot:
ggpairs(vars, lower=list(continuous='blank',
                         combo='blank',
                         discrete='blank'),
        
        upper=list(continuous="points",
                   combo="facethist", discrete="facetbar"),
        switch="y")


#Assigning the appropriate classes to all variables:
d2$weathersit<-as.factor(d2$weathersit)
d2$yr<-as.factor(d2$yr)
d2$mnth<-as.factor(d2$mnth)
d2$workingday<-as.factor(d2$workingday)
d2$weekday<-as.factor(d2$weekday)
d2$holiday<-as.factor(d2$holiday)
d2$season<-as.factor(d2$season)



#One-hot encoding:
  
df<- one_hot(as.data.table(d2))
head(df,3)
  df1<-subset(df, select = -c(registered,casual,atemp,instant,dteday))

#Building a linear regression model:

df.lm<- lm((cnt)~ .,df1 )
summary(df.lm)
par(mfrow=c(2,2))
plot(df.lm)
confint(df.lm)
ggcoef(df.lm)




#Best_Subsets selection:
set.seed(2000)
tr<-sample(nrow(df1), size = 500)
train<- df1[tr,]
test<-df1[!tr]





mod1<- lm(cnt~.,data=train)
sum1<-summary(mod1)
sum1$adj.r.squared
cat("training-set RMSE: ", sum1$sigma)
plot(mod1)

leaps<- regsubsets(cnt~.,data=train, nvmax = 37, method = "exhaustive")
leaps
reg.summary<-summary(leaps)
reg.summary


mat=model.matrix(cnt~., data = test)
val.error=rep(NA,27)
for(p in 1:27){
  coefp <- coef(leaps,id=p) # Coefficients for selected variables
  pred <- mat[,names(coefp)]%*%coefp # multiply X matrix by coefficients
  val.error[p] <- mean((test$cnt-pred)^2) # mean squared error
}
val.error
which.min(val.error)

#min error was found to be associated with 23 variables model

round(coef(leaps, 23),3)

best.plot <- function(varName, varLabel, minmax=" ") {
  gg <- ggplot(data.frame(varName), aes(x=seq_along(varName), y=varName)) +
    geom_line() +
    labs(x="Number of variables"
         , y=varLabel, title="Best subsets")
  if (minmax=="min") {
    gg <- gg + geom_point(aes(x=which.min(varName), y=min(varName)),
                          color="red") +
    geom_vline(aes(xintercept=which.min(varName)),linetype="dotted")
  }
  if (minmax=="max") {
    gg <- gg + geom_point(aes(x=which.max(varName), y=max(varName)),
                          color="red") +
      geom_vline(aes(xintercept=which.max(varName)), linetype="dotted")
  }
  return(gg)
}
d <- with(reg.summary, data.frame(rss,adjr2,cp,bic))
grid.arrange(best.plot(d$rss, "RSS"),
             best.plot(d$adjr2, "Adjusted RSq"
                       , "max"),
             best.plot(d$cp, "Cp", minmax="min"),
             best.plot(d$bic, "BIC", minmax="min"),
             ncol=2)

#R-squared train data:
reg.summary$adjr2[17]
reg.summary$adjr2[18]
reg.summary$adjr2[19]

#Rmse train data:
round(sqrt(reg.summary$rss[17]/nrow(train)),2)
round(sqrt(reg.summary$rss[18]/nrow(train)),2)
round(sqrt(reg.summary$rss[19]/nrow(train)),2)

#looking at the results from Best Subsets graphs, model with 19 variables is selected:

model.f1<-lm(cnt~season_1+season_4+yr_1+ mnth_1+mnth_2+mnth_5+mnth_7+mnth_9+ mnth_11+ mnth_12+ holiday_1 +weekday_0+weekday_5+weekday_4+weathersit_1+weathersit_3 +temp +hum+ windspeed ,train )
summary(model.f1)
model.f2<-lm(cnt~season_1+season_3+yr_1+mnth_7+mnth_9+ mnth_10+ holiday_1 +weekday_0+weathersit_2+weathersit_3 +temp +hum+ windspeed ,train)
plot(model.f2)

#After Removing few of the insignificant variables based on their p values and reducing the complexity of the model:
model.final<-lm(cnt~season_1+season_4+yr_1+ mnth_1+mnth_2+mnth_7+mnth_9+ mnth_11+ mnth_12+ holiday_1 +weekday_0+weathersit_1+weathersit_3 +temp +hum+ windspeed ,train)
sum.final=summary(model.final)
sum.final$adj.r.squared
sum.final$sigma
summary(model.final)

#Adj R squared and Rmse of training set after removal of variables:
sum.final$adj.r.squared
cat("training-set RMSE: ", sum.final$sigma)


#prediction using the test data:
p<- predict.lm(model.final,newdata = test )
comp<-data.frame(test$cnt, p)
par(mfrow=c(1,1))
abline(lm(comp$test.cnt~comp$p), main ="predicted vs real values", xlab= "predicted vals", ylab="real counts")




#Random Forest:
bag.count=randomForest(cnt~.,data=df1, subset = tr, importance=T)
print(bag.count)
plot(bag.count, main="Error vs No. of trees")

#prediction using the test Data:
yhat.bag<- predict(bag.count, newdata = test)
tst <- test$cnt
mean((as.numeric(yhat.bag)-as.numeric(tst))^2)


rf<-data.frame(yhat.bag,tst)
#Plot of the important variables:
varImpPlot(bag.count, main = "Variable Importance Chart")


#Plotting test set count vs. predicted count:
ggplot(rf, aes(x=yhat.bag ,y=tst)) +
  geom_point() +
  geom_abline(slope=1,intercept=0) +
labs(x="predicted count",
     y="test count",
     title="Rand Forest: Regression")



