library(dplyr)
library(reshape2)
library(ggplot2)

# ------------------------------------------------------------------------------
# helper functions to get the city name from the fips number
GetCityName <- function(fips) {
  if (fips == '24510')
    return('Baltimore City')
  else if (fips == '06037')
    return('Los Angeles County')
  fips
}

GetCityNameList <- function(fips) {
  result <- sapply(fips, GetCityName)
}

# ------------------------------------------------------------------------------
# solution to problem 6
# For this problemm we want to determine how motor vehicle sources have changed
# in Baltimore City, MD over the course of this study
Problem6 <- function(to.png = TRUE) {
  # read in the data files
  if (!exists('NEI')) NEI <- readRDS("summarySCC_PM25.rds")
  if (!exists('SCC')) SCC <- readRDS("Source_Classification_Code.rds")

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # select rows which are related to motor vehicles
  # in order to do this, I am simply choosing the SCC's associated with
  # "Highway vehicles." This should be a reasonably good estimate for all motor
  # vehicles since highway vehicles are the largest source
  scc.codes <- SCC[grepl('Highway', SCC$SCC.Level.Two), 'SCC']
  
  # Group the data frame by the year and city
  grouped.nei <- filter(NEI, SCC %in% scc.codes) %>%
    filter(fips == '24510' | fips == '06037') %>%
    mutate(city = factor(GetCityNameList(fips))) %>%
    group_by(year, city)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # plot the sum of the emissions by the year
  summary.df <- summarise(grouped.nei, emissions = sum(Emissions)/1e3)
  g <- ggplot(summary.df, aes(year, emissions))
  my.plot <- g +
             geom_point(aes(color = city), size = 4) +
             theme_bw() +
             labs(x = 'Year',
                  y = 'Emissions from motor vehicle sources [thousands of tons]',
                  title = expression(paste('Total emissions of PM'[2.5],
                                           ' of motor vehicle related',
                                           ' sources by year'))) +
             facet_grid(city~., scale = 'free') +
             stat_smooth(method = lm, aes(color = city, fill = city)) +
             theme(legend.position = "none")

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # open the png plot device
  if (to.png) png('plot6.png', width = 720, height = 720)
  print(my.plot)
  if (to.png) dev.off()
}

Problem6()
