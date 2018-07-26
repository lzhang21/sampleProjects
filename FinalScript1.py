#Lu Zhang AOSC458J final project script 

import numpy as np
import matplotlib.pyplot as plt
import netCDF4
from mpl_toolkits.basemap import Basemap


#Makes a counter to only read in winter time steps
winterRange = np.arange(101,342,4)
summerRange = np.arange(103,344,4)
yearRange = np.arange(1950,2011,1)

i = 0


#give the path to the file to be read and opens the netcdf file 
filename = 'udel_0.25x0.25_seas_1925-2014.nc' 
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

##Gets the total winter precipitation 
i = 0 
totalprec = 0 
while i < len(winterRange):
	totalprec = f.variables['prec'][winterRange[i],:,:] + totalprec
	i = i + 1

##Average Winter precipitation 
averageprec = totalprec/i 


##Gets the total summer precipitation 
i = 0 
summertotalprec = 0 
while i < len(summerRange):
	summertotalprec = f.variables['prec'][summerRange[i],:,:] + summertotalprec
	i = i + 1

##Average Winter precipitation 
averagesummerprec = summertotalprec/i 


#et = f.variables['et'][]
#surplus = f.variables['s'][]

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
levels = np.arange(0,10,1)
precipitation = m.contourf(x,y,averageprec,levels=levels, alpha =0.7)

#Makes the colorbar and sets the title 
cbar = m.colorbar(precipitation,location='bottom',pad="5%", label='mm/day' )
plt.title("Average Winter Precipitation over the Indus Basin from 1950 to 2010")

	
plt.savefig("AverageWinterPrecipitation.png")
#plt.show()
plt.close()


#sets the basemap
m = Basemap(width=10000000,height=8000000, projection='lcc',lat_0=27, lat_1 = 33 ,lon_0=73, lon_1 = 80)
m.drawmapboundary(fill_color='white')
m.drawcoastlines(linewidth = 0.3)
m.drawcountries(linewidth = 0.3)

#makes the x and my coordinates 
lon, lat = np.meshgrid(lons, lats)
x,y = m(lon, lat)

#sets the countour range and plots the precipitation on the basemap
levels = np.arange(0,10,1)
precipitation = m.contourf(x,y,averagesummerprec,levels=levels, alpha =0.7)

#Makes the colorbar and sets the title 
cbar = m.colorbar(precipitation,location='bottom',pad="5%", label='mm/day' )
plt.title("Average Summer Precipitation over the Indus Basin from 1950 to 2010")

	
plt.savefig("AverageSummerPrecipitation.png")
#plt.show()
plt.close()







	
'''
fig, axes = plt.subplots(nrows=4, ncols=3)
for ax in axes.flat:
    map_ax = Basemap(ax=ax)
    map_ax.drawcoastlines()
plt.show()
'''



