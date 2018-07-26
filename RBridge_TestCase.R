#Instead of using the summarize within tool on ArcGIS, I brought in some spatial data to R and performed a aggregation
#Summaraizes total length of impaired waters for each state 


#Load R-ArcGIS Bridge and other modules and set working directory 
library(ggplot2)
library(stringr)
library(arcgisbinding)
arc.check_product()
library(sp)


#Read in shapefile from project
water_df <- arc.open("C:/Users/lu9739/Documents/Projects/rad_303d_20150501/rad_303d_l.shp")

#Selecting only certain fields from the shapefile 
select_df <- arc.select(object = water_df, fields = c('SOURCE_ORG', 'ELENGTH_KM'))


impairedtable <- aggregate(select_df$ELENGTH_KM, 
                            by = list(category = select_df$SOURCE_ORG), sum)



names(impairedtable) <-c("State","KmImpairedWater")

watertable <- impairedtable

arc.write('C:/Users/lu9739/Documents/ArcGIS/Projects/PublicSafetyProject/PublicSafetyProject.gdb', watertable)
