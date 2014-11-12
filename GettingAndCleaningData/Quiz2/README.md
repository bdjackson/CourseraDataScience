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
