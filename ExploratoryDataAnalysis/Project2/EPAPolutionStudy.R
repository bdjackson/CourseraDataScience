# TODO Add text here
# ==============================================================================

library(dplyr)
library(reshape2)

# ------------------------------------------------------------------------------
# read in the data files
if (!exists('NEI')) {
  NEI <- readRDS("summarySCC_PM25.rds")
}
if (!exists('SCC')) {
  SCC <- readRDS("Source_Classification_Code.rds")
}

# ------------------------------------------------------------------------------
# solution to problem 1
# shows the total PM2.5 emission from all sources for each of the years in the
# study
Problem1 <- function() {
  # Group the data frame by the year 
  grouped.nei <- group_by(NEI, year)

  # open the png plot device
  png('plot1.png')

  # plot the sum of the emissions by the year
  # this is done implicitly because the data is grouped by year. Therefore, the
  # summarise function returns a data frame with two columns whcih can directly
  # be plotted
  plot(summarise(grouped.nei, sum(Emissions)),
       xlab = 'Year',
       ylab = 'Total emmisions',
       main = 'Total emissions by year')

  dev.off()
}
