# TODO Add text here
# ==============================================================================

library(dplyr)
library(reshape2)
library(ggplot2)
library(grid)

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
Problem1 <- function(to.png = TRUE) {
  # read in the data files
  if (!exists('NEI')) NEI <- readRDS("summarySCC_PM25.rds")
  if (!exists('SCC')) SCC <- readRDS("Source_Classification_Code.rds")

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Group the data frame by the year 
  grouped.nei <- group_by(NEI, year)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # open the png plot device
  if (to.png) png('plot1.png', width = 720, height = 720)

  # plot the sum of the emissions by the year
  # this is done implicitly because the data is grouped by year. Therefore, the
  # summarise function returns a data frame with two columns whcih can directly
  # be plotted
  summary <- summarise(grouped.nei, emissions = sum(Emissions)/1e6) 
  plot(summary,
       xlab = 'Year',
       ylab = 'Total emmisions [millions of tons]',
       main = expression(paste('Total emissions of PM'[2.5],
                               ' by year in the United States')),
       ylim = c(1.8, 9.3),
       pch = 20)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # perform linear fit to data
  linear.model <- lm(emissions ~ year, summary)
  abline(linear.model, lwd = 2)

  # compute the confidence interval
  smoother <- data.frame(year = seq(min(summary$year), max(summary$year), 0.1))
  conf.interval <- predict(linear.model,
                           newdata=smoother,
                           interval="confidence") 

  # conf.interval <- predict(linear.model, interval="confidence")
  matlines(smoother[, 'year'],
           conf.interval[, c('lwr', 'upr')],
           col='blue',
           lty=2)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # extract the slope and R^2 value from the fit
  slope <- summary(linear.model)[['coefficients']]['year', 'Estimate']
  slope.uncert <- summary(linear.model)[['coefficients']]['year', 'Std. Error']
  adj.r.squared <- summary(linear.model)[['adj.r.squared']]
  p.value <- summary(linear.model)$coef[2,4]

  # create labels and draw them to the plot
  slope.label <- bquote(Slope ==
                        .(format(slope, digits = 2)) %+-%
                        .(format(slope.uncert, digits = 2)))
  adj.r.sq.label <- bquote(Adj.~italic(R)^2 == .(format(adj.r.squared,
                                                        digits = 2)))
  p.value.label <- bquote(italic(p) == .(format(p.value, digits = 2)))

  x.pos <- 2005.5
  y.pos <- 8.8
  y.spacing <- 0.55
  text(x.pos, y.pos, slope.label   , adj = c(0,0)); y.pos <- y.pos - y.spacing
  text(x.pos, y.pos, adj.r.sq.label, adj = c(0,0)); y.pos <- y.pos - y.spacing
  text(x.pos, y.pos, p.value.label , adj = c(0,0)); y.pos <- y.pos - y.spacing

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (to.png) dev.off()
}

# ------------------------------------------------------------------------------
# solution to problem 2
# This problem focuses on Baltimore City, Maryland. We want to determine if the
# total emissions from PM2.5 has decreased in Baltimore during the period of
# this study.
Problem2 <- function(to.png = TRUE) {
  # read in the data files
  if (!exists('NEI')) NEI <- readRDS("summarySCC_PM25.rds")
  if (!exists('SCC')) SCC <- readRDS("Source_Classification_Code.rds")

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Group the data frame by the year and city
  grouped.nei <- filter(NEI, fips == '24510') %>%
    group_by(year)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # open the png plot device
  if (to.png) png('plot2.png', width = 720, height = 720)

  # plot the sum of the emissions by the year
  # this is done implicitly because the data is grouped by year. Therefore, the
  # summarise function returns a data frame with two columns whcih can directly
  # be plotted
  summary <- summarise(grouped.nei, emissions = sum(Emissions)/1e3)
  plot(summary,
       xlab = 'Year',
       ylab = 'Total emmisions [thousands of tons]',
       main = expression(paste('Total emissions of PM'[2.5],
                               ' by year in Baltimore City, MD')),
       ylim = c(0.0, 5.3),
       pch = 20)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # perform linear fit to data
  linear.model <- lm(emissions ~ year, summary)
  abline(linear.model, lwd = 2)

  # compute the confidence interval
  smoother <- data.frame(year = seq(min(summary$year), max(summary$year), 0.1))
  conf.interval <- predict(linear.model,
                           newdata=smoother,
                           interval="confidence") 

  # conf.interval <- predict(linear.model, interval="confidence")
  matlines(smoother[, 'year'],
           conf.interval[, c('lwr', 'upr')],
           col='blue',
           lty=2)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # extract the slope and R^2 value from the fit
  slope <- summary(linear.model)[['coefficients']]['year', 'Estimate']
  slope.uncert <- summary(linear.model)[['coefficients']]['year', 'Std. Error']
  adj.r.squared <- summary(linear.model)[['adj.r.squared']]
  p.value <- summary(linear.model)$coef[2,4]

  # create labels and draw them to the plot
  slope.label <- bquote(Slope ==
                        .(format(slope, digits = 2)) %+-%
                        .(format(slope.uncert, digits = 2)))
  adj.r.sq.label <- bquote(Adj.~italic(R)^2 == .(format(adj.r.squared,
                                                        digits = 2)))
  p.value.label <- bquote(italic(p) == .(format(p.value, digits = 2)))

  x.pos <- 2005.5
  y.pos <- 5.1
  y.spacing <- 0.40
  text(x.pos, y.pos, slope.label   , adj = c(0,0)); y.pos <- y.pos - y.spacing
  text(x.pos, y.pos, adj.r.sq.label, adj = c(0,0)); y.pos <- y.pos - y.spacing
  text(x.pos, y.pos, p.value.label , adj = c(0,0)); y.pos <- y.pos - y.spacing

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (to.png) dev.off()
}

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

