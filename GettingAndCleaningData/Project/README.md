# GettingAndCleaningDataProject2

This is my solution to "Getting and Cleaning Data" course project.

## Goals of the project
- Download the UCI "Human Activity Recognition Using Smartphones" data set
- Read the dataset into a data frame
  - This will include both train and test data sets
  - We also want to include information about the subject and the activities being performed
- Once we have the dataset, we want to process it a little bit into a tidy dataset. This includes:
  - Split the dataset up by subject and activity
  - For each subject/activity combination, compute the mean for each measurement.

## Decisions/assumptions made
For this project, we are were to use the variables representing the mean and standard deviations of the measurements taken by the phone during the experiments.
There were columns with names of the form "\*meanFreq\*".
I chose not to include these columns in this analysis becasue they are related to the Fourier transform being performed, but not the actual measurement taking place.

The resulting tidy data frame is in the "wide format," meaning there is a column for each variable, and a row for each subject/activity combination.

## Flow of solution
The main steps taken for my solution are the following
- Read the measurement data for the train data set
  - Remove the unwanted colums
  - Name the columns based on the names in the feature.txt file
  - Order the columns so the mean and standard deviations of the same measurement type are next to one another
- Read the subject data for the train data set
  - Append to the right of the measurement data frame
- Read the activity data for the train data set
  - Rename the activities based on the names in activity\_labels.txt
  - Append to the right of the measurement data frame
- Repeat the above steps for the test data set
- Merge the train and test data frames to one master data frame
- Using melt and dcast, create a tidy data frame which:
  - Separates the measurements based on the subject and the activity performed
  - For each combination of subject and activity, compute the mean for every variable of interest (the mean and sigma for each measurement)
- Arrange the rows of the tidy data frame such that the rows corresponding to the same subject are next to each other

## Code Book
See CodeBook.md for a code book explaining each of the variables
