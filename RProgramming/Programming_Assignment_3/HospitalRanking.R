# Function to read the input CSV file, and return a data frame of the outcome
ReadOutcomeFile <- function() {
        outcome <- read.csv( 'outcome-of-care-measures.csv'
                           , colClasses = 'character'
                           )
        outcome[, 11] <- as.numeric(outcome[, 11])
        outcome
}

# function to get the list of hospitals from hospital list file
ReadHospitalDataFile <- function() {
        hospital.data <- read.csv('hospital-data.csv', colClasses = 'character')
        hospital.data[,'State'] <- as.factor(hospital.data[,'State'])
        hospital.data
}

GetStateList <- function(hospital.df) {
        hospital.data <- ReadHospitalDataFile()
        levels(hospital.data$State)
}

# function which will take a state and an outcome, and find the best hospital
# in that state for that outcome
best <- function(state, outcome) {
        ## Read outcome data
        # outcome <- ReadOutcomeFile()

        hospital.df <- ReadHospitalDataFile()
        state.list <- GetStateList(hospital.df)

        # Check that state and outcome are valid
        if (!(state %in% state.list)) {
                stop('invalid state')
        }
        valid.outcomes <- c('heart attack', 'heart failure', 'pneumonia')
        if (!(outcome %in% valid.outcomes)) {
                stop('invalid outcome')
        }

        ## Return hospital name in that state with lowest 30-day death rate
}
