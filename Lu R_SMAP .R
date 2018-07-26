rm(list = ls())
library(rgdal); library(sp); library(raster); library(maptools); library(RColorBrewer); library(gstat)

#source("http://bioconductor.org/biocLite.R")
#biocLite("rhdf5")

library(rhdf5); library(GISTools); library(gplots)


#gpclibPermit()

#setwd("/Users/maddy/Documents/ArcGIS/SMAP/SMAP_Nyblade")

#list.files(pattern="\\.shp$")
#file.exists("STATE.shp")

state <- readOGR(".","state")

SMAPdata <- "SMAP_L4_SM_gph_20170601T013000_Vv2030_001.h5"


h5ls(SMAPdata, all = TRUE)


Geo <- h5read(SMAPdata, "Geophysical_Data", read.attributes = TRUE)



fid <- H5Fopen(SMAPdata)


lat <- H5Dopen(fid, "cell_lat")

sid <- H5Dget_space(lat)
dims <- H5Sget_simple_extent_dims(sid)$size

H5close()



RZ <- Geo$sm_rootzone_wetness
#RZ <- Geo$precipitation_total_surface_flux
#RZ <- Geo$sm_surface_wetness
#RZ <- Geo$snow_depth

Lat <- h5read(SMAPdata, "cell_lat")

Lon <- h5read(SMAPdata, "cell_lon")



RZ <- c(RZ)

Lat <- c(Lat)

Lon <- c(Lon)


H5close()


GRID <- raster(res = c(0.10,0.10), xmn=-180, xmx=180, ymn=-90, ymx=90)


RZSM <- as.data.frame(cbind(Lon, Lat,RZ))
colnames(RZSM) <- c("Lon","Lat","SM")
coordinates(RZSM) <- ~ Lon + Lat
RZSM@proj4string@projargs <- GRID@crs@projargs



RZSMcrop <- RZSM[which(coordinates(RZSM)[,1] > 71.5 & coordinates(RZSM)[,1] < 75),]
RZSMcrop <- RZSMcrop[which(coordinates(RZSMcrop)[,2] > 39 & coordinates(RZSMcrop)[,2] < 41),]

GRIDcrop <- raster(res = c(0.1,0.1), xmn=71, xmx=75, ymn=39, ymx=41)


#RZgrid <- rasterize(RZSM, GRID, RZSM$SM, fun = mean, na.rm = TRUE)  
#RZSM@data$SM[which(RZSM@data$SM < -1)] <- NA

GRIDcrop <- as(GRIDcrop, "SpatialGrid")
GRID <- as(GRID, "SpatialGrid")

RZgrid <- idw(RZSMcrop@data$SM~1,location = RZSMcrop, newdata=GRIDcrop, nmax = 6)
RZgrid@data$var1.pred[which(RZgrid@data$var1.pred < -1)] <- NA


mat.tmp <- as.matrix(RZgrid)
mat.avg <- mean(mat.tmp, na.rm=TRUE)


par(mfrow = c(2,1))
plot(raster(RZgrid), col = brewer.pal(9,"RdYlGn"),main="SMAP L4 Surface and Root Zone Moisture\n 5/1/2015", 
     sub = mat.avg ,xlab="Longtitude\n Average SM (relative saturation):", ylab="Latitude")

lines(state, lwd = 2)






#writeRaster(RZgrid, "SMAPArc1.asc")
#writeGDAL
