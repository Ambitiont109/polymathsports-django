setwd("/Users/gianidepalma/Desktop/nba_sp_reference")
library(h2o)
library(tidyverse)

h2o.init()

df<-read.csv("NBA_Final.csv", na.strings = "NA")
# I assume tha the last rows where the score is missing is the "unknown" scores that we want to predict
# however we need to know the other variables and I see many NAs

df<-df%>%mutate %>%
  mutate(ScoreBelow210=as.factor(ifelse(home_Total_Score+away_Total_Score<210,1,0)), ScoreAbove225=as.factor(ifelse(home_Total_Score+away_Total_Score>225,1,0)),
         ScoreBelow205=as.factor(ifelse(home_Total_Score+away_Total_Score<205,1,0)), ScoreAbove230=as.factor(ifelse(home_Total_Score+away_Total_Score>230,1,0)),
         ScoreBelow215=as.factor(ifelse(home_Total_Score+away_Total_Score<215,1,0)), ScoreAbove220=as.factor(ifelse(home_Total_Score+away_Total_Score>220,1,0)),
         HomeWinBy5=as.factor(ifelse(home_Total_Score-away_Total_Score>=5,1,0)),  HomeWinBy10=as.factor(ifelse(home_Total_Score-away_Total_Score>=10,1,0)),
         AwayWinBy5=as.factor(ifelse(away_Total_Score-home_Total_Score>=5,1,0)),  AwayWinBy10=as.factor(ifelse(away_Total_Score-home_Total_Score>=10,1,0)),
         HomeWin=as.factor(ifelse(home_Total_Score>away_Total_Score,1,0)), Total=as.numeric(home_Total_Score+away_Total_Score), 
         HalftimeTotal=as.numeric(home_First_Quarter_Score+away_First_Quarter_Score+home_Second_Quarter_Score+away_Second_Quarter_Score), HomeHalfWin=as.factor(ifelse(home_First_Quarter_Score+home_Second_Quarter_Score>away_First_Quarter_Score+away_Second_Quarter_Score,1,0)), SecondHalfTotal=as.numeric(home_Third_Quarter_Score+away_Third_Quarter_Score+home_Fourth_Quarter_Score+away_Fourth_Quarter_Score+home_OT_score+away_OT_score))%>%
  select(-game_id, -Location, -datetime)%>%select(home_Total_Score, away_Total_Score, ScoreBelow205, ScoreBelow210, ScoreBelow215, ScoreAbove220, ScoreAbove225, ScoreAbove230, HomeWinBy5, HomeWinBy10, AwayWinBy5, AwayWinBy10, HomeWin, Total, HalftimeTotal, SecondHalfTotal, home_First_Quarter_Score, home_Second_Quarter_Score, home_Third_Quarter_Score, home_Fourth_Quarter_Score, home_OT_score, away_First_Quarter_Score, away_Second_Quarter_Score, away_Third_Quarter_Score, away_Fourth_Quarter_Score, away_OT_score, HomeHalfWin, date, home_team, away_team, everything())%>%
  mutate(Case=ifelse(is.na(home_Total_Score),"Test", "Train"))
# The train datase
df_h2o<-as.h2o(df%>%filter(Case=="Train"))

# all the dataset
ALLdf_h2o<-as.h2o(df)
# we will keep the same name for each model in order to avoid memory overaloading
# so every time we build the model we do the prediction and then we arase it

