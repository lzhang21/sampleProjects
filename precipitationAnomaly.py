''' This script calculates the year-to-year Winter Precipitation Anomalies over the Indus Basin for each year starting from 1950 
and plots it on a basemap, using the ffmpeg the output can be turned into a animation'''


import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
import netCDF4
from mpl_toolkits.basemap import Basemap
from matplotlib.colors import LinearSegmentedColormap

#Makes a counter to only read in winter time steps
winterRange = np.arange(101,342,4)
summerRange = np.arange(103,344,4)
yearRange = np.arange(1950,2011,1)


filename = '/homes/metogra/lzhang21/Final/udel_0.25x0.25_seas_1925-2014.nc' 
f= netCDF4.Dataset(filename, mode='r')

##Gets the average winter precipitation 
counter = 0 
totalprec = 0 
while counter < len(winterRange):
	totalprec = f.variables['prec'][winterRange[counter],:,:] + totalprec
	counter = counter + 1

f.close()

##Average Winter precipitation 
print(counter)
averageprec = totalprec/counter




#Baseplot Animation Loop
i = 0

while (i < 61):

	#give the path to the file to be read and opens the netcdf file 
	filename = '/homes/metogra/lzhang21/Final/udel_0.25x0.25_seas_1925-2014.nc' 
	f= netCDF4.Dataset(filename, mode='r')

	#Prints the dimensions of each variable 
	'''print(f.variables['prec'].dimensions)
	print(f.variables['lon'].dimensions)
	print(f.variables['lat'].dimensions)
	print(f.variables['time'].dimensions)'''


	#Extracts the variables the netcdf file
	time = f.variables['time'][:]
	lons = f.variables['lon'][:]
	lats = f.variables['lat'][:]
	prec = f.variables['prec'][winterRange[i],:,:]

	##Precipitation Anomaly 
	precipAnom = prec - averageprec


	#closes the netcdf file 
	f.close()

##Makes the plot 

	#sets the basemap
	m = Basemap(width=10000000,height=8000000, projection='lcc',lat_0=27, lat_1 = 33 ,lon_0=73, lon_1 = 80)
	m.drawmapboundary(fill_color='white')
	m.drawcoastlines(linewidth = 0.3)
	m.drawcountries(linewidth = 0.3)

	#makes the x and my coordinates 
	lon, lat = np.meshgrid(lons, lats)
	x,y = m(lon, lat)

	#sets the countour range and plots the precipitation on the basemap
	levels = np.arange(-3,3,0.1)
	c= ["#a50026","#d73027","#f46d43","#fdae61","#fee08b","#ffffff","#d9ef8b","#a6d96a","#66bd63","#1a9850","#006837"]
	cm = mpl.colors.ListedColormap(c)

	precipitation = m.contourf(x,y,precipAnom,cmap = cm, levels = levels, alpha =0.7)

	#Makes the colorbar and sets the title 
	cbar = m.colorbar(precipitation,location='bottom',pad="5%", label='mm/day' )
	plt.title("Winter Precipitation Anomaly over the Indus Basin {}".format(yearRange[i]))
	

	plt.savefig("Anomplot{0:02.0f}.png".format(i))	
	#plt.show()
	plt.close()
 
	i = i + 1




