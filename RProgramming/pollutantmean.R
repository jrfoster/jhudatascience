getMonitorFileName <- function(directory, id, ext=".csv") {
  file.path(directory, paste(sprintf("%03d", id) , ext, sep=""))
}

getMonitorFileList <- function(directory, id) {
  rv <- character()
  for (x in id) {
    rv <- c(rv, getMonitorFileName(directory, x))
  }
  rv
}

pollutantmean <- function(directory, pollutant, id = 1:332) {
  files <- getMonitorFileList(directory, id)
  pollVals <- data.frame(pollutant = numeric(0))
  for (file in files) {
    pollVals <- rbind(pollVals, read.csv(file)[pollutant])
  }
  colMeans(pollVals, na.rm = TRUE)
}
