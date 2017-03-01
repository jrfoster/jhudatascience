getOutcomeRegex <- function(outcome) {
   pattern <- gsub("\\s+", "?", paste("*", trimws(outcome), sep = ""))
   glob2rx(pattern, trim.head = TRUE)
}

fixupColumns <- function(data) {
   data[[2]] <- as.factor(data[[2]])
   data[[3]] <- suppressWarnings(as.numeric(data[[3]], na.rm = TRUE))
   data[[4]] <- suppressWarnings(as.numeric(data[[4]], na.rm = TRUE))
   data[[5]] <- suppressWarnings(as.numeric(data[[5]], na.rm = TRUE))
   data
}

rankall <- function(outcome, num = "best") {
   ## Read outcome data.  Assumes outcome data is in the working directory.
   ## We limit the columns to only the ones that are necessary in the function.
   outcomeData <- read.csv("outcome-of-care-measures.csv", colClasses = c("NULL", "character", rep("NULL", 4), "character", rep("NULL", 3), "character", rep("NULL", 5), "character", rep("NULL", 5), "character", rep("NULL", 23)))

   ## Check that the outcome is valid by looking at the columns. Here we build
   ## a regex based on the outcome given to locate the appropriate column.
   targetCol = grep(getOutcomeRegex(outcome), colnames(outcomeData), ignore.case = TRUE)
   if (length(targetCol) == 0) {
      stop("invalid outcome")
   }

   ## For each state, find the hospital of the given rank. We use the split-apply-combine pattern
   ## to deal with each of the state factors in the same way
   outcomeData <- fixupColumns(outcomeData)
   byState <- split(outcomeData, outcomeData$State)
   rv <- lapply(byState, function(x) {
      r <- data.frame()
      stateData <- x[order(x[[targetCol]], x[[1]], na.last = NA), ]
      if (num == "best") {
         r <- head(stateData, 1)
      } else if (num == "worst") {
         r <- tail(stateData, 1)
      } else {
         r <- stateData[num, ]
         if (num > nrow(stateData)) {
            r[1,2] = stateData[1,2]
         }
      }
      rownames(r) <- x[1 ,2]
      colnames(r) <- c("hospital", "state")
      r
   })

   ## Return a data frame with the hospital names and the (abbreviated) state name
   rv2 <- unsplit(rv, levels(outcomeData$State), drop = TRUE)
   rv2[, 1:2]
}