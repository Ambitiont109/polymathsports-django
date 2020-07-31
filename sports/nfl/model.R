setwd("/Users/gianidepalma/Desktop/NFL")
library(h2o)
library(tidyverse)

h2o.init()


df<-read.csv("NFL_Final.csv", na.strings = "NA")


df$Date<-as.Date(as.character(df$Date), format = '%m/%d/%y')


# I assume tha the last rows where the score is missing is the "unknown" scores that we want to predict
# however we need to know the other variables and I see many NAs

df<-df%>%mutate(Year=as.factor(format(Date, "%Y")),Month=as.factor(format(Date, "%m")) )%>%
  mutate(ScoreBelow42=as.factor(ifelse(HomePts+VisitPts<42,1,0)), ScoreAbove52=as.factor(ifelse(HomePts+VisitPts>52,1,0)),
         HomeWinBy4=as.factor(ifelse(HomePts-VisitPts>=4,1,0)), HomeWinBy7=as.factor(ifelse(HomePts-VisitPts>=7,1,0)),  HomeWinBy10=as.factor(ifelse(HomePts-VisitPts>=10,1,0)),
         AwayWinBy4=as.factor(ifelse(VisitPts-HomePts>=4,1,0)), AwayWinBy7=as.factor(ifelse(VisitPts-HomePts>=7,1,0)),  AwayWinBy10=as.factor(ifelse(VisitPts-HomePts>=10,1,0)),
         HomeWin=as.factor(ifelse(HomePts>VisitPts,1,0)) )%>%
  select(-Date, -Rk, -weather_data, -Visit_ZIPCODE, -Home_ZIPCODE, -station_pressure, -Home_Days_on_Road)%>%select(HomePts, VisitPts, ScoreBelow42, ScoreAbove52, HomeWinBy4, AwayWinBy4, HomeWinBy7, HomeWinBy10, AwayWinBy7, AwayWinBy10, HomeWin, Total, everything())%>%
  mutate(Case=ifelse(is.na(HomePts),"Test", "Train"))


# The train datase
df_h2o<-as.h2o(df%>%filter(Case=="Train"))

# all the dataset
ALLdf_h2o<-as.h2o(df)


# we will keep the same name for each model in order to avoid memory overaloading
# so every time we build the model we do the prediction and then we arase it

######  Model for Home Score
mlauto<-h2o.randomForest(x=c(13:732), y=1, nfolds = 14, training_frame = df_h2o)
df$PredictHomeScore<-as.data.frame(predict(mlauto, ALLdf_h2o))$predict

######  Model for Away Score
mlauto<-h2o.randomForest(x=c(13:732), y=2, nfolds = 14, training_frame = df_h2o)
df$PredictAwayScore<-as.data.frame(predict(mlauto, ALLdf_h2o))$predict

######  Model for ScoreBelow42
mlauto<-h2o.randomForest(x=c(13:732), y=3, nfolds = 14, training_frame = df_h2o)
df$PredictScoreBelow42<-as.data.frame(predict(mlauto, ALLdf_h2o))$p1

######  Model for ScoreAbove52
mlauto<-h2o.randomForest(x=c(13:732), y=4, nfolds = 14, training_frame = df_h2o)
df$PredictScoreAbove52<-as.data.frame(predict(mlauto, ALLdf_h2o))$p1

######  Model for HomeWinBy4
mlauto<-h2o.randomForest(x=c(13:732), y=5, nfolds = 14, training_frame = df_h2o)
df$PredictHomeWinBy4<-as.data.frame(predict(mlauto, ALLdf_h2o))$p1

######  Model for HomeWinBy7
mlauto<-h2o.randomForest(x=c(13:732), y=7, nfolds = 14, training_frame = df_h2o)
df$PredictHomeWinBy7<-as.data.frame(predict(mlauto, ALLdf_h2o))$p1

######  Model for HomeWinBy10
mlauto<-h2o.randomForest(x=c(13:732), y=8, nfolds = 14, training_frame = df_h2o)
df$PredictHomeWinBy10<-as.data.frame(predict(mlauto, ALLdf_h2o))$p1

######  Model for AwayWinBy4
mlauto<-h2o.randomForest(x=c(13:732), y=6, nfolds = 14, training_frame = df_h2o)
df$PredictAwayWinBy4<-as.data.frame(predict(mlauto, ALLdf_h2o))$p1

######  Model for AwayWinBy7
mlauto<-h2o.randomForest(x=c(13:732), y=9, nfolds = 14, training_frame = df_h2o)
df$PredictAwayWinBy7<-as.data.frame(predict(mlauto, ALLdf_h2o))$p1

######  Model for AwayWinBy10
mlauto<-h2o.randomForest(x=c(13:732), y=10, nfolds = 14, training_frame = df_h2o)
df$PredictAwayWinBy10<-as.data.frame(predict(mlauto, ALLdf_h2o))$p1

######  Model for HomeWin
mlauto<-h2o.randomForest(x=c(13:732), y=11, nfolds = 14, training_frame = df_h2o)
df$PredictHomeWin<-as.data.frame(predict(mlauto, ALLdf_h2o))$p1

##### Model for Total
mlauto<-h2o.randomForest(x=c(13:732), y=12, nfolds = 14, training_frame = df_h2o)
df$PredictTotal<-as.data.frame(predict(mlauto, ALLdf_h2o))$predict

write.csv(df, "output_qb_div.csv", row.names = FALSE)

shutdown.h2o
Y
