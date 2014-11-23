library(dplyr)
library(reshape2)
library(ggplot2)

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

Problem4()
