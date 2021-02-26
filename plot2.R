## Loading the data

  filename <- "exdata_data_household_power_consumption.zip"
  
  #checking zip file exists or not.
  if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, filename)
  }  
  
  #checking zip file is upzip or not
  if (!file.exists("exdata_data_household_power_consumption.txt")) { 
    unzip(filename) 
  }

## Reading the data
  #Read original data  
  data <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, colClasses = "character")
  
  #Change class from character to numeric
  data[, 3] <- as.numeric(data[, 3])
  data[, 4] <- as.numeric(data[, 4])
  data[, 5] <- as.numeric(data[, 5])
  data[, 6] <- as.numeric(data[, 6])
  data[, 7] <- as.numeric(data[, 7])
  data[, 8] <- as.numeric(data[, 8])
  data[, 9] <- as.numeric(data[, 9])
  
  #change into dplyr format
  library(dplyr)
  data <- tbl_df(data)
  
  #Prepare the variable which include date and time at once
  data_add <- mutate(data, Date_Time = paste(data$Date, data$Time, sep = "_"))
  data_add$Date_Time <- as.POSIXct(strptime(data_add$Date_Time, "%d/%m/%Y_%H:%M:%S"))
  
  #Extract the data during 2007-02-01 and 2007-02-02
  two_day <- data_add$Date == "1/2/2007" | data_add$Date == "2/2/2007"
  data_2day <- data_add[two_day, ]

## Plotting
  #Set the language on system to English
  Sys.setlocale("LC_ALL","English")
  
  #Plot scatter plot
  with(data_2day,
       plot(data_2day$Date_Time, data_2day$Global_active_power, 
            type = "l", 
            xlab = "", 
            ylab = "Global Active Power (kilowatts)"))
  
  #Save png file
  dev.copy(png, file = "plot2.png", width = 480, height = 480, units = "px")
  dev.off()