getMonitorFileName <- function(directory, id, ext=".csv") {
  file.path(directory, paste(sprintf("%03d", id) , ext, sep=""))
}

complete <- function(directory, id = 1:332) {
  compVals <- data.frame(id = integer(length(id)), nobs = integer(length(id)))
  cnt <- 0
  for (x in id) {
    compVals[cnt <- cnt + 1, ] = c(x, sum(complete.cases(read.csv(getMonitorFileName(directory, x)))))
  }
  compVals
}