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
  summary <- summarise(grouped.nei, emissions = sum(Emissions)/1e6) 
  plot(summary,
       xlab = 'Year',
       ylab = 'Total emmisions [in millions of tons]',
       main = 'Total emissions of PM2.5 by year')

  # perform linear fit to data
  linear.model <- lm(emissions ~ year, summary)
  abline(linear.model, lwd = 2)

  # extract the slope and R^2 value from the fit
  slope <- linear.model[['coefficients']]['year']
  r.squared <- summary(linear.model)[['adj.r.squared']]

  # create labels and draw them to the plot
  slope.label <- bquote(Slope == .(format(slope, digits = 2)))
  r.sq.label <- bquote(italic(R)^2 == .(format(r.squared, digits = 3)))

  x.pos <- 2006
  y.pos <- 7.1
  y.spacing <- 0.35             
  text(x.pos, y.pos, slope.label, adj = c(0,0)); y.pos <- y.pos - y.spacing
  text(x.pos, y.pos, r.sq.label , adj = c(0,0)); y.pos <- y.pos - y.spacing

  dev.off()
}

# ------------------------------------------------------------------------------
# solution to problem 2
# This problem focuses on Baltimore City, Maryland. We want to determine if the
# total emissions from PM2.5 has decreased in Baltimore during the period of
# this study.
Problem2 <- function() {
  # Group the data frame by the year and city
  grouped.nei <- filter(NEI, fips == '24510') %>%
    group_by(year)

  # open the png plot device
  png('plot2.png')

  # plot the sum of the emissions by the year
  # this is done implicitly because the data is grouped by year. Therefore, the
  # summarise function returns a data frame with two columns whcih can directly
  # be plotted
  summary <- summarise(grouped.nei, emissions = sum(Emissions)/1e3)
  plot(summary,
       xlab = 'Year',
       ylab = 'Total emmisions [in thousands of tons]',
       main = 'Total emissions of PM2.5 by year in Baltimore City, MD')

  # perform linear fit to data
  linear.model <- lm(emissions ~ year, summary)
  abline(linear.model, lwd = 2)

  # extract the slope and R^2 value from the fit
  slope <- linear.model[['coefficients']]['year']
  r.squared <- summary(linear.model)[['adj.r.squared']]

  # create labels and draw them to the plot
  slope.label <- bquote(Slope == .(format(slope, digits = 2)))
  r.sq.label <- bquote(italic(R)^2 == .(format(r.squared, digits = 3)))

  x.pos <- 2006
  y.pos <- 3.2
  y.spacing <- 0.12             
  text(x.pos, y.pos, slope.label, adj = c(0,0)); y.pos <- y.pos - y.spacing
  text(x.pos, y.pos, r.sq.label , adj = c(0,0)); y.pos <- y.pos - y.spacing

  dev.off()
}


