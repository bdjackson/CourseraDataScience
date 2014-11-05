Programming Assignment 1
========================

Problem description
-------------------
[Problem description](https://class.coursera.org/exdata-008/human_grading/view/courses/972597/assessments/3/submissions)

Get the data
------------
To get the data for this assignment, use the following commands
```
wget https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
unzip exdata%2Fdata%2Fhousehold_power_consumption.zip
```

Getting set up
--------------
For this assignment, we will need to fork a repo from the course and clone it
here.
- [course repo](https://github.com/rdpeng/ExData_Plotting1)
- [My fork of the repo](https://github.com/bdjackson/ExData_Plotting1)
Clone the repo here:
```
git clone git@github.com:bdjackson/ExData_Plotting1.git
```

## Structure of the solution
For this assignment, I created a single file `MakeSamplePlots.R` which includes helper functions to read/skim the dataset, as well as create all of our plots.
As the assignment requested, I also created files named `plot1.R`, etc. These files simply call functions from the `MakeSamplePlots.R` file.

