corr <- function(directory, threshold = 0) {
  getCompleteCases <- function(directory, this_id) {
    this_file <- paste(directory, '/', sprintf('%03d', this_id), '.csv', sep='')
    this_df <- read.csv(this_file)
    this_df[complete.cases(this_df),]
  }
  
  list_of_cases <- lapply(1:332, getCompleteCases, directory=directory)
  pruned_cases <- list_of_cases[lapply(list_of_cases, nrow) > threshold]
  
  vapply(pruned_cases, function(x) cor(x$sulfate, x$nitrate), FUN.VALUE=1)
}