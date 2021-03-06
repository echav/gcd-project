gcd-project
===========

This project contains my submission for the [Project assignment](https://class.coursera.org/getdata-006/human_grading) of the [Getting and Cleaning Data](https://class.coursera.org/getdata-006/) class on Coursera.

The files in this project are:
* `README.md`: this file. Explains how all of the scripts work
* `CodeBook.md`: describes the variables, the data, and any transformations or work that was performed to clean up the data
* `run_analysis.R`: code, commented inside and below in this file

### How to use this script

As requested in the assignment, download the data file here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

Unzip it: this will create a folder named `UCI HAR Dataset` that contains the data files.

Download the script `run_analysis.R` in the same folder (at the same level) as `UCI HAR Dataset`.

In R, source it:
* make the directory that constains the script the working directory (using the `cwd`command)
* execute `source("run_analysis.R")`
* this will launch the script

The script will generate in the directory 2 files:
* `questions_1_4.txt`: contains the output of the sequence of the questions 1 to 4
* `question_5.txt`: contains the output of the question 5

### How this script works

#### Data loading (question 1)

The `loadRawData` function takes care of loading all the relevant data (the `X`, `y` and `subject` files for resp. the `train` and `test` file collections), and bind them in a single data frame. 

For the `test` files, the 3 `X`, `y` and `subject` files are actually loaded by the same `loadTable` function, and then they are coloumn bound. This is done in the `loadAndBind`function that is also used to load the `train` data, given that the files organization is the same in both data sets.

After that, the 2 resulting data frames are row-bound.

At last, the column names are loaded from the `features` file, and completed so that appropriate column names are assigned to the global data frame.

#### Keeping only relevant columns (question 2)

This is done using the `subset` R function, and a regular expression to keep only columns which have a name containing `subject`, `mean`, `std` or equaling `y`:
```
data <- data[,grepl("(subject)|(mean)|(std)|(^y$)", names(data))]
```

#### Setting the descriptive avtivity names (question 3)

This is done in 3 operations in the `setDescriptiveActivityNames` function:
* load the `activity_labels.txt` in a data frame, and name its columns resp. `y` and `activity`
* execute an R `merge` on the `y` column between this data frame and the actual data frame we prepared before (both have a `y` column); this builds a join.
* remove the now useless `y` column in  the resulting data frame

#### Naming appropriately the data set with descriptive variable names (question 4)

We use a simple transformation to rename the variables that look like tBodyAcc-mean()-X	in to something like timeBodyAcc.mean.X:
* replace `t` prefixes by `Time` and `f` prefixes by `Freq`
* replace `-` separators by `.` (seems to be a more common convention in R)
* remove the parenthesis that do not really add any useful information to the reader

This is done in the `tidyColNames` function using regular expressions and the R `gsub` function.

### Compute average of each variable for each activity and each subject (question 5)

This is done using the `plyr` and `reshape2` libraries that may need to be installed (using `install.packages`)
* first we melt all the features column, keeping the Subject and Activity columns as "indexes": this creates a table with 3 columns (Subject, Activity, and a "variable")
* the we use `ddply` to apply a `mean` computation on the "variable column", grouping by Subject and Activity
* at last we set nicer column names and we save the file
