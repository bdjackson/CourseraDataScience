# Code Book

This code book describes how to read the tidy data set.

## Summary

In this tidy data set, there are 68 columns, where each column corresponds to a different variable (described below).
Each row represents a single combination of subject and action being performed.
The data in each row is the mean for each of 66 variables given this subject and action combination.

## Variable summary

The following table is a summary of the variables contained in each of the columns in the tidy data set.
Recall, that **all of the variables** apart from subject and activity represent the mean of the measurement from the phone data (this is not stated explicitely in the table).

Variable name             |  Description
:-------------            |  :-----------
Subject                   |  Number corresponding to subject
Activity                  |  One of six activities being performed: <ul> <li>LAYING <li>SITTING <li>STANDING <li>WALKING <li>WALKING_DOWNSTAIRS <li>WALKING_UPSTAIRS
fBodyAcc.mean.X           |  Mean               of FFT of body acceleration     (x direction) measurement
fBodyAcc.mean.Y           |  Mean               of FFT of body acceleration     (y direction) measurement
fBodyAcc.mean.Z           |  Mean               of FFT of body acceleration     (z direction) measurement
fBodyAcc.std.X            |  Standard deviation of FFT of body acceleration     (x direction) measurement
fBodyAcc.std.Y            |  Standard deviation of FFT of body acceleration     (y direction) measurement
fBodyAcc.std.Z            |  Standard deviation of FFT of body acceleration     (z direction) measurement
fBodyAccJerk.mean.X       |  Mean               of FFT of body jerk             (x direction) measurement
fBodyAccJerk.mean.Y       |  Mean               of FFT of body jerk             (y direction) measurement
fBodyAccJerk.mean.Z       |  Mean               of FFT of body jerk             (z direction) measurement
fBodyAccJerk.std.X        |  Standard deviation of FFT of body jerk             (x direction) measurement
fBodyAccJerk.std.Y        |  Standard deviation of FFT of body jerk             (y direction) measurement
fBodyAccJerk.std.Z        |  Standard deviation of FFT of body jerk             (z direction) measurement
fBodyAccMag.mean          |  Mean               of FFT of body acceleration     (magnitude) measurement
fBodyAccMag.std           |  Standard deviation of FFT of body acceleration     (magnitude) measurement
fBodyBodyAccJerkMag.mean  |  Mean               of FFT of body jerk             (magnitude) measurement
fBodyBodyAccJerkMag.std   |  Standard deviation of FFT of body jerk             (magnitude) measurement
fBodyBodyGyroJerkMag.mean |  Mean               of FFT of body angular jerk     (magnitude) measurement
fBodyBodyGyroJerkMag.std  |  Standard deviation of FFT of body angular jerk     (magnitude) measurement
fBodyBodyGyroMag.mean     |  Mean               of FFT of body angular momentum (magnitude) measurement
fBodyBodyGyroMag.std      |  Standard deviation of FFT of body angular momentum (magnitude) measurement
fBodyGyro.mean.X          |  Mean               of FFT of body angular momentum (x direction) measurement
fBodyGyro.mean.Y          |  Mean               of FFT of body angular momentum (y direction) measurement
fBodyGyro.mean.Z          |  Mean               of FFT of body angular momentum (z direction) measurement
fBodyGyro.std.X           |  Standard deviation of FFT of body angular momentum (x direction) measurement
fBodyGyro.std.Y           |  Standard deviation of FFT of body angular momentum (y direction) measurement
fBodyGyro.std.Z           |  Standard deviation of FFT of body angular momentum (z direction) measurement
tBodyAcc.mean.X           |  Mean               of body acceleration            (x direction) measurement
tBodyAcc.mean.Y           |  Mean               of body acceleration            (y direction) measurement
tBodyAcc.mean.Z           |  Mean               of body acceleration            (z direction) measurement
tBodyAcc.std.X            |  Standard deviation of body acceleration            (x direction) measurement
tBodyAcc.std.Y            |  Standard deviation of body acceleration            (y direction) measurement
tBodyAcc.std.Z            |  Standard deviation of body acceleration            (z direction) measurement
tBodyAccJerk.mean.X       |  Mean               of body jerk                    (x direction) measurement
tBodyAccJerk.mean.Y       |  Mean               of body jerk                    (y direction) measurement
tBodyAccJerk.mean.Z       |  Mean               of body jerk                    (z direction) measurement
tBodyAccJerk.std.X        |  Standard deviation of body jerk                    (x direction) measurement
tBodyAccJerk.std.Y        |  Standard deviation of body jerk                    (y direction) measurement
tBodyAccJerk.std.Z        |  Standard deviation of body jerk                    (z direction) measurement
tBodyAccJerkMag.mean      |  Mean               of body jerk                    (magnitude) measurement
tBodyAccJerkMag.std       |  Standard deviation of body jerk                    (magnitude) measurement
tBodyAccMag.mean          |  Mean               of body acceleration            (magnitude) measurement
tBodyAccMag.std           |  Standard deviation of body acceleration            (magnitude) measurement
tBodyGyro.mean.X          |  Mean               of body angular acceleration    (x direction)  measurement
tBodyGyro.mean.Y          |  Mean               of body angular acceleration    (y direction)  measurement
tBodyGyro.mean.Z          |  Mean               of body angular acceleration    (z direction)  measurement
tBodyGyro.std.X           |  Standard deviation of body angular acceleration    (x direction)  measurement
tBodyGyro.std.Y           |  Standard deviation of body angular acceleration    (y direction)  measurement
tBodyGyro.std.Z           |  Standard deviation of body angular acceleration    (z direction)  measurement
tBodyGyroJerk.mean.X      |  Mean               of body angular jerk            (x direction)  measurement
tBodyGyroJerk.mean.Y      |  Mean               of body angular jerk            (y direction)  measurement
tBodyGyroJerk.mean.Z      |  Mean               of body angular jerk            (z direction)  measurement
tBodyGyroJerk.std.X       |  Standard deviation of body angular jerk            (x direction)  measurement
tBodyGyroJerk.std.Y       |  Standard deviation of body angular jerk            (y direction)  measurement
tBodyGyroJerk.std.Z       |  Standard deviation of body angular jerk            (z direction)  measurement
tBodyGyroJerkMag.mean     |  Mean               of body angular jerk            (magnitude) measurement
tBodyGyroJerkMag.std      |  Standard deviation of body angular jerk            (magnitude) measurement
tBodyGyroMag.mean         |  Mean               of body angular acceleration    (magnitude) measurement
tBodyGyroMag.std          |  Standard deviation of body angular acceleration    (magnitude) measurement
tGravityAcc.mean.X        |  Mean               of gravity acceleration         (x direction) measurement
tGravityAcc.mean.Y        |  Mean               of gravity acceleration         (y direction) measurement
tGravityAcc.mean.Z        |  Mean               of gravity acceleration         (z direction) measurement
tGravityAcc.std.X         |  Standard deviation of gravity acceleration         (x direction) measurement
tGravityAcc.std.Y         |  Standard deviation of gravity acceleration         (y direction) measurement
tGravityAcc.std.Z         |  Standard deviation of gravity acceleration         (z direction) measurement
tGravityAccMag.mean       |  Mean               of gravity acceleration         (magnitude) measurement
tGravityAccMag.std        |  Standard deviation of gravity acceleration         (magnitude) measurement

