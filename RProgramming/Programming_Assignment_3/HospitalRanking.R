# ------------------------------------------------------------------------------
# Function to read the input CSV file, and return a data frame of the outcome
ReadOutcomeFile <- function() {
        outcome <- read.csv( 'outcome-of-care-measures.csv'
                           , colClasses = 'character'
                           )

        # cast columns 11,17,23 as numeric. These are:
        #   11: Hospital 30-Day Death (Mortality) Rates from Heart Attack
        #   17: Hospital 30-Day Death (Mortality) Rates from Heart Failure
        #   23: Hospital 30-Day Death (Mortality) Rates from Pneumonia
        outcome[, 11] <- as.numeric(outcome[, 11])
        outcome[, 17] <- as.numeric(outcome[, 17])
        outcome[, 23] <- as.numeric(outcome[, 23])
        outcome
}

# ------------------------------------------------------------------------------
PruneUnneededInfoFromOutcomeDataFrame <- function(full.data.frame) {
        pruned.data.frame <- full.data.frame[ , c( 2  # Hospital Name
                                                 , 7  # State
                                                 , 11 # Hospital 30-Day Death (Mortality) Rates from Heart Attack
                                                 , 17 # Hospital 30-Day Death (Mortality) Rates from Heart Failure
                                                 , 23 # Hospital 30-Day Death (Mortality) Rates from Pneumonia
                                                 )
                                            ]

        # print(names(pruned.data.frame))
        names(pruned.data.frame) <- c( 'name'
                                     , 'state'
                                     , 'heart attack'
                                     , 'heart failure'
                                     , 'pneumonia'
                                     )
        # print(names(pruned.data.frame))

        pruned.data.frame
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

# ------------------------------------------------------------------------------
rankhospital <- function(state, outcome, num = 'best') {
        # Read outcome data
        hospital.data <- ReadOutcomeFile()
        hospital.data <- PruneUnneededInfoFromOutcomeDataFrame(hospital.data)

        hospital.df <- ReadHospitalDataFile()
        state.list <- GetStateList(hospital.df)

        # Check that state and outcome are valid
        CheckValidState(state, state.list)
        CheckValidOutcome(outcome)

        # get hospital data in this state only
        hospital.data.in.state <- hospital.data[hospital.data$state == state,]

        num <- InterpretPosition(num, hospital.data.in.state)
        if (is.na(num)) {
                return(NA)
        }

        ranked.list <- RankHospitalsByOutcome(hospital.data.in.state, outcome)

        # print('ranked list:')
        # print(ranked.list)

        # get hospital in position 'num'
        ranked.list[[num,'name']]
}

# ------------------------------------------------------------------------------
RankHospitalsByOutcome <- function(hospital.df, outcome) {
        # prune na results for the target outcome
        hospital.df <- hospital.df[!is.na(hospital.df[,outcome]), ]

        # First order by name, then by outcome
        hospital.df <- hospital.df[order(hospital.df[,'name']), ]
        ranked.list <- hospital.df[order(hospital.df[,outcome]), ]
}

# ------------------------------------------------------------------------------
InterpretPosition <- function(num, hospital.df) {
        if (num == 'best') {
                num <- 1
        }
        else if (num == 'worst') {
                num <- ncol(hospital.df)
                # num <- NCOL(hospitals.in.state)
        }
        else if (num > ncol(hospital.df)) {
                num <- NA
        }

        num
}
