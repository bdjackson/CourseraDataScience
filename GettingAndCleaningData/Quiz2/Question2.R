library(sqldf)
library(dplyr)

# download the data file:
data.url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
local.data.name <- 'pid.csv'
if (!file.exists(local.data.name)) {
  download.file(, local.file.name, method='curl')
}

# read the data file as a data.frame
acs <- read.csv(local.data.name)

# create a reference data frame using dplyr
ref.subset <- acs %>%
  filter(AGEP < 50) %>%
  select(pwgtp1)

# create test data frames using the sqldf package
test.1 <- sqldf("select pwgtp1 from acs where AGEP < 50")
test.2 <- sqldf("select * from acs where AGEP < 50 and pwgtp1")
test.3 <- sqldf("select pwgtp1 from acs")
test.4 <- sqldf("select * from acs where AGEP < 50")

# which of the test data frames match?
print(paste('test 1:', identical(ref.subset, test.1)))
print(paste('test 2:', identical(ref.subset, test.2)))
print(paste('test 3:', identical(ref.subset, test.3)))
print(paste('test 4:', identical(ref.subset, test.4)))
