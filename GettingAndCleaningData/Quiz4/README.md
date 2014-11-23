# Quiz 4

## Question 1

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

### Solution
We apply `strsplit` on the names of this data frame, and want to know the output in the 123rd row

```
> strsplit(names(q1.data), split = 'wgtp')[[123]]
[1] ""   "15"
```

## Question 2

### Get the data
```
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv', 'FGDP.csv', method = 'curl')
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv', 'FEDSTATS_Country.csv', method = 'curl')
```
Note, we won't need the FEDSTATS_Country data set until question 4.

### Load and analyze the data
```
gdp.df <- read.csv('FGDP.csv', skip=5, header = FALSE, stringsAsFactors = FALSE) %>%
  select(-V3, -(V6:V10)) %>%
  filter(V1 != '') %>%
  rename(CountryCode = V1, LongNames = V4, Rank = V2, GDP = V5) %>%
  mutate(Rank = as.numeric(Rank)) %>%
  filter(!is.na(Rank)) %>%
  mutate(GDP = as.numeric(gsub(',', '', GDP)))
stats.df <- read.csv('FEDSTATS_Country.csv', stringsAsFactors = FALSE)
```

### Solution
We want the average of the GDP column. Above, we removed the commas from the GDP column, and coerced the variables to numerics. To get the average, we do

```
> mean(gdp.df$GDP)
[1] 377652.4
```

## Question 3

For this question, we will use the same data set as before

### Solution
We want to count the number of countries whos name begins with "United". We do this using the following.

```
> countryNames <- gdp.df$LongNames
> NROW(grep('^United', countryNames))
[1] 3
```

## Question 4

Again, we use the same data as above

### Solution
First, we merge the two data frames based on the short names.
```
merge.df <- merge(gdp.df, stats.df)
```

Next, we check to see how many countries have a fiscal year that ends in June.

```
> sum(grepl('fiscal year end: June', merge.df$Special.Notes, ignore.case = TRUE))
[1] 13
```

## Question 5


