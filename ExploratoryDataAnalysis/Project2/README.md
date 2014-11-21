# Project 2


## Description of the data

- fips: A five-digit number (represented as a string) indicating the U.S. county
- SCC: The name of the source as indicated by a digit string (see source code classification table)
- Pollutant: A string indicating the pollutant
- Emissions: Amount of PM2.5 emitted, in tons
- type: The type of source (point, non-point, on-road, or non-road)
- year: The year of emissions recorded

## Read in the data

```
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```

## Questions

### Question 1
Have total emissions from PM2.5 decreased in the United States from 1999 to
2008? Using the base plotting system, make a plot showing the total PM2.5
emission from all sources for each of the years 1999, 2002, 2005, and 2008.

This can be done by grouping the NEI data by
- Grouping NEI data by year
- Use the `summarise` function to compute the sum of the emissions for each year (group)
- Plot the output of this `summarise` call

![plot 1](plot1.png)

TODO add summary of result

### Question 2
Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
(fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot
answering this question.

This is very similar to question 1.

This can be done by grouping the NEI data by
- Filtering the NEI data set, selecting only Baltimore City, MD
- Grouping by year
- Use the `summarise` function to compute the sum of the emissions for each year (group)
- Plot the output of this `summarise` call

![plot 2](plot2.png)

TODO add summary of result

### Question 3
Of the four types of sources indicated by the type (point, nonpoint, onroad,
nonroad) variable, which of these four sources have seen decreases in emissions
from 1999–2008 for Baltimore City? Which have seen increases in emissions from
1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

### Question 4
Across the United States, how have emissions from coal combustion-related
sources changed from 1999–2008?

### Question 5
How have emissions from motor vehicle sources changed from 1999–2008 in
Baltimore City?

### Question 6
Compare emissions from motor vehicle sources in Baltimore City with emissions
from motor vehicle sources in Los Angeles County, California (fips == "06037").
Which city has seen greater changes over time in motor vehicle emissions?


