list.of.packages <- c("tidyverse", "patchwork","lubridate","zoo","plotly","tools","RJSONIO")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)!=0) 
  install.packages(new.packages)


library(tidyverse)
library(patchwork)
library(lubridate)
library(zoo)
library(plotly)
library(tools)




#Adapting the content from https://rethinking.rbind.io/2018/11/16/the-top-five-climate-charts-using-ggplot2/ 
#to work with interactive plots


#Auxiliary function
#adapt from https://stackoverflow.com/questions/35260659/r-download-file-rename-the-downloaded-file-if-the-filename-already-exists




download_with_overwrite <- function(url, filename,overwrite=TRUE)
{
  folder<-getwd()
  ext <- tools::file_ext(filename)
  
  file_exists <- grepl(filename, list.files(folder), fixed = TRUE)
  
  if (any(file_exists))
  {
    new_filename <- paste0(filename, "(", sum(file_exists), ")", ".", ext)
  }
  
  d<-tryCatch({
    download.file(url, file.path(folder, new_filename), mode = "wb", method = "libcurl")
    file.copy(new_filename,filename,overwrite=T)
    file_exists <- grepl(filename, list.files(folder), fixed = TRUE)
    
    files_to_remove<-list.files(folder)[file_exists]
    files_to_remove<-files_to_remove[files_to_remove!=filename]
    lapply(files_to_remove,unlink)
    lapply(files_to_remove,file.remove)
    
    
 },
 error = function(e){
    
  },
  warning = function(w){
   
})
}




#Function to load the data
#if overwrite is set to True the current datasets downloaded are replaced (useful when new data is available)

load_data<-function(overwrite=F){
  datasets<-list()
  if(!file.exists("vostok.txt")|| overwrite){
    file_url <- 'http://cdiac.ess-dive.lbl.gov/ftp/trends/co2/vostok.icecore.co2'
    
    download_with_overwrite(file_url,'vostok.txt')
  }
  
  vostok <- read_table2("vostok.txt", col_names = FALSE, skip = 21)
  colnames(vostok) <- c('depth','age_ice','age_air','co2')
  
  datasets$vostok_co2<-vostok
  
  if(!file.exists("paleotemp.txt") || overwrite){
    
    file_url <- 'http://cdiac.ess-dive.lbl.gov/ftp/trends/temp/vostok/vostok.1999.temp.dat'
    download_with_overwrite(file_url,'paleotemp.txt')
  }
  paleotemp <- read_table2("paleotemp.txt", col_names = FALSE, skip = 60)
  colnames(paleotemp) <- c('depth','age_ice','deuterium','temp')
  datasets$vostok_temperature<-paleotemp
  
  if(!file.exists("maunaloa.txt")|| overwrite){
    file_url <- 'ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt'
    download_with_overwrite(file_url,'maunaloa.txt')
  }
  
  maunaloa <- read_table2("maunaloa.txt", col_names = FALSE, skip = 72)
  colnames(maunaloa) <- c('year', 'month', 'date', 'average', "de_seasonalized" ,"days",'st.devofdays', 'unc_of_mon_mean')
  maunaloa$date <- as.Date(as.yearmon(paste(maunaloa$year, maunaloa$month, sep='-')))
  datasets$co2<-maunaloa
  
  if(!file.exists("gisstemp.csv") || overwrite){
    file_url <- 'https://data.giss.nasa.gov/gistemp/tabledata_v3/GLB.Ts+dSST.csv'
    download_with_overwrite(file_url,'gisstemp.csv')
  }
  
  gisstemp <- read_csv("gisstemp.csv", skip=1, na='***')
  gisstemp[nrow(gisstemp), 14] <- mean(as.numeric(gisstemp[nrow(gisstemp), 2:13]), na.rm = T)
  gisstemp <- gisstemp[ , c('Year', 'J-D')]
  colnames(gisstemp) <- c('date', 'annmean')
  gisstemp$date <- as.Date(as.yearmon(gisstemp$date))
  gisstemp$annmean <- as.numeric(gisstemp$annmean)
  datasets$land_ocean_temp<-gisstemp
  
  
  
  if(!file.exists("gmsl_sat.csv")|| overwrite){
    file_url <- 'http://sealevel.colorado.edu/files/2018_rel1/sl_ns_global.txt'
    download_with_overwrite(file_url,'gmsl_sat.csv')
  }
  gmsl_sat <- read_table2("gmsl_sat.csv", col_names = FALSE, skip = 1)
  colnames(gmsl_sat) <- c('date','gmsl_sat')
  gmsl_sat$date <- round_date(date_decimal(gmsl_sat$date),'day')
  
  if(!file.exists("gmsl_tide.zip")|| overwrite){
    file_url <- 'http://www.cmar.csiro.au/sealevel/downloads/church_white_gmsl_2011.zip'
    download_with_overwrite(file_url,'gmsl_tide.zip')
    unzip('gmsl_tide.zip', 'CSIRO_Recons_gmsl_mo_2011.csv', overwrite = T)
  }
  gmsl_tide <- read_csv("CSIRO_Recons_gmsl_mo_2011.csv", col_types = cols(`GMSL uncertainty (mm)` = col_skip()))
  colnames(gmsl_tide) <- c('date', 'gmsl_tide')
  gmsl_tide$date <- round_date(date_decimal(gmsl_tide$date),'day')
  
  gmsl <- full_join(gmsl_tide, gmsl_sat); rm(gmsl_sat, gmsl_tide)
  
  diff <- gmsl %>% filter(date>as.Date('1993-01-01') & date<as.Date('1994-01-01')) %>% summarize_all(funs(mean=mean), na.rm=T)
  diff <- diff$gmsl_tide_mean-diff$gmsl_sat_mean
  gmsl$gmsl_sat <- gmsl$gmsl_sat + diff
  
  gmsl <- gather(gmsl, key=method, value=gmsl, -date, na.rm=T)
  
  datasets$sea_level<-gmsl
  
  
  
  
  
  
  if(!file.exists("arctic_ice_min.csv")|| overwrite){
    file_url <- 'ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/monthly/data/N_09_extent_v3.0.csv'
    download_with_overwrite(file_url, 'arctic_ice_min.csv')
  }
  
  arctic_ice_min <- read_csv("arctic_ice_min.csv")
  arctic_ice_min$year <- round_date(date_decimal(arctic_ice_min$year), 'year')
  datasets$polar_ice<-arctic_ice_min
  return(datasets)
}