######  Model for Home Score
mlauto<-h2o.randomForest(x=c(29:1054), y=1, training_frame = df_h2o, nfolds = 3)
Home_Score <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for Away Score
mlauto<-h2o.randomForest(x=c(29:1054), y=2, training_frame = df_h2o, nfolds = 3)
Away_Score <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for ScoreBelow205
mlauto<-h2o.randomForest(x=c(29:1054), y=3, training_frame = df_h2o, nfolds = 3)
ScoreBelow200 <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for ScoreBelow210
mlauto<-h2o.randomForest(x=c(29:1054), y=4, training_frame = df_h2o, nfolds = 3)
ScoreAbove220 <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for ScoreBelow215
mlauto<-h2o.randomForest(x=c(29:1054), y=5, training_frame = df_h2o, nfolds = 3)
ScoreAbove220 <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for ScoreAbove220
mlauto<-h2o.randomForest(x=c(29:1054), y=6, training_frame = df_h2o, nfolds = 3)
ScoreBelow200 <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for ScoreAbove225
mlauto<-h2o.randomForest(x=c(29:1054), y=7, training_frame = df_h2o, nfolds = 3)
ScoreAbove220 <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for ScoreAbove230
mlauto<-h2o.randomForest(x=c(29:1054), y=8, training_frame = df_h2o, nfolds = 3)
ScoreAbove220 <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for HomeWinBy5
mlauto<-h2o.randomForest(x=c(29:1054), y=9, training_frame = df_h2o, nfolds = 3)
HomeBy5 <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for HomeWinBy10
mlauto<-h2o.randomForest(x=c(29:1054), y=10, training_frame = df_h2o, nfolds = 3)
HomeBy10 <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for AwayWinBy5
mlauto<-h2o.randomForest(x=c(29:1054), y=11, training_frame = df_h2o, nfolds = 3)
AwayBy5 <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for AwayWinBy10
mlauto<-h2o.randomForest(x=c(29:1054), y=12, training_frame = df_h2o, nfolds = 3)
AwayBy10 <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

######  Model for HomeWin
mlauto<-h2o.randomForest(x=c(29:1054), y=13, training_frame = df_h2o, nfolds = 3)
HomeWin <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Total
mlauto<-h2o.randomForest(x=c(29:1054), y=14, training_frame = df_h2o, nfolds = 3)
Total <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Halftime Total
mlauto<-h2o.randomForest(x=c(29:1054), y=15, training_frame = df_h2o, nfolds = 3)
HalfTotal <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Second Half Total
mlauto<-h2o.randomForest(x=c(29:1054), y=16, training_frame = df_h2o, nfolds = 3)
HalfTotal <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Home First Quarter
mlauto<-h2o.randomForest(x=c(29:1054), y=17, training_frame = df_h2o, nfolds = 3)
HomeFirstQuarter <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Home Second Quarter
mlauto<-h2o.randomForest(x=c(29:1054), y=18, training_frame = df_h2o, nfolds = 3)
HomeSecondQuarter <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Home Third Quarter
mlauto<-h2o.randomForest(x=c(29:1054), y=19, training_frame = df_h2o, nfolds = 3)
HomeThirdQuarter <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Home Fourth Quarter
mlauto<-h2o.randomForest(x=c(29:1054), y=20, training_frame = df_h2o, nfolds = 3)
HomeFourthQuarter <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Home OT
mlauto<-h2o.randomForest(x=c(29:1054), y=21, training_frame = df_h2o, nfolds = 3)
HomeOT <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Away First Quarter
mlauto<-h2o.randomForest(x=c(29:1054), y=22, training_frame = df_h2o, nfolds = 3)
AwayFirstQuarter <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Away Second Quarter
mlauto<-h2o.randomForest(x=c(29:1054), y=23, training_frame = df_h2o, nfolds = 3)
AwaySecondQuarter <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Away Third Quarter
mlauto<-h2o.randomForest(x=c(29:1054), y=24, training_frame = df_h2o, nfolds = 3)
AwayThirdQuarter <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Away Fourth Quarter
mlauto<-h2o.randomForest(x=c(29:1054), y=25, training_frame = df_h2o, nfolds = 3)
AwayFourthQuarter <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Away OT
mlauto<-h2o.randomForest(x=c(29:1054), y=26, training_frame = df_h2o, nfolds = 3)
AwayOT <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

##### Model for Home Half Win
mlauto<-h2o.randomForest(x=c(29:1054), y=27, training_frame = df_h2o, nfolds = 3)
AwayOT <- h2o.saveModel(object=mlauto, path=getwd(), force=TRUE)

#-------------------------------------------------------------------------------------------------
#Predict

