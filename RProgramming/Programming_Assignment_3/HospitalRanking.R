# This file contains functions which implement the solution to the programming
# assignment 3 in the coursera R programming course. The goal of this assignment
# is to read in hospital data, and rank hospitals based on their mortality rate
# for pneumonia, heart attacks, or heart failure
# ------------------------------------------------------------------------------

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
        outcome[,'State'] <- as.factor(outcome[,'State'])
        outcome[, 11] <- suppressWarnings(as.numeric(outcome[, 11]))
        outcome[, 17] <- suppressWarnings(as.numeric(outcome[, 17]))
        outcome[, 23] <- suppressWarnings(as.numeric(outcome[, 23]))

        # drop all the columns we don't need
        pruned.data.frame <- outcome[ , c( 2  # Hospital Name
                                         , 7  # State
                                         , 11 # Hospital 30-Day Death (Mortality) Rates from Heart Attack
                                         , 17 # Hospital 30-Day Death (Mortality) Rates from Heart Failure
                                         , 23 # Hospital 30-Day Death (Mortality) Rates from Pneumonia
                                         )
                                    ]

        names(pruned.data.frame) <- c( 'name'
                                     , 'state'
                                     , 'heart attack'
                                     , 'heart failure'
                                     , 'pneumonia'
                                     )
        pruned.data.frame
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
InterpretPosition <- function(num, hospital.df) {
        if (num == 'best') {
                num <- 1
        }
        else if (num == 'worst') {
                num <- nrow(hospital.df)
        }
        else if (num > nrow(hospital.df)) {
                num <- NA
        }

        num
}

# ------------------------------------------------------------------------------
RankHospitalsByOutcome <- function(hospital.df, outcome) {
        # prune na results for the target outcome
        hospital.df <- hospital.df[!is.na(hospital.df[,outcome]), ]

        # First order by name, then by outcome
        hospital.df <- hospital.df[order(hospital.df[,'name']), ]
        hospital.df[order(hospital.df[,outcome]), ]
}

# ------------------------------------------------------------------------------
# given a state and outcome, give the hospital which is ranked at positon <num>
RankHospital <- function(state, outcome, num = 'best') {
        # Read outcome data
        hospital.data <- ReadOutcomeFile()

        # get the list of states
        state.list <- levels(hospital.data$state)

        # Check that state and outcome are valid
        CheckValidState(state, state.list)
        CheckValidOutcome(outcome)

        # get hospital data in this state only
        hospital.data.in.state <- hospital.data[hospital.data$state == state,]

        # rank hospitals
        ranked.list <- RankHospitalsByOutcome(hospital.data.in.state, outcome)

        # is this position valid?
        num <- InterpretPosition(num, ranked.list)
        if (is.na(num)) {
                return(NA)
        }

        ranked.list[[num,'name']]
}

# ------------------------------------------------------------------------------
RankAll <- function(outcome, num='best') {
        # Read outcome data
        hospital.data <- ReadOutcomeFile()

        # get the list of states
        state.list <- levels(hospital.data$state)

        # Check that state and outcome are valid
        CheckValidOutcome(outcome)

        # function which will rank the hospitals within a given state
        RankHospitalInState <- function(state) {
                # get hospital data in this state only
                hospital.data.in.state <-
                        hospital.data[hospital.data$state == state,]

                # do ranking
                ranked.list <-
                        RankHospitalsByOutcome(hospital.data.in.state, outcome)

                # get hospital in position 'num'
                this.num <- InterpretPosition(num, ranked.list)
                if (is.na(this.num)) {
                        return('<NA>')
                }
                ranked.list[[this.num,'name']]
        }

        hospital.rankings <- vapply( state.list
                                   , RankHospitalInState
                                   , FUN.VALUE='a'
                                   )

        data.frame(hospital=hospital.rankings, state=state.list)
}

# ------------------------------------------------------------------------------
# function which will take a state and an outcome, and find the best hospital
# in that state for that outcome -- this is here for the grading script
best <- function(state, outcome) {
        rankhospital(state, outcome, 'best')
}

# ------------------------------------------------------------------------------
# Alias to RankHospital function to align with the assignment naming
rankhospital <- function(state, outcome, num = 'best') {
        RankHospital(state, outcome, num)
}

# ------------------------------------------------------------------------------
# Alias to RankAll function to align with the assignment naming
rankall <- function(outcome, num = 'best') {
        RankAll(outcome, num)
}

