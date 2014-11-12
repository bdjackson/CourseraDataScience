library(sqldf)

# download the data file:
data.url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
local.data.name <- 'pid.csv'
if (!file.exists(local.data.name)) {
  download.file(, local.file.name, method='curl')
}

# read the data file as a data.frame
acs <- read.csv(local.data.name)

# create a reference vector
ref.subset <- unique(acs$AGEP)

# create test vectors frames using the sqldf package
# test.1 <- sqldf("select AGEP where unique from acs")
test.2 <- sqldf("select distinct AGEP from acs")
# test.3 <- sqldf("select unique AGEP from acs")
# test.4 <- sqldf("select unique * from acs")

# test 1,3,4 don't work at all. set these to false
test.1 <- F
test.3 <- F
test.4 <- F

# which of the test data frames match?
print(paste('test 1:', identical(ref.subset, test.1)))
print(paste('test 2:', identical(ref.subset, as.vector(unlist(test.2)))))
print(paste('test 3:', identical(ref.subset, test.3)))
print(paste('test 4:', identical(ref.subset, test.4)))
