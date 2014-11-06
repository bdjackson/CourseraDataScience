# Quiz 1

This README contains my solutions for quiz 1

## Question 1

### Getting the data and code book
```
wget https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
```

We want to get the number of homes worth over $1M. We can do this by filtering the data frame, and counting the rows. The column which gives the home value is 'VAL,' and the level corresponding to >= 1M is 24
```
# First, read the data frame
library('dplyr')
df <- read.csv('getdata%2Fdata%2Fss06hid.csv')
df <- tbl_df(df)

# Now, filter and count
> nrow(filter(df, VAL == 24))
[1] 53
```

## Question 2
The column 'FES' violates the tidy coding standards because it contains multiple variables in a single column.

## Question 3

### Geting the data
```
wget https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
```
### Solution
We want to read in a table from this xlsx file, and compute the sum of a complicated expression. First, we read in the relevant table
```
library(xlsx)
dat <- read.xlsx('getdata%2Fdata%2FDATA.gov_NGAP.xlsx', sheetIndex=1, startRow=18, endRow=23, colIndex=7:15)
```
And, then we find the sum.
```
> sum(dat$Zip*dat$Ext,na.rm=T) 
[1] 36534720
```

## Question 4
We want to count the nubmer of restaraunts in a certain zip code using he Baltimore restaraunt database

```
fileurl <- 'http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml'
doc <- xmlTreeParse(fileurl)
rootNode <- xmlRoot(doc)
```

We can get a vector of the zip codes, and count the number with zip code 21231
```
> zip.code.vec <- xpathSApply(rootNode, '//zipcode', xmlValue)
> NROW(zip.code.vec[zip.code.vec == '21231'])
[1] 127
```

## Question 5

### Get the data
```
> download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv', destfile='Fss06pid.csv', method='curl')
```

## Solution
Read the data using `fread()`
```
library(data.table)
DT <- fread('Fss06pid.csv', sep = ',', header = TRUE)
```

We want to determine which method of calculating the mean of values in a column is the fastest.
First, we check which method actualy works:
```
> mean(DT$pwgtp15,by=DT$SEX)
[1] 98.21613
> DT[,mean(pwgtp15),by=SEX]
   SEX       V1
1:   1 99.80667
2:   2 96.66534
> rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
Error in rowMeans(DT) : 'x' must be numeric
> sapply(split(DT$pwgtp15,DT$SEX),mean)
       1        2 
99.80667 96.66534 
> mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
[1] 99.80667
[1] 96.66534
> tapply(DT$pwgtp15,DT$SEX,mean)
       1        2 
99.80667 96.66534 
```

We can eliminate methods 1 and 3
```
> system.time( DT[,mean(pwgtp15),by=SEX] )
   user  system elapsed 
  0.002   0.000   0.002 
> system.time( sapply(split(DT$pwgtp15,DT$SEX),mean) )
   user  system elapsed 
  0.002   0.000   0.002 
> system.time( { mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15) } )
   user  system elapsed 
  0.058   0.003   0.060 
> system.time( tapply(DT$pwgtp15,DT$SEX,mean) )
   user  system elapsed 
  0.002   0.000   0.002 
```

Some of these are very close. What if we try running 10k times to get a better estimate.
```
> system.time( for (i in 1:10000) { DT[,mean(pwgtp15),by=SEX] } )
   user  system elapsed 
 14.311   0.165  14.609 
> system.time( for (i in 1:10000) { sapply(split(DT$pwgtp15,DT$SEX),mean) } )
   user  system elapsed 
 12.076   1.393  13.568 
> system.time( for (i in 1:10000) { tapply(DT$pwgtp15,DT$SEX,mean) } )
   user  system elapsed 
 21.845   2.821  24.876 
```

This means the `sapply` method is the fastest.