#load the data
datasets<-load_data(overwrite=T)







#Build the first plot with respect to co2

a1 <- plot_ly(datasets$vostok_co2,x=~age_ice,y=~co2,type = 'scatter', mode = 'lines',name = ~"Co2")%>%
  layout(xaxis = list(autorange = 'reversed',range=c(420000,0),showticklabels=F,title=""),yaxis=list(title='CO2 concentration (ppm)')) 



#Buid the second plot with respect to temperature
b1<-plot_ly(datasets$vostok_temperature,x=~age_ice,y=rollmean(datasets$vostok_temperature$temp, 8, na.pad=TRUE),type = 'scatter', mode = 'lines',name = ~"Temperature") %>%
  layout(xaxis = list(title='Millennia before present',autorange = 'reversed',range=c(420000,0),showticklabels=T),yaxis=list(title='Temperature (C)'))




#aggregate both with a shared X value (for better visualization interaction)
fig <- subplot(nrows=2,a1, b1,shareX = T,shareY = F)  %>% 
  layout(title = "Paleoclimate: The Link Between CO2 and Temperature",
         xaxis = list(title='Millennia before present'),
         yaxis=list(title='CO2 concentration (ppm)'),yaxis2=list(title="Temperature (C)"))


#fig




#remove outliers

datasets$co2<-datasets$co2[datasets$co2$average!=-99.99,]


#aggregate data
agg<-aggregate(x=datasets$co2, by=list(datasets$co2$year,datasets$co2$month),FUN=mean)
agg<-agg[order(agg$year),]



#build plot with respect to co2 in atmosphere
fig2<-plot_ly(agg,x=~date,y=~average,type = 'scatter', mode = 'lines',name="co2")%>% add_trace(y=~de_seasonalized,name="trend")%>% 
  layout(title='Rising Atmospheric CO2 (Keeling Curve)',yaxis=list(title="CO2 (in ppmv)"))
  
      
#fig2





###########################################################################

#Data Set #3: Rising Global Temperatures…






#create smoothing data
loess_smooth<-loess.smooth(y=datasets$land_ocean_temp$annmean, x=datasets$land_ocean_temp$date,span = 0.2)

#build plot concerning the global land-ocean temperature as well as the smooth line
fig3<- plot_ly(data=datasets$land_ocean_temp,x=~date,y=~annmean,type = 'scatter', mode = 'lines',name = "Annual mean") %>% 
          add_trace(data=loess_smooth,x=loess_smooth$x,y=loess_smooth$y,name="Loess smoothing") %>%
          layout(title='Global Land-Ocean Temperature Index (LOTI)',yaxis = list(title='Temperature Anomaly (C)'),xaxis = list(title='Date'))
  
  
  


#Replace the method values for a more comprehensive visualization

datasets$sea_level<-datasets$sea_level %>% 
  mutate(method = replace(method, method == 'gmsl_tide', "Coastal tide gauge records"))%>% 
  mutate(method = replace(method, method == 'gmsl_sat', "Satellite observations"))

#Build the plot for sea_leval data
fig4<-plot_ly(datasets$sea_level,x=~date,y=~gmsl,color = ~method, type = 'scatter', mode = 'lines') %>% 
  layout(title="Sea level rise",yaxis=list(title="sea level (mm)"))







#Fitting with linear model
lm_e<-lm(datasets$polar_ice$extent ~datasets$polar_ice$year)

#Buil the plot for the artic sea ice minimum with the respective fitted values
fig5<-plot_ly(datasets$polar_ice,x=~year,y=~extent,type = 'scatter', mode = 'lines',name="measure")%>%
  add_trace(x=datasets$polar_ice$year,y=lm_e$fitted.values,name="Linear Regression")%>%
  layout(title='Arctic Sea Ice Minimum',yaxis = list(title='million square km'),xaxis = list(title='Year'))








# library(raster)
# library(sp)
# 
# # Retrieve average temperature data from WorldClim
# global.temp <- getData('worldclim', download = TRUE, var = 'tmean', res = 5)
# 
# 
# 
# # Global Temperature across 12 months (1960-1990)
# plot(global.temp/10)
# 




