assertPackage <- function(pkg) {
  if (!suppressMessages(require(pkg, character.only = TRUE, quietly = TRUE))) {
    install.packages(pkg, dep=TRUE)
    if (!suppressMessages(require(pkg, character.only = TRUE))) {
      stop("Package not found")
    }
  }
}

loadData <- function(datadir) {
  wd <- getwd()
  
  if (!file.exists(file.path(wd, datadir))) {
    dir.create(file.path(wd, datadir))
  }
  setwd(file.path(wd, datadir))
  
  if (!file.exists("pml-training.rds")) {
    if (!file.exists("pml-training.csv")) {
      download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",
                    destfile = "pml-training.csv")
      download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",
                    destfile = "pml-testing.csv")
    }
    
    allPmltraining <- read.csv("pml-training.csv", strip.white = TRUE, na.strings = c("#DIV/0!","NA",""))
    
    # Save an RDS so subsequent knitr executions will be faster
    saveRDS(allPmltraining, file = "pml-training.rds")
  }
  allPmltraining <- readRDS("pml-training.rds")
  setwd(wd)
  return(allPmltraining)
}

createRFModel <- function() {
  if (!file.exists("rfModel.RData")) {
    rfModel <- train(classe ~ ., data=training, method="rf", ntree=250, 
                     trControl=trainControl(method="cv", number=10, preProcOptions="pca"))
    save(rfModel, file="rfModel.RData")    
  } else {
    load("rfModel.RData")
  }
  return(rfModel)  
}

createKNNModel <- function() {
  if (!file.exists("knnModel.RData")) {
    knnModel <- train(classe ~ ., data=training, method="knn", 
                      trControl=trainControl(method="cv", number=10, preProcOptions="pca"))
    save(knnModel, file="knnModel.RData")    
  } else {
    load("knnModel.RData")
  }
  return(knnModel)
}

createGBMModel <- function() {
  if (!file.exists("gbmModel.RData")) {
    gbmModel <- train(classe ~ ., data = training, method="gbm", verbose=FALSE, 
                      trControl=trainControl(method="cv", number=10, preProcOptions="pca"))
    save(gbmModel, file="gbmModel.RData")    
  } else {
    load("gbmModel.RData")
  }
  return(gbmModel)
}