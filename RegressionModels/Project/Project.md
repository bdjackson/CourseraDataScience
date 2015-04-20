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

manual transmission are shown to have a 


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
cars <- mtcars %>% mutate(Transmission=as.factor(am)) %>% group_by(Transmission)
levels(cars$Transmission)[1] = 'Automatic'
levels(cars$Transmission)[2] = 'Manual'
simple.summary <- summarize(cars, mean(mpg))
simple.test <- t.test(cars[cars$Transmission=='Manual',]$mpg,
                      cars[cars$Transmission=='Automatic',]$mpg,
                      alternative='greater')
library(ggplot2)
```
