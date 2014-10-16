pollutantmean <- function(directory, pollutant, id = 1:332) {
  monitor_files = paste(directory, '/', sprintf('%03d', id), '.csv', sep='')
  master_list <- c()
  for (mf in monitor_files) {
    this_df <- read.csv(mf)
    master_list <- c(master_list, this_df[[pollutant]])
  }
  mean(master_list, na.rm=TRUE)
}