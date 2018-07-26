'''This script reads in the University of Delaware Climatology Dataset, calculates the historical trends in precipitation, 
and plots the results on a basemap (Changes in Climatology 1990 to 2000 with respect to the Base Period (1950 - 2011)). 
'''

import numpy as np
import matplotlib.pyplot as plt
import netCDF4
from mpl_toolkits.basemap import Basemap
import matplotlib as mpl


#Makes a counter to only read in winter time steps
winterRange = np.arange(101,342,4)
summerRange = np.arange(103,344,4)
yearRange = np.arange(1950,2011,1)

i = 0
print(winterRange[40])


#give the path to the file to be read and opens the netcdf file 
filename = 'udel_0.25x0.25_seas_1925-2014.nc' 
f= netCDF4.Dataset(filename, mode='r')



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

##Average Precip 1990 to 2000
counter = 0 
base = 40
precip9000 = 0

while counter < 10:
	precip9000 = precip9000 + f.variables['prec'][winterRange[base],:,:] 
	base = base + 1 
	counter = counter + 1


average9000 = precip9000/counter

anom9000 = average9000 - averageprec

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
levels = np.arange(-2,2,0.1)
c= ["#a50026","#d73027","#f46d43","#fdae61","#fee08b","#ffffff","#d9ef8b","#a6d96a","#66bd63","#1a9850","#006837"]
cm = mpl.colors.ListedColormap(c)
precipitation = m.contourf(x,y,anom9000,cmap = cm, levels=levels, alpha =0.7)

#Makes the colorbar and sets the title 
cbar = m.colorbar(precipitation,location='bottom',pad="5%", label='mm/day' )
plt.title("Changes in Climatology 1990 to 2000 with respect to the Base Period")

	
plt.savefig("9000Anom.png")
#plt.show()
plt.close()







