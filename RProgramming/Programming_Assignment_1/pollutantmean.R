pollutantmean <- function(directory, pollutant, id = 1:332) {
  # first, construct the monitor file names from the list of id's
  monitor_files <- paste(directory, '/', sprintf('%03d', id), '.csv', sep='')
  # read in each of the data frames from our list of files. This produces a list of data frames
  df_list <- lapply(monitor_files, read.csv)
  
  # create a master list of pollutant values from our monitors.
  # to do this, we use lapply(df_list, '[[', pollutant), to get a list of vectors.
  # each vector is the pollutant info for a particular id.
  # Next, we unclass this list, to get one big vector with all our readouts.
  master_list <- unlist(lapply(df_list, '[[', pollutant))

  # finally, return the mean, ignoring NA values
  mean(master_list, na.rm=TRUE)
}