# ActivityRecognitionData
This repository contains the final assignment of the Coursera Getting and Cleaning Data class that manipulates human activity recognition data collected with a smartphone.

## Introduction

This repository contains a script that fulfills the requirements of the assignment for the Coursera class Getting and Cleaning Data (https://www.coursera.org/learn/data-cleaning).

The directions for how to create this script are:

"You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."


## Raw Data

The raw data used in this assignment can be found here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

To find details of what is in the raw data, see the README.md file included in the zip file.

You can find out more information about the data that was obtained on their website at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.  


## Script Details

This script creates two tables of interest:

- tidy_table: merges raw data files to create one table containing mean and standard deviation measurements of all subjects for all features (tBodyAcc, tBodyAccJerk, etc.) measured in each direction (X, Y, or Z)
- average_table: groups the tidy_table by Subject, Activity, Feature, Function, and Direction, and computes the Average (calculated using the mean function) for each group.

For the definitions and values of the table variables, please see the Code Book included in this repository.

Note that this script will produce a warning: "Too few values at X locations..." This warning stems from the fact that not every row in the tables will have a Direction value.  This is okay - these rows will be set to NA in the Direction column.

To see the details of the steps used to create these two tables, I have included the script comments here for convenience:

### STEP 0: Load libraries and read in the raw data files.
ASSUMPTION: Users of this script will have already downloaded and unzipped the data
onto their computers and set their working directory to be the directory holding
the unzipped data.

### STEP 1: Merge the training and the test sets to create one data set.
Create a test table using:

- subject_test to specify values for a Subject column
- y_test to specify values for an Activity column
- x_test to specify values for all the data measurement columns
- features to create variable names for the measurement columns

Do the same to create and label a train_table.

Merge the test and train tables.

### STEP 2: Extract only the measurements on the mean and standard deviation for each measurement.

Subset the merged table to include only those mean() and std() measurement columns.

### STEP 3: Uses descriptive activity names to name the activities in the data set.

Clean up the activity labels for readability by replacing underscore with space.
Use those cleaned up activity labels as values in the Activity column.

### STEP 4: Appropriately label the data set with descriptive variable names.

Although not strictly necessary to fulfill the assignment, I have decided to separate 
the measurement columns into columns Feature (e.g., tBodyAcc), Funtion (e.g., mean()),
and Direction (e.g., X).  The measurement value will go into a Measurement column.

To do this I gather columns into feature_function_direction and Measurement columns.
Then separate the feature_function_direction column into 3 separate variables.

NOTE: The Direction column will have some NA values.

NOTE: Although it seems it would be nice to spread the Function variable into two variables
named Mean and Standard Deviation to hold the measurement values, since each subject/activity
combination has multiple mean and std values for each activity, spreading the Function 
variable will not work.

### STEP 5: From the data set in step 4, creates a second, independent tidy data set
with the average of each variable for each activity and each subject.

Group the table by Subject, Activity, Feature, Function, and Direction.
Then calculate the mean for each group to get the average per group.

Finally, write out the average table to the current working directory.
