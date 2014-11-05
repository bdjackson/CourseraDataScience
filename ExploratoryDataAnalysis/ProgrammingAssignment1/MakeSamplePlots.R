# This is a script to clean the power consumption data file. Since, the dataset
# is huge, and we likely don't want to run over the full data set every time,
# we can strip out only certain dates. 
# ==============================================================================

# Some default file names in case the use doesn't want to supply these
default.full.file.name <- 'household_power_consumption.txt'
default.binary.file.name <- 'household_power_consumption.skim.rds'

# ------------------------------------------------------------------------------
# function to read file, and convert columns to correct format
ReadDataFile <- function(in.file.name = default.full.file.name) {
        df <- read.table( in.file.name
                        , header = TRUE
                        , sep = ';'
                        , na.strings = c('?', 'NA')
                        , colClasses = 'character'
                        , quote = ''
                        )
              

        # coerce columns into the correct data formats
        df <- mutate(df, Time = paste(Date,Time, sep='-'))
        df <- mutate(df, Date = as.POSIXct(Date, format='%d/%m/%Y'))
        df <- mutate(df, Time = as.POSIXct(Time, format='%d/%m/%Y-%H:%M:%S'))

        col.names = names(df)
        for (this.col.name in col.names[3:NROW(col.names)]) {
                suppressWarnings(
                        df[,this.col.name] <- as.numeric(df[,this.col.name]) )
        }

        # Return data frame
        tbl_df(df)
}

# ------------------------------------------------------------------------------
# function to read input file, call the trimming functions and 
CreateSubsetFile <- function( in.file.name = default.full.file.name
                            , out.file.name = default.binary.file.name
                            ) {
        df <- ReadDataFile(in.file.name)

        # select the rows we want to keep
        date.min=as.POSIXct('2007-02-01')
        date.max=as.POSIXct('2007-02-02')
        df <- filter(df, Date >= date.min, Date <= date.max)

        # write to RDS file
        saveRDS(df, file = out.file.name)
}

# ------------------------------------------------------------------------------
# function to retreive data frame from cached file
LoadDataFrame <- function(in.file.name = default.binary.file.name) {
        if (!file.exists(in.file.name)) {
                print("The chached data frame file does not exist")
                print("I will try reading the default input file to create it.")
                CreateSubsetFile(out.file.name = in.file.name)
        }
        readRDS(in.file.name)
}

# ------------------------------------------------------------------------------
CreatePlot1 <- function(in.file.name = default.binary.file.name) {
        # load cached data frame
        df <- LoadDataFrame(in.file.name)

        # open png device
        png(file = 'plot1.png', bg = 'transparent')

        # Draw histogram
        with( df, hist( Global_active_power
                      , col = 'red'
                      , main = 'Global Active Power'
                      , xlab = 'Global Active Power (kilowatts)'
                      , ylab = 'Frequency'
                      )
            )

        # close device
        dev.off()
}

# ------------------------------------------------------------------------------
CreatePlot2 <- function(in.file.name = default.binary.file.name) {
        # load cached data frame
        df <- LoadDataFrame(in.file.name)

        # open png device
        png(file = 'plot2.png', bg = 'transparent')

        # Draw histogram
        with( df, plot( Global_active_power ~ Time
                      , xlab = ''
                      , ylab = 'Global Active Power (kilowatts)'
                      , type = 'l'
                      )
            )

        # close device
        dev.off()
}

# ------------------------------------------------------------------------------
CreatePlot3 <- function(in.file.name = default.binary.file.name) {
        # load cached data frame
        df <- LoadDataFrame(in.file.name)

        # open png device
        png(file = 'plot3.png', bg = 'transparent')

        # Draw histogram
        with( df, plot( Sub_metering_1 ~ Time
                       , xlab = ''
                       , ylab = 'Energy sub metering'
                       , type = 'n'
                       )
            )
        with( df, points( Sub_metering_1 ~ Time
                        , type = 'l'
                        , col = 'black'
                        )
            )
        with( df, points( Sub_metering_2 ~ Time
                        , type = 'l'
                        , col = 'red'
                        )
            )
        with( df, points( Sub_metering_3 ~ Time
                        , type = 'l'
                        , col = 'blue'
                        )
            )

        legend( 'topright'
              , col = c('black', 'red', 'blue')
              , legend = paste('Sub_metering_', 1:3)
              , lwd = 1
              )

        # close device
        dev.off()
}

# ------------------------------------------------------------------------------
CreatePlot4 <- function(in.file.name = default.binary.file.name) {
        # load cached data frame
        df <- LoadDataFrame(in.file.name)

        # open png device
        png(file = 'plot4.png', bg = 'transparent')

        # set up 2x2 frame
        par(mfrow = c(2,2))

        # Draw histogram 1
        with( df, plot( Global_active_power ~ Time
                      , xlab = ''
                      , ylab = 'Global Active Power'
                      , type = 'l'
                      )
            )

        # Draw histogram 2
        with( df, plot( Voltage ~ Time
                      , xlab = 'datetime'
                      , ylab = 'Voltage'
                      , type = 'l'
                      )
            )

        # Draw histogram 3
        with( df, plot( Sub_metering_1 ~ Time
                       , xlab = ''
                       , ylab = 'Energy sub metering'
                       , type = 'n'
                       )
            )
        with( df, points( Sub_metering_1 ~ Time
                        , type = 'l'
                        , col = 'black'
                        )
            )
        with( df, points( Sub_metering_2 ~ Time
                        , type = 'l'
                        , col = 'red'
                        )
            )
        with( df, points( Sub_metering_3 ~ Time
                        , type = 'l'
                        , col = 'blue'
                        )
            )

        legend( 'topright'
              , col = c('black', 'red', 'blue')
              , legend = paste('Sub_metering_', 1:3)
              , lwd = 1
              , box.lwd = 0
              )

        # Draw histogram 4
        with( df, plot( Global_reactive_power ~ Time
                      , xlab = 'datetime'
                      , ylab = 'Global_reactive_power'
                      , type = 'l'
                      )
            )

        # close device
        dev.off()
}
