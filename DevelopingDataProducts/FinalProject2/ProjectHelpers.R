library(dplyr)
library(caret)

setwd("c:/devr/ddpProject/PrecisionCoaching/")
pmlRaw <- readRDS("pmlTraining.rds")

set.seed(13031)

adelmo <- pmlRaw %>% filter(user_name == 'adelmo') %>% select(roll_belt, pitch_belt, yaw_belt, classe)
inTrainAdelmo <- createDataPartition(adelmo$classe, p=.8, list=FALSE)
adelmoTrain <- adelmo[inTrainAdelmo,]
adelmoMdl <- train(classe ~ roll_belt + pitch_belt + yaw_belt, data=adelmoTrain, method="rf", verbose=FALSE)
save(adelmoMdl, file="./models/adelmoMdl.RData")

carlitos <- pmlRaw %>% filter(user_name == 'carlitos') %>% select(roll_belt, pitch_belt, yaw_belt, classe)
inTrainCarlitos <- createDataPartition(carlitos$classe, p=.8, list=FALSE)
carlitosTrain <- carlitos[inTrainCarlitos,]
carlitosMdl <- train(classe ~ roll_belt + pitch_belt + yaw_belt, data=carlitosTrain, method="rf", verbose=FALSE)
save(carlitosMdl, file="./models/carlitosMdl.RData")

charles <- pmlRaw %>% filter(user_name == 'charles') %>% select(roll_belt, pitch_belt, yaw_belt, classe)
inTrainCharles <- createDataPartition(charles$classe, p=.8, list=FALSE)
charlesTrain <- charles[inTrainCharles,]
charlesMdl <- train(classe ~ roll_belt + pitch_belt + yaw_belt, data=charlesTrain, method="rf", verbose=FALSE)
save(charlesMdl, file="./models/charlesMdl.RData")

eurico <- pmlRaw %>% filter(user_name == 'eurico') %>% select(roll_belt, pitch_belt, yaw_belt, classe)
inTrainEurico <- createDataPartition(eurico$classe, p=.8, list=FALSE)
euricoTrain <- eurico[inTrainEurico,]
euricoMdl <- train(classe ~ roll_belt + pitch_belt + yaw_belt, data=euricoTrain, method="rf", verbose=FALSE)
save(euricoMdl, file="./models/euricoMdl.RData")

jeremy <- pmlRaw %>% filter(user_name == 'jeremy') %>% select(roll_belt, pitch_belt, yaw_belt, classe)
inTrainJeremy <- createDataPartition(jeremy$classe, p=.8, list=FALSE)
jeremyTrain <- jeremy[inTrainJeremy,]
jeremyMdl <- train(classe ~ roll_belt + pitch_belt + yaw_belt, data=jeremyTrain, method="rf", verbose=FALSE)
save(jeremyMdl, file="./models/jeremyMdl.RData")

pedro <- pmlRaw %>% filter(user_name == 'pedro') %>% select(roll_belt, pitch_belt, yaw_belt, classe)
inTrainPedro <- createDataPartition(pedro$classe, p=.8, list=FALSE)
pedroTrain <- pedro[inTrainPedro,]
pedroMdl <- train(classe ~ roll_belt + pitch_belt + yaw_belt, data=pedroTrain, method="rf", verbose=FALSE)
save(pedroMdl, file="./models/pedroMdl.RData")

adelmoTest <- adelmo[-inTrainAdelmo,]
saveRDS(adelmoTest, file="./uploads/adelmo.rds")

carlitosTest <- carlitos[-inTrainCarlitos,]
saveRDS(carlitosTest, file="./uploads/carlitos.rds")

charlesTest <- charles[-inTrainCharles,]
saveRDS(charlesTest, file="./uploads/charles.rds")

euricoTest <- eurico[-inTrainEurico,]
saveRDS(euricoTest, file="./uploads/eurico.rds")

jeremyTest <- jeremy[-inTrainJeremy,]
saveRDS(jeremyTest, file="./uploads/jeremy.rds")

pedroTest <- pedro[-inTrainPedro,]
saveRDS(pedroTest, file="./uploads/pedro.rds")
