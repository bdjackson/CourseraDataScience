library(httr)
library(jsonlite)

# Get github credentials... I don't think this step is strictly necessary
oauth_endpoints("github")

# register my application
my.app <- oauth_app( 'CourseraDataScienceGettingAndCleaningDataQuiz2'
                   , '60f9ff4aaadc4b9af8d4'
                   , '9f5eb85df5a12a17e0956d4c244cbe15de32d0ec'
                   )

# get oauth token from github
github.token <- oauth2.0_token( oauth_endpoints("github")
                              , my.app
                              )
# need to configure the token
gtoken <- config(github.token)

# get the repo data from github
repo.data <- GET('https://api.github.com/users/jtleek/repos', gtoken)
repo.json <- jsonlite::fromJSON(toJSON(content(repo.data)))

# extract creation date for datasharing repo
datasharing.entry <- subset(repo.json, name == 'datasharing')
print(datasharing.entry['created_at'])
