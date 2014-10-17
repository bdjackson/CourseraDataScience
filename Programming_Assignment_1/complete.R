getNumComplete <- function(directory, this_id) {
  this_file <- paste(directory, '/', sprintf('%03d', this_id), '.csv', sep='')
  this_df <- read.csv(this_file)
  nrow(this_df[complete.cases(this_df),])
}

complete <- function(directory, id = 1:332) {
  num_complete <- vapply(id, getNumComplete, FUN.VALUE = 1, directory=directory)
  result <- data.frame(id=id, nobs=num_complete)
  result
}