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

first <- function(x) {
   # Produces the top-left plot as per the project description
   #
   # Args:
   #   x: The transformed power consumption data
   plot(x$Timestamp, x$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
}

second <- function(x) {
   # Produces the top-right plot as per the project description
   #
   # Args:
   #   x: The transformed power consumption data
   plot(x$Timestamp, x$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
}

third <- function(x) {
   # Produces the bottom-left plot as per the project description
   #
   # Args:
   #   x: The transformed power consumption data
   plot(x$Timestamp, x$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")   
   lines(x$Timestamp, x$Sub_metering_2, col = "red")
   lines(x$Timestamp, x$Sub_metering_3, col = "blue")
   legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = c(1,1,1), bty = "n")
}

fourth <- function(x) {
   # Produces the bottom-right plot as per the project description
   #
   # Args:
   #   x: The transformed power consumption data
   plot(x$Timestamp, x$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")
}

plot4 <- function() {
   # Produces "plot4.png" as described in the course project description.  Assumes that
   # the required raw power data is available and unzipped in the current working directory.
   #
   # If the required raw data isn't available in the working directory, the program will halt.
   #
   # Side Effects:
   #   Produces a file named plot4.png in the current working directory
   #
   if (!isDataAvailable()) {
      stop("Requisite data not available in the working directory")
   }
   
   plotData <- prepareData()
   print("Creating plot(s)")
   png(filename = "plot4.png", width = 480, height = 480, bg = "transparent")
   par(mfrow = c(2,2), bg = "transparent")
   first(plotData)
   second(plotData)
   third(plotData)
   fourth(plotData)
   ignored <- dev.off()
}