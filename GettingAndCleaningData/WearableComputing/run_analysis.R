checkPackage <- function(pkg) {
   # Loads and attaches the given package, installing it if not already present.  Note that
   # the implementation uses require.  ?require for more information.
   #
   # Args:
   #   pkg: The package to check given as a name or a character string
   #
   # Side Effects:
   # This method installs dependent packages of the given package.
   # If not able to install what is required, halts termination.
   if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, dep=TRUE)
      if (!require(pkg, character.only = TRUE)) {
         stop("Package not found")
      }
   }
}

isDataAvailable <- function(datadir) {
   # Checks for the existence of the given datadirectory and the test and train subdirectories
   # of the HAR dataset using the current working directory (getwd)
   #
   # Args:
   #   datadir: The directory, relative to getwd() to check
   #
   # Returns:
   # TRUE if the directories are present, FALSE if not
   print(paste("Checking for data directory in", getwd()))
   dir.exists(datadir) &&
      dir.exists(file.path(datadir, "test")) && dir.exists(file.path(datadir, "train"))
}

run_analysis <- function(datadir = "UCI HAR Dataset", outputraw = FALSE) {
   # This R function creates the tidy data set specified for the course project.  Specifically:
   #
   # 1. Merges the training and the test sets to create one data set.
   # 2. Extracts only the measurements on the mean and standard deviation for each measurement.
   # 3. Uses descriptive activity names to name the activities in the data set
   # 4. Appropriately labels the data set with descriptive variable names.
   # 5. From the data set in step 4, creates a second, independent tidy data set with the average
   #    of each variable for each activity and each subject.
   #
   # Args:
   #   datadir: (Optional) The directory, relative to getwd() to check for data.  Default = UCI HAR Dataset
   #   outputraw: (Optional) Whether or not to write the raw data set.
   #
   # Side Effects:
   # Creates a file named finalTidyData.txt in the current working directory.  If outputraw
   # is TRUE, also creates a file named rawTidyData.txt in the working directory.

   # We use the data.table package to do the final aggregations, so make sure we have it first
   checkPackage("data.table")

   # Certain things have to be in certain places, so we make sure of that before proceeding
   if (!isDataAvailable(datadir)) {
      stop("Required data doesn't appear to exist in current working directory.")
   }

   print("Merging training and test sets")
   ## Merges the training and the test sets to create one data set.
   # Here, we combine, separately, the observations, the activity labels and the subjects using rbind
   # and then remove the data sets we no longer need to conserve memory
   # Observations
   X_train <- read.table(file.path(datadir, "train", "X_train.txt"), colClasses = c("numeric"))
   X_test <- read.table(file.path(datadir, "test", "X_test.txt"), colClasses = c("numeric"))
   X_combined <- rbind(X_train, X_test)
   rm(X_train, X_test)
   # Activities
   y_train <- read.table(file.path(datadir, "train", "y_train.txt"), colClasses = c("factor"))
   y_test <- read.table(file.path(datadir, "test", "y_test.txt"), colClasses = c("factor"))
   y_combined <- rbind(y_train, y_test)
   rm(y_train, y_test)
   # Subjects
   subject_train <- read.table(file.path(datadir, "train", "subject_train.txt"))
   subject_test <- read.table(file.path(datadir, "test", "subject_test.txt"))
   subject_combined <- rbind(subject_train, subject_test)
   rm(subject_train, subject_test)

   print("Extracting mean and std features")
   ## Extracts only the measurements on the mean and standard deviation for each measurement.
   # Use a regular expression to find the features with "-mean(" or "-std(" and subset the observations
   # and remove the data sets we no longer need to conserve memory
   features <- read.table(file.path(datadir, "features.txt"), stringsAsFactors = FALSE)[,2]
   meanstd_cols <- grep(".*-mean[(]|.*-std[(]", features)
   X_meanstd <- X_combined[, meanstd_cols]
   rm(X_combined)

   print("Adding descriptive activity names")
   ## Uses descriptive activity names to name the activities in the data set
   # When we read the activities, we created a factor column, so here we set the levels using the names
   activity_labels <- read.table(file.path(datadir, "activity_labels.txt"))
   levels(y_combined$V1) <- activity_labels$V2
   rm(activity_labels)

   print("Labeling the data set")
   ## Appropriately labels the data set with descriptive variable names.
   # We use the features to label the observation data, and strings for activity and subject and then
   # combine the subjects, activities and mean/std observations into one wide dataset using cbind and
   # convert result to data.table. Finally, remove the data sets we no longer need to conserve memory.
   colnames(X_meanstd) <- features[meanstd_cols]
   colnames(y_combined) <- c("ActivityLabel")
   colnames(subject_combined) <- c("Subject")
   dtRawFinal <- data.table(cbind(subject_combined, y_combined, X_meanstd))
   if (outputraw) {
      print(paste("Creating the raw data set: ", file.path(datadir, "rawTidyData.txt")))
      write.table(dtRawFinal, file = file.path(getwd(), "rawTidyData.txt"), sep = ",", row.names = FALSE)
   }
   rm(subject_combined, y_combined, X_meanstd)

   print(paste("Creating the final data set:", file.path(getwd(), "finalTidyData.txt")))
   ## Create a second, independent tidy data set with the average of each variable for each
   ## activity and each subject.
   # We are using data.table aggregation here for performance reasons.
   setkey(dtRawFinal, Subject, ActivityLabel)
   finalTidy <- dtRawFinal[, lapply(.SD, mean), by=c("Subject","ActivityLabel")]
   write.table(finalTidy, file.path(getwd(), "finalTidyData.txt"), sep = ",", row.names = FALSE)
}