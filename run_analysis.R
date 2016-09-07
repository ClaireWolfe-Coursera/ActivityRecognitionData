## Load libraries.
library(tidyr)
library(dplyr)

## STEP 0: Read in the raw data files.
print("STEP 0: Read in the raw data files.")

## ASSUMPTION: Users of this script will have already downloaded and unzipped the data
## onto their computers and set their working directory to be the directory holding
## the unzipped data.
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")


## STEP 1: Merge the training and the test sets to create one data set.
print("STEP 1: Merge the training and the test sets to create one data set.")

## Create a test table using:
##      subject_test to specify values for a Subject column,
##      y_test to specify values for an Activity column, and 
##      x_test to specify values for all the data measurement columns.
##      features to create variable names for the measurement columns.
test_table <- cbind(subject_test, y_test, x_test)
colnames(test_table) <- c("Subject", "Activity", as.character(features[, 2]))

## Do the same to create and label a train_table.
train_table <- cbind(subject_train, y_train, x_train)
colnames(train_table) <- c("Subject", "Activity", as.character(features[, 2]))

## Merge the test and train tables.
merged_table <- rbind(test_table, train_table)


## STEP 2: Extract only the measurements on the mean and standard deviation for each measurement.
print("STEP 2: Extract only the measurements on the mean and standard deviation for each measurement.")

## Subset the merged table to include only those mean() and std() measurement columns.
keep_cols <- grep("Subject|Activity|mean\\(\\)|std\\(\\)", names(merged_table))
mean_std_table <- merged_table[, keep_cols]


## STEP 3: Uses descriptive activity names to name the activities in the data set.
print("STEP 3: Uses descriptive activity names to name the activities in the data set.")

## Clean up the activity labels for readability by replacing underscore with space.
## Use those cleaned up activity labels as values in the Activity column.
activities <- sub("_", " ", activity_labels$V2)
mean_std_table$Activity <- sapply(mean_std_table$Activity, function (x) activities[x])


## STEP 4: Appropriately label the data set with descriptive variable names.
print ("STEP 4: Appropriately label the data set with descriptive variable names.")

## Although not strictly necessary to fulfill the assignment, I have decided to separate 
## the measurement columns into columns Feature (e.g., tBodyAcc), Funtion (e.g., mean()),
## and Direction (e.g., X).  The measurement value will go into a Measurement column.

## To do this I gather columns into feature_function_direction and Measurement columns.
## Then separate the feature_function_direction column into 3 separate variables.
## NOTE: The Direction column will have some NA values.
tidy_table <- mean_std_table %>% 
              gather(feature_function_direction, Measurement, -Subject, -Activity) %>%
              separate(feature_function_direction, c("Feature", "Function", "Direction"), 
                       sep = "-")

## NOTE: Although it seems it would be nice to spread the Function variable into two variables
## named Mean and Standard Deviation to hold the measurement values, since each subject/activity
## combination has multiple mean and std values for each activity, spreading the Function 
## variable will not work.


## STEP 5: From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.
(print("STEP 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."))

## Group the table by Subject, Activity, Feature, Function, and Direction.
## Then calculate the mean for each group to get the average per group.
grp <- group_by(tidy_table, Subject, Activity, Feature, Function, Direction)
average_table <- summarize(grp, Average = mean(Measurement))


## Finally, print the table to the console.
print(average_table)