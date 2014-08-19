# This function cleans the data that must be downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzipped, then it saves
# (and returns) the cleaned up data.
#
# Arguments:
# - rootInputDataFolder : where the input unzziped data files are (assuming the file organization inside the unzipped 
# folder has not been changed)
# - outputFilename : file where cleaned data will be saved
#
# Example usage:
#   source("run_analysis.R")
#   run_analysis("/Users/ech/Documents/docs_no_backup/UCI HAR Dataset", "/Users/ech/Documents/docs_no_backup/output.txt")
#
run_analysis <- function(rootInputDataFolder, outputFilename) {
  
  ## HELPER FUNCTIONS  ################################################################################################
  
  # Loads the test, and training data, and bind them with the subject and activity files. Also assign variable names 
  # based on the provided features file.
  # Arguments:
  # - path of the root folder where all the files are, e.g. path to the folder where the content of the uncompressed 
  # zip file is
  loadRawData <- function() {
    
    # Helper function to load provided data in a table
    # Arguments:
    # - dataSetName : one of "train", "test"
    loadAndBind <- function(dataSetName) {
  
      # Helper function to load provided data files in a table
      # Arguments:
      # - dataSetName : one of "train", "test"
      # - dataNature : one of "X", "y", "Subject"
      loadTable <- function(dataSetName, dataNature) {
        # compute the file name to load in a compatible way for different OS's (Windows vs rest of the world)
        filename <- file.path(rootInputDataFolder, dataSetName, paste(dataNature, "_", dataSetName, ".txt", sep=''))
        # actual loading of the file
        read.table(file = filename)    
      }
      
      X <- loadTable(dataSetName, "X")
      y <- loadTable(dataSetName, "y")
      subject <- loadTable(dataSetName, "Subject")
      cbind(subject, X, y)
    }
    
    # load the training and test data and bind them
    train <- loadAndBind("train")
    test  <- loadAndBind("test") 
    data  <- rbind(train, test)
  
    # load the the colunm names
    colNames <- read.table(file = file.path(rootInputDataFolder, "features.txt"))
    colNames <- t(colNames[,2])
    colNames <- c("subject", as.vector(colNames), "y")
  
    # assign the column names
    colnames(data) <- colNames
    
    data
  }
  
  # Function to update the data, replacing the column with the numbers for activities by actual activity labels. The 'y' 
  # column with the activity number representation is dropped, the replacement column with labled is called 'activity'.
  # Arguments:
  # - data : the data that contains the 'y' column with the activity numbers to replace with labels 
  setDescriptiveActivityNames <- function(data) {
    
    # load the activity names file
    activityNames <- read.table(file = file.path(rootInputDataFolder, "activity_labels.txt"))
    # rename its columns nicely
    colnames(activityNames) <- c("y", "Activity")
    # do a join wih the actual data based on the numeric value of the activity ('y' column in both data frames)
    data <- merge(x = data, y=activityNames, by.x = "y", by.y = "y")
    # remove the now useless 'y' column in the resulting data frame
    data <- subset(data,select=-c(y))
    # return the result
    data
  
  }

  # Function that makes more readable column names, by applying a clanup algorithm to each of them (replace f or t 
  # at the beginning by resp Freq and Time, remove parenthesis, replace - separator by .). Returns the input data 
  # frame with modified column names.
  #
  # Arguments:
  # - the data frame for which col names must be cleaned up
  tidyColNames <- function(data) {
    # clean up algo implementation
    tidy <- function(dirty) {
      # replace starting f followed by uppercase by freq
      dirty <- gsub("^(f)([A-Z])", "Freq\\2", dirty)  
      # replace starting t followed by uppercase by time
      dirty <- gsub("^(t)([A-Z])", "Time\\2", dirty)        
      # remove ()
      dirty <- gsub("\\(\\)", "", dirty)
      # replace - by . and return the result
      gsub("\\-", ".", dirty)
    }
    # apply the algorithm to all column names and set the new col names to the input data frame
    colnames(data) <- lapply(names(data), tidy)    
    # return the modified data frame
    data
  }
  
  ## ACTUAL WORK  #####################################################################################################

  # Q1 : loads all the provided data and set column names
  data <- loadRawData()
  
  # Q2 : keep only subject, means and stds, and y columns
  data <- data[,grepl("(Subject)|(mean)|(std)|(^y$)", names(data))]
  
  # Q3 : load the lables for activities and merge with data 
  data <- setDescriptiveActivityNames(data)

  # Q4 : tidy column names
  data <- tidyColNames(data)
  
  # save the resulting data
  write.table(x = data, file = outputFilename)

  # also return the result
  data
}



