getOutcomeRegex <- function(outcome) {
   pattern <- gsub("\\s+", "?", paste("*", trimws(outcome), sep = ""))
   glob2rx(pattern, trim.head = TRUE)
}

fixupColumns <- function(data) {
   data[, 2] <- as.factor(data[, 2])
   data[, 3] <- suppressWarnings(as.numeric(data[, 3], na.rm = TRUE))
   data[, 4] <- suppressWarnings(as.numeric(data[, 4], na.rm = TRUE))
   data[, 5] <- suppressWarnings(as.numeric(data[, 5], na.rm = TRUE))
   data
}

best <- function(state, outcome) {
   ## Read outcome data.  Assumes outcome data is in the working directory.
   ## We limit the columns to only the ones that are necessary in the function.
   outcomeData <- read.csv("outcome-of-care-measures.csv", colClasses = c("NULL", "character", rep("NULL", 4), "character", rep("NULL", 3), "character", rep("NULL", 5), "character", rep("NULL", 5), "character", rep("NULL", 23)))

   ## Check that state is valid by looking at the data in the State column
   if (!state %in% outcomeData$State) {
      stop("invalid state")
   }

   ## Check that the outcome is valid by looking at the columns. Here we build
   ## a regex based on the outcome given to locate the appropriate column.
   targetCol = grep(getOutcomeRegex(outcome), colnames(outcomeData), ignore.case = TRUE)
   if (length(targetCol) == 0) {
      stop("invalid outcome")
   }

   ## Return hospital name in that state with lowest 30-day death rate. Here we coerce the values
   ## to numeric, filter on the factor-ized state, and find the minimum of that state.  If there
   ## are more than one rows with the min value, we sort by hospital name, and return the name in
   ## the first row.
   outcomeData <- fixupColumns(outcomeData)
   stateData <- outcomeData[outcomeData$State == state,]
   minRows <- stateData[which(stateData[, targetCol] == min(stateData[, targetCol], na.rm = TRUE)), ]
   if (nrow(minRows) > 1) {
      minRows <- minRows[order("Hospital.Name")]
   }
   minRows[1,1]
}