library(dplyr)
library(reshape2)
library(ggplot2)

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

Problem5()
