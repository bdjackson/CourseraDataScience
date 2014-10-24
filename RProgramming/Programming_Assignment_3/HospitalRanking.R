# ------------------------------------------------------------------------------
# Function to read the input CSV file, and return a data frame of the outcome
ReadOutcomeFile <- function() {
        outcome <- read.csv( 'outcome-of-care-measures.csv'
                           , colClasses = 'character'
                           )
        outcome[, 11] <- as.numeric(outcome[, 11])
        outcome
}

# ------------------------------------------------------------------------------
# function to get the list of hospitals from hospital list file
ReadHospitalDataFile <- function() {
        hospital.data <- read.csv('hospital-data.csv', colClasses = 'character')
        hospital.data[,'State'] <- as.factor(hospital.data[,'State'])
        hospital.data
}

# ------------------------------------------------------------------------------
GetStateList <- function(hospital.df) {
        hospital.data <- ReadHospitalDataFile()
        levels(hospital.data$State)
}

# ------------------------------------------------------------------------------
# given a data frame and a state, get a list of the hospitals in this state
GetHospitalsInState <- function(hospital.df, state) {
        # get rows in df with state matching the target state
        hospital.df[hospital.df$State == state, ]
}

# ------------------------------------------------------------------------------
# Check that state is valid
CheckValidState <- function(state, state.list) {
        if (!(state %in% state.list)) {
                stop('invalid state')
        }
}

# ------------------------------------------------------------------------------
# check outcome is valid
CheckValidOutcome <- function(outcome) {
        valid.outcomes <- c('heart attack', 'heart failure', 'pneumonia')
        if (!(outcome %in% valid.outcomes)) {
                stop('invalid outcome')
        }
}

# ------------------------------------------------------------------------------
# function which will take a state and an outcome, and find the best hospital
# in that state for that outcome
best <- function(state, outcome) {
        rankhospital(state, outcome, 'best')
}

rankhospital <- function(state, outcome, num = 'best') {
        # Read outcome data
        # outcome <- ReadOutcomeFile()

        hospital.df <- ReadHospitalDataFile()
        state.list <- GetStateList(hospital.df)

        # Check that state and outcome are valid
        CheckValidState(state, state.list)
        CheckValidOutcome(outcome)

        # Get data for hospitals in this state
        hospitals.in.state <- GetHospitalsInState(hospital.df, state)

        if (num == 'best') {
                num <- 1
        }
        else if (num == 'worst') {
                num <- ncol(hospitals.in.state)
        }

        # rank hospitals
        # TODO do raking
        ranked.list <- hospitals.in.state[,2]

        # get hospital in position 'num'
        ranked.list[num]
}
