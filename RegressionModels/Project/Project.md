# Effect of various attributes on miles per gallon
Brett Jackson  




## Overview
The goal of this study is to use the `mtcars` data set to investigate any
potential relationships associated with the fuel efficiency.
In particular, is there any significant difference in fuel efficiency
associated with the type of transmission (manual or automatic)?

#### TODO Write stuff here

## Method
#### TODO write about the method




Looking at the data in the `mtcars` dataset, the cars with manual transmissions
appear to have higher fuel efficiency with
17.15 mpg
compared with
24.39 mpg for
the cars with automatic transmissions.
Performing a T-test, ignoring any possible confounding relations, the higher
fuel efficiency observed in the cars with manual transmissions is shown to be
significant, with a p-value $< 0.05$, using an alternative hypothesis that
the cars with an manual transmission have higher fuel efficiency.
It is, however, possible that there are confounding factors which can explain
some of this increased fuel efficiency.



![](Project_files/figure-html/exploratory_plots-1.png) 




```r
with(cars, plot(mpg~wt, col=Trans))
abline(c(fit.result.no.interaction$coefficients[1],
         fit.result.no.interaction$coefficients[2]),
       col='black', lwd=2)
abline(c(fit.result.no.interaction$coefficients[1], fit.result.no.interaction$coefficients[2]), col='red')
abline(c(fit.result.no.interaction$coefficients[1] +
           fit.result.no.interaction$coefficients[3],
         fit.result.no.interaction$coefficients[2]),
       col='red', lwd=2)

abline(c(fit.result.with.interaction$coefficients[1],
         fit.result.with.interaction$coefficients[2]),
       col='black', lty=2, lwd=2)
abline(c(fit.result.with.interaction$coefficients[1] +
           fit.result.with.interaction$coefficients[3],
         fit.result.with.interaction$coefficients[2] +
           fit.result.with.interaction$coefficients[4]),
       col='red', lty=2, lwd=2)
```

![](Project_files/figure-html/unnamed-chunk-2-1.png) 

## Interpretation
#### TODO Write about interpretation of data

```r
library(ggplot2)
```

## Appendix


```r
# Set the output options for large and small numbers                             
options(scipen = -2, digits = 2)
library(dplyr)
library(ggplot2)
library(GGally)
cars <- mtcars %>%
        mutate(Trans=as.factor(am)) %>%
        group_by(Trans) %>%
        select(-am, -qsec, -carb, -gear, -drat, -vs)
levels(cars$Trans)[1] = 'Auto'
levels(cars$Trans)[2] = 'Manual'
simple.summary <- summarize(cars, mean(mpg))
simple.test <- t.test(cars[cars$Trans=='Manual',]$mpg,
                      cars[cars$Trans=='Auto',]$mpg,
                      alternative='greater')
# plot(cars, col=cars$Trans, pch=16, size=0.5)
# pairs.plot <- ggpairs(cars[,c('mpg', 'wt', 'cyl', 'Trans')], color='Trans', alpha=0.4)
#pairs.plot <- ggpairs(cars, color='Trans', alpha=0.4)
#pairs.plot
cars.sub <- cars[,c('mpg', 'wt', 'cyl', 'Trans')]
cars.sub <- cars
pairs.plot <- ggpairs(cars.sub,
                      color='Trans',
                      alpha=0.4,
                      upper = list(params = c(corrSize=1)))
corPlot <- ggally_cor(cars.sub, aes(x = 'wt', y = 'mpg', color = 'Trans'), size=3)
pairs.plot <- putPlot(pairs.plot, corPlot, 1, 2)
corPlot <- ggally_cor(cars.sub, aes(x = 'wt', y = 'cyl', color = 'Trans'), size=3)
pairs.plot <- putPlot(pairs.plot, corPlot, 1, 3)
pairs.plot +
  theme(text = element_text(size=12),
        axis.text.x = element_text(angle=0, size=10),
        axis.text.y = element_text(angle=0, size=10)) 
fit.result.no.interaction <- with(cars, lm(mpg ~ wt + as.factor(Trans)))
fit.result.with.interaction <- with(cars, lm(mpg ~ wt + as.factor(Trans) + wt*as.factor(Trans)))
with(cars, plot(mpg~wt, col=Trans))
abline(c(fit.result.no.interaction$coefficients[1],
         fit.result.no.interaction$coefficients[2]),
       col='black', lwd=2)
abline(c(fit.result.no.interaction$coefficients[1], fit.result.no.interaction$coefficients[2]), col='red')
abline(c(fit.result.no.interaction$coefficients[1] +
           fit.result.no.interaction$coefficients[3],
         fit.result.no.interaction$coefficients[2]),
       col='red', lwd=2)

abline(c(fit.result.with.interaction$coefficients[1],
         fit.result.with.interaction$coefficients[2]),
       col='black', lty=2, lwd=2)
abline(c(fit.result.with.interaction$coefficients[1] +
           fit.result.with.interaction$coefficients[3],
         fit.result.with.interaction$coefficients[2] +
           fit.result.with.interaction$coefficients[4]),
       col='red', lty=2, lwd=2)
library(ggplot2)
```
