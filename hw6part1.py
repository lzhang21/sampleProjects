import numpy as np 
import matplotlib.pyplot as plt

##Read the csv file
data = 'hw6data.csv'

"""Making a 2d numpy array from data where only the wind and pressure columns are taken
Also masked and hide columns with no values"""
data1 = np.genfromtxt(data, delimiter=',', dtype = float, skip_header=1, usecols=(17,20))
data1 = np.ma.masked_where(np.isnan(data1), data1)
data1 = np.ma.compress_rows(data1)


#Defining wind and pressure array through indexing
wind = (data1[:,0])
pressure = (data1[:,1])

#Finding the 70% of highest wind threshold
highwind = (np.amax(wind))*0.7

#Making a array where winds below threshold are masked
strongwind = np.ma.masked_where(wind < highwind, wind)


#Making the plot 
plt.scatter(wind,pressure, label = "Wind vs. Pressure", s = 4)
plt.scatter(strongwind,pressure, c = 'r', s = 4,  label = "Strongest Wind vs. Pressure")
plt.title("Wind Speed vs. Pressure")
plt.xlabel("Wind Speed (mph)")
plt.ylabel("Pressure (in)")
plt.legend(loc='best')
plt.show()




