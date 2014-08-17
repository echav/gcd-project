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

Download the script `run_analysis.R`.
In R, source it:
* if needed, make the directory that constains the script the working directory (using the `cwd`command)
* `source("run_analysis.R")`
Call the `run_analysis` function `run_analysis(PATH-TO-UCI-HAR-DATASET, OUTPUT-FILENAME)` providing as parameters the path to the folder containing the uncompressed input data and the name of the filewhere cleaned-up data will be saved.

Note: the `run_analysis` function also returns the result data so you can use it directly if needed: `clean_data <- run_analysis(PATH-TO-UCI-HAR-DATASET, OUTPUT-FILENAME)`.

### How this script works


