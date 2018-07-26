library(ggplot2)
library(stringr)

renewable_table <- read.csv(file.choose(), header = T)
airplane_table <- read.csv(file.choose(),header = T)
## Excute after 

names(airplane_table) <- c("Time (Month)", "Airline", "AirlineCode", "Published airline",
                           "IATA code","Summary","Region","Activity","PriceCat","Terminal","Boarding_Area",
                           "Passengers")

domestic_flight <- subset(airplane_table, Summary == "Domestic")
international_flight <- subset(airplane_table, Summary != "Domestic" & Activity == "Enplaned" & Region == "Asia")
monthly_flight <- aggregate(international_flight$Passengers, 
                            by = list(category = international_flight$`Time (Month)`), sum)

names(monthly_flight) <-c("Date","Passengers")

year  <- (monthly_flight$Date %/% 100)
month <- str_sub(monthly_flight$Date,-2,-1)

monthly_flight <- cbind(monthly_flight,year,month)

ggplot(monthly_flight, aes(x = month, y = Passengers, color = factor(year), group = factor(year))) + 
  geom_line(data=subset(monthly_flight,year >= 2013))+
  labs(
    x = "Month",
    y = "Passengers",
    title ="Passengers to Asia by Month",
    color='Year'
  ) 

## Coming Back to the US

international_flight_return <- subset(airplane_table, Summary != "Domestic" & Activity == "Deplaned" & Region == "Asia")
monthly_flight_return <- aggregate(international_flight_return$Passengers, 
                            by = list(category = international_flight_return$`Time (Month)`), sum)
names(monthly_flight_return) <-c("Date","Passengers")
monthly_flight_return <- cbind(monthly_flight_return,year,month)

ggplot(monthly_flight_return, aes(x = month, y = Passengers, color = factor(year), group = factor(year))) + 
  geom_line(data=subset(monthly_flight_return,year >= 2013))+
  labs(
    x = "Month",
    y = "Passengers",
    title ="Passengers from Asia by Month",
    color='Year'
  ) + scale_y_continuous(breaks = seq(0, 300000, by=30000)) 


## Low fare airlines vs conventional 
domestic_flight_cheap <- subset(airplane_table, Summary == "Domestic" & Activity == "Enplaned" & PriceCat =="Low Fare")
domestic_flight_cheap <- aggregate(domestic_flight_cheap$Passengers, 
                            by = list(category = domestic_flight_cheap$`Time (Month)`), sum)
names(domestic_flight_cheap) <-c("Date","Passengers")

year  <- (domestic_flight_cheap$Date %/% 100)
month <- str_sub(domestic_flight_cheap$Date,-2,-1)
domestic_flight_cheap <- cbind(domestic_flight_cheap,year,month)

domestic_flight_cheap <- aggregate(domestic_flight_cheap$Passengers, 
                                   by = list(category = domestic_flight_cheap$year), sum)
ggplot(domestic_flight_cheap,aes(x=category,y=x)) +
  geom_bar(data=subset(domestic_flight_cheap, category < 2017),stat="identity")+
  labs(
    x= "Year",
    y ="Passengers",
    title = "Rise of Low Fare Airlines"
  )