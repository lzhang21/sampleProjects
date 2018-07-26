#PRECIPtable, TEMPTable, ClimTable 

PRECIPTable <- read.csv(file.choose(), header = TRUE)
NDVItable <- read.csv(file.choose(), header = TRUE)


attach(NDVItable)
attach(TEMPTable)
attach(PRECIPTable)
library(zoo)


#Average Annual Temperature 1910 - 2015 
mov.avg <- rollmean(YEAR, 5, fill=NA)

par(mfrow = c(1,2))
plot(YEAR, Annual.Mean, col = "blue", pch = "x", main = "Average Annual Temperature \n 1910 - 2015", xlab = "Mean Temperature:",
     ylab = "Average Temperature (C)", cex = 0.5, axes = F, sub = mean(Annual.Mean))

abline(lm(YEAR~ Annual.Mean), lwd = 5 , col = 5, untf = TRUE)
axis(side = 1, at = c(1910,1930,1950,1970,1990,2010),labels = c("1910", "1930","1950", "1970", "1990","2010"))
axis(side = 2, at = c())
box()
##lines(YEAR, mov.avg, col="orange", lwd=2)
lines(smooth.spline(YEAR, Annual.Mean), lty = 1, col = "red")


text(x=1900, y = 3.1, label = "Source: UEA CRUdata", cex =0.75, adj = 0)
mtext('Year        ', side=1, line=-3, adj=T, outer=TRUE, cex = 0.8)

##Linear regression 
fit <- lm(Annual.Mean ~ YEAR)
summary(fit)


#Precip trends 

ClimTable <-cbind(TEMPTable, PRECIPTable)
plot(YEAR, Annual.Ptotal, col = "blue", pch = "x", main = "Average Annual Precipitation \n 1910 - 2015", xlab = "Total Annual Precipitation:",
     ylab = "Total Precipitation (mm)", cex = 0.5, axes = F, sub = mean(Annual.Ptotal))
axis(side = 1, at = c(1910,1930,1950,1970,1990,2010),labels = c("1910", "1930","1950", "1970", "1990","2010"))
axis(side = 2, at = c())
box()

lines(smooth.spline(YEAR, Annual.Ptotal), lty = 1, col = "green")
text(x=1900, y = 550, label = "Source: UEA CRUdata", cex =0.75, adj = 0)
mtext('Year        ', side=1, line=-3, adj=T, outer=TRUE, cex = 0.8)

fit <- lm(Annual.Ptotal ~ YEAR)
summary(fit)

#Temperature trends by 25 year period 
par(mfrow = c(2,2))
boxplot(Annual.Mean[YEAR >= 1910 & YEAR < 1935], main = "Average Annual Temperture 1910 - 1934", xlab = "Mean Temp (C) = "
        , sub =mean(Annual.Mean[YEAR > 1910 & YEAR < 1934]), ylim =c(-0.5, 3), cex.main = 0.75 )
boxplot(Annual.Mean[YEAR >= 1935 & YEAR < 1959], main = "Average Annual Temperture 1935 - 1959", xlab = "Mean Temp (C) = "
        , sub =mean(Annual.Mean[YEAR >=1935 & YEAR < 1959]), ylim =c(-0.5, 3), cex.main = 0.75  )

#par(mfrow = c(1,2))
boxplot(Annual.Mean[YEAR >= 1960 & YEAR < 1984], main = "Average Annual Temperture 1960 - 1984", xlab = "Mean Temp (C) = "
        , sub =mean(Annual.Mean[YEAR > 1960 & YEAR < 1984]), ylim =c(-0.5, 3.5), cex.main = 0.75   )
boxplot(Annual.Mean[YEAR >= 1985 & YEAR < 2015], main = "Average Annual Temperture 1985 - 2015", xlab = "Mean Temp (C) = "
        , sub =mean(Annual.Mean[YEAR > 1985 & YEAR < 2015]), ylim =c(-0.5, 3.5), cex.main = 0.75  )



#Climate vs SMAP data 

JANmean <- mean(Jan)
FEBmean <- mean(Feb)
MARmean <- mean(Mar)
APRmean <- mean(Apr)
MAYmean <- mean(May)
JUNmean <- mean(Jun)
JULmean <- mean(Jul)
AUGmean <- mean(Aug)
SEPmean <- mean(Sep)
OCTmean <- mean(Oct)
NOVmean <- mean(Nov)
DECmean <- mean(Dec)

par(mfrow = c(1,1))



PrecipMean <- c(JANmean, FEBmean, MARmean,APRmean,
              MAYmean,JUNmean,JULmean,AUGmean,SEPmean,OCTmean,NOVmean,DECmean)
MonthArr <- c(1,2,3,4,5,6,7,8,9,10,11,12)
SMAPArr <-c(0.4772085,0.5052973,0.5410151,0.5196837,0.6130430,0.5119484,0.5079254,0.4318039,0.3914687,
            0.3972411,0.4028105, 0.4683910)

df <- data.frame(MonthArr,TempMean)
names(df) <- c("Month","Value (mm)")



plot(MonthArr,PrecipMean, pch = "x", col = "red", xlab = "Month", ylab = "Monthly Precipitation (mm)", axes = F,
     main = "Monthly Average Precipitation vs Soil Moisture")
axis(side = 1, at = c(3,6,9,12),labels = c("March", "June","September", "December"))
axis(side = 2, at = c())
box()
#lines(smooth.spline(MonthArr, PrecipMean), lty = 1, col = "red")
lines(MonthArr, PrecipMean, lwd = 2, col = 2)



par(new = TRUE)
plot(MonthArr, SMAPArr , ylab = " ",xlab = " ", col = "blue" , axes = FALSE, pch = 7)
axis(side=4, at = pretty(range(Value)))
lines(smooth.spline(MonthArr, SMAPArr), col = "blue")
mtext("z", side=4, line=3)

legend(8.5, 0.61, legend=c("Monthly Avg. Precip", "Average Root Zone SM"),bty = "n",
       col=c("red", "blue"), lty =1:1, cex=0.8)



##SM vs. NDVI 

plot(Month,Average.NDVI, pch = "x", col = "blue", xlab = "Month", ylab = "Average NDVI", axes = F,
     main = "Average NDVI vs. Average Monthly Precipitation", cex = 0.5)
axis(side = 1, at = c(1,2,3,4,5,6,7,8,9,10,11,12),
     labels = c("","","March","","", "June","","","September","","", ""))
axis(side = 2, at = c())
box()
#lines(smooth.spline(MonthArr, PrecipMean), lty = 1, col = "red")
lines(Month, Average.NDVI, lwd = 2, col = "green")



par(new = TRUE)
plot(MonthArr, PrecipMean , ylab = " ",xlab = " ", col = "blue" , axes = FALSE, pch = "x", cex = 0.5)
axis(side=4, at = pretty(range(PrecipMean)))
lines(smooth.spline(MonthArr, PrecipMean), col = "blue")
mtext("z", side=4, line=3)

legend(9, 60, legend=c("Average NDVI", "Mean Monthly Precipitation"),bty = "n",
       col=c("green", "blue"), lty =1:1, cex=0.55)
mtext("    Average Monthly Precipitation (mm)", side=1, line=-3, adj=T, outer=TRUE, cex = 0.5)



