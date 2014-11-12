# Quiz 2

This README contains my solutions for quiz 2

## Question 1

### First creat an application with the github api
https://github.com/settings/applications

I named my application `CourseraDataScienceGettingAndCleaningDataQuiz2`

### Solution
Using the github api, I extracted the json file for jtleek's repo descriptions, then using the json package, extracted the creation date for the datasharing repo.

Answer: 2013-11-07T13:25:07Z

## Question 2
Using the sqldf package, one can take subsets of a data.frame using SQL query commands. 
For our test data.frame, the command to collect the weights for all entries where the age is less than 50 is:
```
sqldf("select pwgtp1 from acs where AGEP < 50")
```

## Question 3
Correct way to count the number of unique entries in the AGEP column of acs using the sqldf package is
```
sqldf("select distinct AGEP from acs")
```

## Question 4
Need to count the number of characters in several lines of a web page (http://biostat.jhsph.edu/~jleek/contact.html).
I loaded the html code into a vector of strings, and use the following commands to extract the number of characters:
```
nchar(html.code[10])
nchar(html.code[20])
nchar(html.code[30])
nchar(html.code[100])
```
Answer: 45 31 7 25

## Question 5
We need to read a fixed width file and find the sum of one of the columns. The tricky part here is to read in the fixed width file. That is done using the following snippet
```
data <- read.fwf(local.file.name, c(10, 9,4, 9,4, 9,4, 9,4), skip=4)
```

Answer: 32426.7
