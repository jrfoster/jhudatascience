isDataAvailable <- function() {
   # Checks for the existence of the required power consumption data in the current
   # working directory.
   #
   # Returns:
   # TRUE if the directories are present, FALSE if not
   print(paste("Checking for data in", getwd()))
   file.exists("household_power_consumption.txt")
}

prepareData <- function() {
   # Reads the raw data from the power consumption dataset and performs some simple
   # cleanup to create a POSIXct timestamp from the raw character date and time variables
   # and subsets the raw data to a two day period in February, 2007
   #
   # Returns:
   #   The cleaned subset of data to use in producing the plots
   #
   print("Reading raw data")
   rawData <- read.table("household_power_consumption.txt", sep = ";", na.strings = c("?",""), colClasses = c("character", "character", rep("numeric", 7)), header = TRUE, stringsAsFactors = FALSE)
   print("Transforming...")
   rawData$Timestamp <- as.POSIXct(paste(rawData$Date, rawData$Time), format = "%d/%m/%Y %H:%M:%S")
   plotData <- rawData[rawData$Timestamp >= as.POSIXct("2007-02-01 00:00:00") & rawData$Timestamp <= as.POSIXct("2007-02-02 23:59:59"), c("Timestamp","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")]
   rm(rawData)
   plotData
}

plot3 <- function() {
   # Produces "plot3.png" as described in the course project description.  Assumes that
   # the required raw power data is available and unzipped in the current working directory.
   #
   # If the required raw data isn't available in the working directory, the program will halt.
   #
   # Side Effects:
   #   Produces a file named plot3.png in the current working directory
   #
   if (!isDataAvailable()) {
      stop("Requisite data not available in the working directory")
   }
   
   plotData <- prepareData()
   print("Creating plot")
   png(filename = "plot3.png", width = 480, height = 480, bg = "transparent")
   plot(plotData$Timestamp, plotData$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")   
   lines(plotData$Timestamp, plotData$Sub_metering_2, col = "red")
   lines(plotData$Timestamp, plotData$Sub_metering_3, col = "blue")
   legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = c(1,1,1))
   ignored <- dev.off()
}