# ______________________________________________________________________________
# solution to problem 4
# For this problemm we want to determine how coal combustion-related sources
# have changed over the course of this study
Problem4 <- function(to.png = TRUE) {
  # read in the data files
  if (!exists('NEI')) NEI <- readRDS("summarySCC_PM25.rds")
  if (!exists('SCC')) SCC <- readRDS("Source_Classification_Code.rds")

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # select rows which are related to coal combustion data
  scc.codes <- SCC[grepl('coal', SCC$EI.Sector, ignore.case = TRUE) &
                   grepl('Comb', SCC$EI.Sector, ignore.case = TRUE),
                   'SCC']
  
  # Group the data frame by the year and city
  grouped.nei <- filter(NEI, SCC %in% scc.codes) %>%
    group_by(year)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # summarize the grouped.nei data frame so we can perform fits and make plots
  # The summary column will be the sum of emissions
  summary.df <- summarise(grouped.nei, emissions = sum(Emissions)/1e3)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # fit a linear model and extract the slope, r^2, and p values
  linear.model <- lm(emissions ~ year, data = summary.df)
  slope <- summary(linear.model)[['coefficients']]['year', 'Estimate']
  slope.uncert <- summary(linear.model)[['coefficients']]['year', 'Std. Error']
  adj.r.squared <- summary(linear.model)[['adj.r.squared']]
  p.value <- summary(linear.model)$coef[2,4]

  # create labels for these quantities - to be used later
  slope.label <- paste('Slope == ',
                       format(slope, digits = 2),
                       '%+-%',
                       format(slope.uncert, digits = 2))
  adj.r.sq.label <- paste('Adj.~R^2 == ', format(adj.r.squared, digits = 2))
  p.value.label <- paste('p == ', format(p.value, digits = 2))

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # plot the sum of the emissions by the year
  g <- ggplot(summary.df, aes(year, emissions))
  my.plot <- g +
             geom_point(size = 4) +
             theme_bw() +
             labs(x = 'Year',
                  y = 'Emissions from coal combustion [thousands of tons]',
                  title = expression(atop(paste('Total emissions of PM'[2.5],
                                                ' of coal combustion related'),
                                          paste(' sources by year in the',
                                                ' United States')))) +
             stat_smooth(method = lm) +
             annotate('text',
                      x = 2007,
                      y = c(850, 810, 765),
                      label = c(slope.label, adj.r.sq.label, p.value.label),
                      parse = TRUE)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # open the png plot device
  if (to.png) { png('plot4.png', width = 720, height = 720) }
  print(my.plot)
  if (to.png) dev.off()
}

# ______________________________________________________________________________
# solution to problem 5
# For this problemm we want to determine how motor vehicle sources have changed
# in Baltimore City, MD over the course of this study
Problem5 <- function(to.png = TRUE) {
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
    filter(fips == '24510') %>%
    group_by(year)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # summarize the grouped.nei data frame so we can perform fits and make plots
  # The summary column will be the sum of emissions
  summary.df <- summarise(grouped.nei, emissions = sum(Emissions)/1e3)

  # fit a linear model and extract the slope, r^2, and p values
  linear.model <- lm(emissions ~ year, data = summary.df)
  slope <- summary(linear.model)[['coefficients']]['year', 'Estimate']
  slope.uncert <- summary(linear.model)[['coefficients']]['year', 'Std. Error']
  adj.r.squared <- summary(linear.model)[['adj.r.squared']]
  p.value <- summary(linear.model)$coef[2,4]

  # create labels for these quantities - to be used later
  slope.label <- paste('Slope == ',
                       format(slope, digits = 2),
                       '%+-%',
                       format(slope.uncert, digits = 2))
  adj.r.sq.label <- paste('Adj.~R^2 == ', format(adj.r.squared, digits = 2))
  p.value.label <- paste('p == ', format(p.value, digits = 2))

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # plot the sum of the emissions by the year
  summary.df <- summarise(grouped.nei, emissions = sum(Emissions)/1e3)
  g <- ggplot(summary.df, aes(year, emissions))
  my.plot <- g +
             geom_point(size = 4) +
             theme_bw() +
             labs(x = 'Year',
                  y = 'Emissions from motor vehicle sources [thousands of tons]',
                  title = expression(atop(paste('Total emissions of PM'[2.5],
                                                ' of motor vehicle related'),
                                          paste(' sources by year in Baltimore',
                                                ' City, MD')))) +
             stat_smooth(method = lm) +
             annotate('text',
                      x = 2007,
                      y = c(0.55, 0.50, 0.45),
                      label = c(slope.label, adj.r.sq.label, p.value.label),
                      parse = TRUE)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # open the png plot device
  if (to.png) png('plot5.png', width = 720, height = 720)
  print(my.plot)
  if (to.png) dev.off()
}

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

