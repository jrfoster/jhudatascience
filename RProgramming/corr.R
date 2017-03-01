corr <- function(directory, threshold = 0) {
  files <- list.files(directory, full.names = TRUE)
  corVals <- numeric()
  cnt <- 0
  for (file in files) {
    content <- read.csv(file)
    pruned <- content[complete.cases(content),]
    if (nrow(pruned) > threshold) {
      corVals <- append(corVals, cor(x = pruned$sulfate, y=pruned$nitrate))
    }
  }
  corVals
}