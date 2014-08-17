## GLOBAL VARIABLES  ##################################################################################################

# Indicate once for all where the data files are
rootDataFolder <- "/Users/ech/Documents/docs_no_backup/UCI HAR Dataset/"


## HELPER FUNCTIONS ###################################################################################################

# Loads the test, and training data, and bind them with the subject and activity files. Also assign variable names 
# based on the provided features file.
# Arguments:
# - path of the root folder where all the files are, e.g. path to the folder where the content of the uncompressed zip 
# file is
loadRawData <- function() {
  
  # Helper function to load provided data in a table
  # Arguments:
  # - dataSetName : one of "train", "test"
  loadAndBind <- function(dataSetName) {

    # Helper function to load provided data files in a table
    # Arguments:
    # - dataSetName : one of "train", "test"
    # - dataNature : one of "X", "y", "subject"
    loadTable <- function(dataSetName, dataNature) {
      # compute the file name to load in a compatible way for different OS's (Windows vs rest of the world)
      filename <- file.path(rootDataFolder, dataSetName, paste(dataNature, "_", dataSetName, ".txt", sep=''))
      # actual loading of the file
      read.table(file = filename)    
    }
    
    X <- loadTable(dataSetName, "X")
    y <- loadTable(dataSetName, "y")
    subject <- loadTable(dataSetName, "subject")
    cbind(subject, X, y)
  }
  
  
  # load the training and test data and bind them
  train <- loadAndBind("train")
  test  <- loadAndBind("test") 
  data  <- rbind(train, test)

  # load the the colunm names
  colNames <- read.table(file = file.path(rootDataFolder, "features.txt"))
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
  activityNames <- read.table(file = file.path(rootDataFolder, "activity_labels.txt"))
  # rename its columns nicely
  colnames(activityNames) <- c("y", "activity")
  # do a join wih the actual data based on the nu:eric value of the activity ('y' column in both data frames)
  data <- merge(x = data, y=activityNames, by.x = "y", by.y = "y")
  # remove the now useless 'y' column in the resulting data frame
  data <- subset(data,select=-c(y))
  # return the result
  data

}


## ACTUAL WORK  #######################################################################################################

# Q1 : loads all the provided data and set column names
data <- loadRawData()

# Q2 : keep only subject, means and stds, and y columns
data <- data[,grepl("(subject)|(mean)|(std)|(^y$)", names(data))]

# Q3 : load the lables for activities and merge with data 
data <- setDescriptiveActivityNames(data)


