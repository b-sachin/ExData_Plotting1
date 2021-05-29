library(sqldf)

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

# Set new Graphic Device as PNG
png(filename="plot1.png", width=480, height=480)

# Histogram
hist(df$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")

# Close Device
dev.off()