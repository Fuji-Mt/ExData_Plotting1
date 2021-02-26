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
  
  #Set 2*2 layout
  par(mfrow = c(2, 2))
  
  #plot "plot2" @ [1, 1]
  with(data_2day,
     plot(Date_Time, Global_active_power, 
          type = "l", 
          xlab = "", 
          ylab = "Global Active Power (kilowatts)"))
  
  #plot "Voltage" @ [1, 2]
  with(data_2day,
       plot(Date_Time, Voltage, 
            type = "l", 
            xlab = "datetime", 
            ylab = "Voltage"))
  
  #plot "plot3" @ [2, 1]
  with(data_2day,
       plot(Date_Time, Sub_metering_1, 
            type = "l", 
            xlab = "", 
            ylab = "Energy sub metering"))
  
  with(data_2day,
       points(Date_Time, Sub_metering_2, 
              type = "l", 
              xlab = "", 
              ylab = "Energy sub metering", 
              col = "red"))
  
  with(data_2day,
       points(Date_Time, Sub_metering_3, 
              type = "l", 
              xlab = "", 
              ylab = "Energy sub metering", 
              col = "blue"))
  
  legend("topright", 
         lwd = 1,
         col = c("black", "red", "blue"), 
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
         bty = "n")
  
  #plot "Global_reactive_power" @ [2, 2]
  with(data_2day,
       plot(Date_Time, Global_reactive_power, 
            type = "l", 
            xlab = "datetime", 
            ylab = "Global_reactive_power"))
  
  #Save png file
  dev.copy(png, file = "plot4.png", width = 480, height = 480, units = "px")
  dev.off()
  
  
  