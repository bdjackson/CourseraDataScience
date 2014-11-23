library(dplyr)
library(reshape2)
library(ggplot2)

# ______________________________________________________________________________
# solution to problem 3
# For this problemm we want to determine which of the four PM2.5 sources have
# decreased/increased in Baltimore City over the years of the study. We can do
# this by separating the data by source type and then plotting all four sources
Problem3 <- function(to.png = TRUE) {
  # read in the data files
  if (!exists('NEI')) NEI <- readRDS("summarySCC_PM25.rds")
  if (!exists('SCC')) SCC <- readRDS("Source_Classification_Code.rds")

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Filter only data from Baltimore, then group the data frame by year and type
  grouped.nei <- filter(NEI, fips == '24510') %>%
    group_by(year, type)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # plot the sum of the emissions by the year
  summary.df <- summarise(grouped.nei, emissions = sum(Emissions)/1e3)
  g <- ggplot(summary.df, aes(year, emissions))
  my.plot <- g +
             geom_point(aes(color = type), size = 4) +
             theme_bw() +
             labs(x = 'Year',
                  y = 'Total Emissions [thousands of tons]',
                  title = expression(paste('Total emissions of PM'[2.5],
                                           ' by year in Baltimore City, MD'))) +
             facet_grid(.~type) +
             theme(legend.position = "none", text = element_text(size = 20)) +
             stat_smooth(method = lm, aes(color = type, fill = type))

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # open the png plot device
  if (to.png) png('plot3.png', width = 1440, height = 720)
  print(my.plot)
  if (to.png) dev.off()
}

Problem3()
