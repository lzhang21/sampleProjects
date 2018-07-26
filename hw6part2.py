###Histogram of wind speeds 

import numpy as np 
import matplotlib.pyplot as plt

##Read the csv file
data = 'hw6data.csv'

"""Making a 2d numpy array from data where only the wind and pressure columns are taken
Also masked and hide columns with no values"""
data1 = np.genfromtxt(data, delimiter=',', dtype = float, skip_header=1, usecols=(17,20))
data1 = np.ma.masked_where(np.isnan(data1), data1)
data1 = np.ma.compress_rows(data1)


#Defining wind array through indexing
wind = (data1[:,0])


#making the histogram
plt.hist(wind, bins = 10)
plt.xlabel("Wind Speed (mph)")
plt.ylabel("Count")
plt.title("Wind Speed Histogram")
plt.show()
