remote.file.url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for'
local.file.name <- 'Fwksst8110.for'
if (!file.exists(local.file.name)) {
  download.file(remote.file.url, local.file.name, method = 'curl')
}

data <- read.fwf(local.file.name, c(10, 9,4, 9,4, 9,4, 9,4), skip=4)
print(sum(data[,4]))