Home_Score <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/HomeScore")
Away_Score <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/AwayScore")
Below205 <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/Below205")
Below210 <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/Below210")
Below215 <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/Below215")
Above220 <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/Above220")
Above225 <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/Above225")
Above230 <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/Above230")
HomeBy5 <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/HomeBy5")
HomeBy10 <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/HomeBy10")
AwayBy5 <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/AwayBy5")
AwayBy10 <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/AwayBy10")
HomeWin <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/HomeWin")
Total <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/Total")
HalftimeTotal <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/HalftimeTotal")
Home1st <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/HomeFirst")
Home2nd <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/HomeSecond")
Home3rd <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/HomeThird")
Home4th <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/HomeFourth")
HomeOT <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/HomeOT")
Away1st <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/AwayFirst")
Away2nd <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/AwaySecond")
Away3rd <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/AwayThird")
Away4th <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/AwayFourth")
AwayOT <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/AwayOT")
HomeHalfWin <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/HomeHalfWin")
SecondHalfTotal <- h2o.loadModel("/Users/gianidepalma/Desktop/nba_sp_reference/SecondHalfTotal")

df$PredictHomeScore<-as.data.frame(predict(Home_Score, ALLdf_h2o))$predict
df$PredictAwayScore<-as.data.frame(predict(Away_Score, ALLdf_h2o))$predict
df$PredictBelow205<-as.data.frame(predict(Below205, ALLdf_h2o))$predict
df$PredictBelow210<-as.data.frame(predict(Below210, ALLdf_h2o))$predict
df$PredictBelow215<-as.data.frame(predict(Below215, ALLdf_h2o))$predict
df$PredictAbove220<-as.data.frame(predict(Above220, ALLdf_h2o))$predict
df$PredictAbove225<-as.data.frame(predict(Above225, ALLdf_h2o))$predict
df$PredictAbove230<-as.data.frame(predict(Above230, ALLdf_h2o))$predict
df$PredictHomeBy5<-as.data.frame(predict(HomeBy5, ALLdf_h2o))$predict
df$PredictHomeBy10<-as.data.frame(predict(HomeBy10, ALLdf_h2o))$predict
df$PredictAwayBy5<-as.data.frame(predict(AwayBy5, ALLdf_h2o))$predict
df$PredictAwayBy10<-as.data.frame(predict(AwayBy10, ALLdf_h2o))$predict
df$PredictHomeWin<-as.data.frame(predict(HomeWin, ALLdf_h2o))$predict
df$PredictTotal<-as.data.frame(predict(Total, ALLdf_h2o))$predict
df$PredictHalftimeTotal<-as.data.frame(predict(HalftimeTotal, ALLdf_h2o))$predict
df$PredictHome1st<-as.data.frame(predict(Home1st, ALLdf_h2o))$predict
df$PredictHome2nd<-as.data.frame(predict(Home2nd, ALLdf_h2o))$predict
df$PredictHome3rd<-as.data.frame(predict(Home3rd, ALLdf_h2o))$predict
df$PredictHome4th<-as.data.frame(predict(Home4th, ALLdf_h2o))$predict
df$PredictHomeOT<-as.data.frame(predict(HomeOT, ALLdf_h2o))$predict
df$PredictAway1st<-as.data.frame(predict(Away1st, ALLdf_h2o))$predict
df$PredictAway2nd<-as.data.frame(predict(Away2nd, ALLdf_h2o))$predict
df$PredictAway3rd<-as.data.frame(predict(Away3rd, ALLdf_h2o))$predict
df$PredictAway4th<-as.data.frame(predict(Away4th, ALLdf_h2o))$predict
df$PredictAwayOT<-as.data.frame(predict(AwayOT, ALLdf_h2o))$predict
df$PredictHomeHalfWin<-as.data.frame(predict(HomeHalfWin, ALLdf_h2o))$predict
df$PredictSecondHalfTotal<-as.data.frame(predict(SecondHalfTotal, ALLdf_h2o))$predict

write.csv(df, "output.csv", row.names = FALSE)
