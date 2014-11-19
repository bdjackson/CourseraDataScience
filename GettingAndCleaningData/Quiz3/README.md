# Quiz 3

## Question 1

Here we want to download a dataset, and filter it according to certain qualities.

### Get the data
First, download the data file and the code book

```
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv', 'Fss06hid.csv', method = 'curl')
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf', 'FPUMSDataDict06.pdf', method = 'curl')
```

We then load the data into R
```
q1.data <- read.csv('Fss06hid.csv')
```

### Process the data

Now, we want to filter the households on greater than 10 acres who sold more than $10,000 worth of agriculture products. The rows corresponding to these requirements are:
```
> which(q1.data[, 'ACR'] == 3 & q1.data[,'AGS'] == 6)
 [1]  125  238  262  470  555  568  608  643  787  808  824  849  952  955 1033 1265 1275 1315 1388 1607
[21] 1629 1651 1856 1919 2101 2194 2403 2443 2539 2580 2655 2680 2740 2838 2965 3131 3133 3163 3291 3370
[41] 3402 3585 3652 3852 3862 3912 4023 4045 4107 4113 4117 4185 4198 4310 4343 4354 4448 4453 4461 4718
[61] 4817 4835 4910 5140 5199 5236 5326 5417 5531 5574 5894 6033 6044 6089 6275 6376 6420
```
The problem asks for the first three entries whcih are `125  238  262`

## Question 2

For this problem, we want to analyze a photograph

## Get the data

```
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg', 'jeff.jpg', method = 'curl')
```

## Analyze the data
We are going to read in the image file, and find its quantiles
```
q2.data <- readJPEG('jeff.jpg', native = TRUE)
```
Now, we have the image loaded into R, we can get the quantiles
```
> quantile(q2.data, c(0.30, 0.80))
      30%       80% 
-15259150 -10575416 
```

## Question 3

For this question, we want to rank countries by their GDP

### Get the data
```
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv', 'FGDP.csv', method = 'curl')
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv', 'FEDSTATS_Country.csv', method = 'curl')
```

### Load and analyze the data
```
gdp.df <- read.csv('FGDP.csv', skip=5, header = FALSE, stringsAsFactors = FALSE) %>%
  select(-(V3:V4), -(V6:V10)) %>%
  filter(V1 != '') %>%
  rename(CountryCode = V1, Rank = V2, GDP = V5) %>%
  mutate(Rank = as.numeric(Rank)) %>%
  filter(!is.na(Rank)) %>%
  mutate(GDP = as.numeric(gsub(',', '', GDP)))
stats.df <- read.csv('FEDSTATS_Country.csv', stringsAsFactors = FALSE)
```

Now, merge the data frames
```
merge.df <- merge(gdp.df, stats.df)
```
When we do this, there are 189 rows in the resultind merged data frame

Finally, we want to sort in descending order by rank
```
head(arrange(merge.df, desc(Rank)), 20)
```
The 13th entry is St. Kitts and Nevis

## Question 4

For this problem, we are going to use the same data set. We want to determine the average GDP ranking for the "High income: OECD" and "High income: nonOECD" groups.

```
> country.data.melt <- melt(merge.df, id = c('CountryCode', 'Income.Group'), measure.vars = 'Rank')
> dcast(country.data.melt, Income.Group ~ variable, mean)
          Income.Group      Rank
1 High income: nonOECD  91.91304
2    High income: OECD  32.96667
3           Low income 133.72973
4  Lower middle income 107.70370
5  Upper middle income  92.13333
```

## Question 5

For the final question, we are to cut up the previous data set based on the GDP and income group. We awnt to know how many countries are in the lower middle income, but within the 38 nations with the highest GDP.

First, let's make a skimmed data frame, and add the rank group to the end
```
skimmed.country.df <- select(merge.df, CountryCode:Income.Group)
skimmed.country.df$RankGroup <- cut(skimmed.country.df$Rank,
                                    breaks = quantile(skimmed.country.df$Rank, probs = seq(0,1,0.2)),
                                    include.lowest = TRUE)
```

And, we draw a table showing the income group and the GDP rank group
```
> table(skimmed.country.df$RankGroup, skimmed.country.df$Income.Group)
             
              High income: nonOECD High income: OECD Low income Lower middle income Upper middle income
  [1,38.6]                       4                18          0                   5                  11
  (38.6,76.2]                    5                10          1                  13                   9
  (76.2,114]                     8                 1          9                  11                   8
  (114,152]                      4                 1         16                   9                   8
  (152,190]                      2                 0         11                  16                   9
```
There are 5 countries in the lower middle income bracket, but among the 38 countries with the highest GDP.
