library(sqldf)
library(lubridate)

if(!file.exists("./data")){dir.create("./data")}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile = "./data/raw_data.zip",method = "curl")

# list zip archive
file_names <- unzip("./data/raw_data.zip", list=TRUE)

# extract files from zip file
unzip("./data/raw_data.zip",exdir="./data", overwrite=TRUE)

# use when zip file has only one file
data_file <- file.path("./data", file_names$Name[1])

#----------#----------#----------#----------#----------

# Read data only for Feb. 1, 2007 & Feb. 2, 2007
df=read.csv.sql(data_file, "select * from file where Date in ('1/2/2007','2/2/2007')",header = TRUE,sep = ";")

# Replace missing values coded as "?" to NA
df[df == "?"] <- NA

# Remove incomplete observation
df=df[complete.cases(df), ]

# Combine Date & Time column as DateTime and store in POSIXct format
df$DateTime <-dmy_hms(paste(df$Date,df$Time))

# Remove Date and Time column
df <- df[ ,!(names(df) %in% c("Date","Time"))]

# Set new Graphic Device as PNG
png(filename="plot4.png", width=480, height=480)

# Multiple Plot
par(mfcol=c(2,2))

# First Plot:
    plot(df$Global_active_power~df$DateTime, type="l", ylab="Global Active Power (kilowatts)", xlab="")

# Second Plot:
    # Blank Plot 
    plot(df$Sub_metering_1~df$DateTime, type = "n", ylab="Energy sub metering", xlab="")

    # Sub metering 1
    points(df$Sub_metering_1~df$DateTime, type = "l", col= 'black')

    # Sub metering 2
    points(df$Sub_metering_2~df$DateTime, type = "l", col= 'red')

    # Sub metering 3
    points(df$Sub_metering_3~df$DateTime, type = "l", col= 'blue')

    # Legend
    legend("topright",col = c('black','red','blue'),lwd=c(1,1,1),bty = "n",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

# Third Plot:
    plot(df$Voltage ~ df$DateTime, type="l", ylab="Voltage", xlab="datetime")

# Forth Plot:
    plot(df$Global_reactive_power ~ df$DateTime, type="l", ylab="Global_reactive_power", xlab="datetime")

# Close Device
dev.off()   