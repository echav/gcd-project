## Code book

This describes the steps to prepare the data in questions 1 to 4, and the form into which they are prepared.

### Source of data

Data comes from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
These data represent data collected from the accelerometers from the Samsung Galaxy S smartphone on several subjects, for several acticities.
A complete description of these data is available here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Form of the data

Data are provided in several files and we are going to use only a subset of those.

Foe each couple (subject, activity), we have a record of 561 features.

Here is the organization and description of the files we will use:
````
UCI HAR Dataset (root folder)
  activity_labels.txt (id->lable mapping for subject activities)
  features.txt (names of the recorded features)
  test (folder)
    subject_test.txt (list of subjects to corresponding to records - see below)
    X_test.txt (records of each 561 feature values)
    y_test.txt (activity id for each of these records)
  train (folder)
    subject_train.txt
    X_train.txt
    y_train.txt
```
The `train` files have 7352 records and the `test` files have 2947 records.

### Data preparation

#### Binding of the files

We are going to create a single file with the test and train data. We will also use the features.txt file to set the column names of the resulting data frame.

The data frame we built is like this:
```
subject           | 561 feature labels from features.txt | y
----------------------------------------------------------------------
                  |                                      |
subject_test.txt  | X_test.txt                           | y_test.txt
                  |                                      |      
----------------------------------------------------------------------
                  |                                      |
subject_train.txt | X_train.txt                          | y_train.txt
                  |                                      |
```





