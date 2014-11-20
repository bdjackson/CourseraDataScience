# run_analysis.R
#
# This script is my solution to the "Getting and Cleaning Data" course project
# When run, this script does the following:
#   - Check if the data files have been previously downloaded
#     - If not, download and unzip
#   - Read the training and test datasets
#     - These datasets come in three parts: measurements, activity, subject
#     - The measurement data will be pruned to only select columns describing
#       means and standard deviations of each measureemnt
#   - Merge the test and training data into a single master dataset
#   - Once the master data frame is created, a tidy data set will also be
#     created including the means of each measurement for each subject/activity
#     combination
#
# More information on the tidy data set can be found in the README file
# ==============================================================================
library(dplyr)
library(reshape2)

# ------------------------------------------------------------------------------
# Get and expand data file -- we only want to do this if the file has not been
# downloaded already
dataset.url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
local.file.name <- 'Dataset.zip'
if (!file.exists(local.file.name)) {
  download.file(url = dataset.url, destfile = local.file.name, method = 'curl')
  unzip(local.file.name)
}

# ------------------------------------------------------------------------------
# I am adding a little bit of logic here to turn on and off testing mode.
# Since the files are quite large, I don't want to wait to read the whole
# files. If read.small.sample is set to TRUE, only a subset of the files
# is read. Otherwise, the full sample is read in.
read.small.sample <- FALSE
nrows.to.read <- -1
if (read.small.sample) {
  nrows.to.read <- 1000
}

# ------------------------------------------------------------------------------
# File names for the test and training data files
base.dir.name <- 'UCI HAR Dataset/'
measurement.header <- 'X_'
activity.header <- 'Y_'
subject.header <- 'subject_'

# features file name -- contains column names for measurement files
features.file.name <- paste(base.dir.name, 'features.txt', sep = '')

# activity labels file name
activity.labels.file.name <- paste(base.dir.name,
                                   'activity_labels.txt',
                                   sep = '')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# read in feature list to extract column labels. First, read as data.frame, then
# extract the vector of feature names
feature.list <- read.table(features.file.name, colClasses = 'character')[,'V2']
# update elements to remove special characters
feature.list <- gsub('\\()', '', feature.list)
feature.list <- gsub('-', '.', feature.list)

# read in list of activity labels. First, read as data.frame, then extract as
# vector of activity labels
activity.labels <- read.table(activity.labels.file.name,
                              colClasses = 'factor')[,'V2']

# ------------------------------------------------------------------------------
# Function to read and clean the measurement data 
ReadAndCleanMeasurementData <- function(file.name) {
  # first, read in a tiny subset to get the column classes
  tmp.df <- read.table(file.name, nrows = 10)
  class.vec <- sapply(tmp.df, class)
  rm(tmp.df)

  # Read in the measurement data file and store as a data frame.
  # After reading the table, extract only the information on the columns
  # which contain the mean and standard deviation informantion
  measurement.df <- read.table(file.name,
                               colClasses = class.vec,
                               col.names = feature.list,
                               nrows = nrows.to.read) %>%
    select(contains('mean', ignore.case = FALSE),
           contains('std'),
           -contains('meanFreq'))

  # reorder the columns to be a bit nicer to read
  measurement.df <- select_(measurement.df,
                            .dots = sort(names(measurement.df)))

  # return measurement data frame
  measurement.df
}

# ------------------------------------------------------------------------------
# Function to read and rename the subject data 
ReadSubjectData <- function(file.name) {
  # Read in the subject data file and store as a data frame.
  # After reading the table, rename the colum to subject
  subject.df <- read.table(file.name,
                           nrows = nrows.to.read,
                           colClasses = 'factor') %>%
    rename(Subject = V1)

  # return subject data frame
  subject.df
}

# ------------------------------------------------------------------------------
# Function to read and rename the activity data 
ReadActivityData <- function(file.name) {
  # Read in the activity data file and store as a data frame, rename the column
  # and coerce to a factor
  activity.df <- read.table(file.name, nrows = nrows.to.read) %>%
    rename(Activity = V1) %>%
    mutate(Activity = activity.labels[Activity])

  # return activity data frame
  activity.df
}

# ------------------------------------------------------------------------------
CollectData <- function(file.tag) {
  # construct file names for the measurement, activity and subject files
  measurement.data.file.name <- paste(base.dir.name,
                                      file.tag,
                                      '/',
                                      measurement.header,
                                      file.tag,
                                      '.txt',
                                      sep = '')
  activity.data.file.name <- paste(base.dir.name,
                                   file.tag,
                                   '/',
                                   activity.header,
                                   file.tag,
                                   '.txt',
                                   sep = '')
  subject.data.file.name <- paste(base.dir.name,
                                  file.tag,
                                  '/',
                                  subject.header,
                                  file.tag,
                                  '.txt',
                                  sep = '')

  # Read the input files
  df <- ReadAndCleanMeasurementData(measurement.data.file.name)
  subject.df <- ReadSubjectData(subject.data.file.name)
  activity.df <- ReadActivityData(activity.data.file.name)

  # append the subject and activity dfs to the right of the measurement df
  df <- cbind(df, subject.df, activity.df)
  rm(subject.df)
  rm(activity.df)

  # return the data frame
  df
}

# ------------------------------------------------------------------------------
# Function to extract a master data frame including both the test and training
# data.
ExtractMasterDataFrame <- function() {
  # read in the training and test data sets
  train.df <- CollectData('train')
  test.df <- CollectData('test')

  # Merge the two data frames into one master data frame
  master.df <- rbind(train.df, test.df)
  rm(train.df)
  rm(test.df)

  master.df
}

# ------------------------------------------------------------------------------
# Function to take the master data frame, and extract a tidy data frame
# containing the means of each of the variables
ExtractTidyDataset <- function(master.df) {
  # create a tidy dataset
  #   - melt the data frame to have subject, activity, variable, value
  #   - use dcast to take the melted data, split by subject and activity, then
  #     take the mean for each variable
  #   - re-arrange the order of the rows so the subjects are in numerical order
  #     also, ensure the activities are in order
  tidy.df <- melt(master.df, id = c('Subject', 'Activity')) %>%
    dcast(Subject + Activity ~ variable, mean) %>%
    arrange(as.numeric(levels(Subject)[Subject]), Activity)

  # return the tidy data frame
  tidy.df
}

# ==============================================================================
# Main body of the script. This is where things get done!
master.df <- ExtractMasterDataFrame()
tidy.df <- ExtractTidyDataset(master.df)

# Write the tidy data frame to a file!
write.table(tidy.df, 'tidy_data.txt', row.names = FALSE)
