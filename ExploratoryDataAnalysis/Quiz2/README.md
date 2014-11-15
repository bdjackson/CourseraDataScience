# Quiz 2

## Question 1

Commands such as `xyplot()` and `bwplot()` return a `trellis` object

## Question 2

The lines
```
library(nlme)
library(lattice)
xyplot(weight ~ Time | Diet, BodyWeight)
```
produce a set of 3 panels showing the relationship between weight and time for each diet.

## Question 3

When adding annotations in the lattice environment, `panel.lmline()` is a valid command.

## Question 4

The following code does not print anything to the screen because the object was stored, but not printed to the screen. It the `p <-` part is removed, autoprinting would be used, but we would not have the stored trellis object.
```
library(lattice)
library(datasets)
data(airquality)
p <- xyplot(Ozone ~ Wind | factor(Month), data = airquality)
```

## Question 5
`trellis.par.set()` can be used to finely control the appearance of all lattice plots.

## Question 6
ggplot2 is an implementation of the Grammar of Graphics developed by Leland Wilkinson

## Question 7
```
airquality = transform(airquality, Month = factor(Month))
qplot(Wind, Ozone, data = airquality, facets = . ~ Month)
```
is a valid way to plot the relation between Ozone and wind speed separated by the month.

## Question 8
A geom in the ggplot2 system is a plotting object like point, line, or other shape

## Question 9
```
library(ggplot2)
g <- ggplot(movies, aes(votes, rating))
print(g)
```
returns an error because ggplot does not know what layers to draw.

## Question 10
To plot the average rating vs the number of votes, and then add smoothing, one can do this:
```
qplot(votes, rating, data = movies) + geom_smooth()
```
