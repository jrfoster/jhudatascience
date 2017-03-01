suppressMessages(library(dplyr))
suppressMessages(library(caret))

set.seed(13031)

download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/00222/bank.zip", destfile="bank.zip")
unzip("bank.zip")
bank <- read.csv("bank-full.csv", sep = ";")

# Use dplyr to remove the duration column, based on guidance of the data guide on UCI which
# recommends excluding the duration
bank <- bank %>%
  select(-one_of("duration"))

# Create the partition, training and testing sets and save the testing data for later use
inTrain <- createDataPartition(bank$y, p=.7, list=FALSE)
training <- bank[inTrain,]
testing <- bank[-inTrain,]
saveRDS(testing, file="TestingData.rds")

# Generate the model and save it so we can use it on the back-end without regenning it. Here we
# utilize all the cores on the machine, just so we can generate the model quicker
if (!file.exists("gbmModel.RData")) {
  suppressMessages(library(doParallel))
  registerDoParallel(detectCores(all.tests=TRUE, logical=TRUE))
  gbmModel <- train(y ~ poutcome + previous + campaign + age + balance, 
                    data=training, 
                    method="gbm",
                    preProcess=c("center","scale"),
                    trControl=trainControl(method="cv", number=10, classProbs = TRUE),
                    tuneGrid=expand.grid(.n.trees = c(50), .interaction.depth = c(2), .shrinkage = c(.1), .n.minobsinnode = c(100)))
  save(gbmModel, file="gbmModel.RData")
  stopImplicitCluster()
  registerDoSEQ()
  detach("package:doParallel")
} else {
  load("gbmModel.RData")
}


