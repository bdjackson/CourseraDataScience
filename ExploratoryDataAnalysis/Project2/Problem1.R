library(dplyr)
library(reshape2)

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

Problem1()
