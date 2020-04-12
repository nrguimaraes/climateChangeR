#Hello Git
library(tidyverse)
library(patchwork)
library(lubridate)
library(zoo)
library(plotly)


load_data<-function(){
  datasets<-list()
  
  file_url <- 'http://cdiac.ess-dive.lbl.gov/ftp/trends/co2/vostok.icecore.co2'
  download.file(file_url,'vostok.txt')
  vostok <- read_table2("vostok.txt", col_names = FALSE, skip = 21)
  colnames(vostok) <- c('depth','age_ice','age_air','co2')
  datasets$vostok_co2<-vostok
  
  file_url <- 'http://cdiac.ess-dive.lbl.gov/ftp/trends/temp/vostok/vostok.1999.temp.dat'
  download.file(file_url,'paleotemp.txt')
  paleotemp <- read_table2("paleotemp.txt", col_names = FALSE, skip = 60)
  colnames(paleotemp) <- c('depth','age_ice','deuterium','temp')
  datasets$vostok_temperature<-paleotemp
  
  
  file_url <- 'ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt'
  download.file(file_url,'maunaloa.txt')
  maunaloa <- read_table2("maunaloa.txt", col_names = FALSE, skip = 72)
  colnames(maunaloa) <- c('year', 'month', 'date', 'average', 'interpolated', 'trend','days')
  maunaloa$date <- as.Date(as.yearmon(paste(maunaloa$year, maunaloa$month, sep='-')))
  datasets$co2<-maunaloa
  
  file_url <- 'https://data.giss.nasa.gov/gistemp/tabledata_v3/GLB.Ts+dSST.csv'
  download.file(file_url,'gisstemp.csv')
  gisstemp <- read_csv("gisstemp.csv", skip=1, na='***')
  gisstemp[nrow(gisstemp), 14] <- mean(as.numeric(gisstemp[nrow(gisstemp), 2:13]), na.rm = T)
  gisstemp <- gisstemp[ , c('Year', 'J-D')]
  colnames(gisstemp) <- c('date', 'annmean')
  gisstemp$date <- as.Date(as.yearmon(gisstemp$date))
  gisstemp$annmean <- as.numeric(gisstemp$annmean)
  datasets$land_ocean_temp<-gisstemp
  
  
  
  
  file_url <- 'http://sealevel.colorado.edu/files/2018_rel1/sl_ns_global.txt'
  download.file(file_url,'gmsl_sat.csv')
  gmsl_sat <- read_table2("gmsl_sat.csv", col_names = FALSE, skip = 1)
  colnames(gmsl_sat) <- c('date','gmsl_sat')
  gmsl_sat$date <- round_date(date_decimal(gmsl_sat$date),'day')
  
  
  file_url <- 'http://www.cmar.csiro.au/sealevel/downloads/church_white_gmsl_2011.zip'
  download.file(file_url,'gmsl_tide.zip')
  unzip('gmsl_tide.zip', 'CSIRO_Recons_gmsl_mo_2011.csv', overwrite = T)
  gmsl_tide <- read_csv("CSIRO_Recons_gmsl_mo_2011.csv", col_types = cols(`GMSL uncertainty (mm)` = col_skip()))
  colnames(gmsl_tide) <- c('date', 'gmsl_tide')
  gmsl_tide$date <- round_date(date_decimal(gmsl_tide$date),'day')
  
  gmsl <- full_join(gmsl_tide, gmsl_sat); rm(gmsl_sat, gmsl_tide)
  
  diff <- gmsl %>% filter(date>as.Date('1993-01-01') & date<as.Date('1994-01-01')) %>% summarize_all(funs(mean=mean), na.rm=T)
  diff <- diff$gmsl_tide_mean-diff$gmsl_sat_mean
  gmsl$gmsl_sat <- gmsl$gmsl_sat + diff
  
  gmsl <- gather(gmsl, key=method, value=gmsl, -date, na.rm=T)
  
  datasets$sea_level<-gmsl
  
  
  
  
  
  
  
  file_url <- 'ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/monthly/data/N_09_extent_v3.0.csv'
  download.file(file_url, 'arctic_ice_min.csv')
  arctic_ice_min <- read_csv("arctic_ice_min.csv")
  arctic_ice_min$year <- round_date(date_decimal(arctic_ice_min$year), 'year')
  datasets$polar_ice<-arctic_ice_min
  return(datasets)
}

datasets<-load_data()



#theme_set(theme_bw(base_size = 14))





#a <- ggplot(datasets$vostok_co2,aes(x=age_ice,y=co2)) +geom_line(size=1, col='firebrick1') +scale_x_reverse(lim=c(420000,0)) +
#  theme(axis.title.x=element_blank(), axis.text.x=element_blank()) +labs(y=expression(CO[2]*' concentration' ))



a1 <- plot_ly(datasets$vostok_co2,x=~age_ice,y=~co2,type = 'scatter', mode = 'lines',name = ~"Co2")%>%
  layout(xaxis = list(autorange = 'reversed',range=c(420000,0),showticklabels=F,title=""),yaxis=list(title='CO2 concentration')) 




b1<-plot_ly(datasets$vostok_temperature,x=~age_ice,y=rollmean(datasets$vostok_temperature$temp, 8, na.pad=TRUE),type = 'scatter', mode = 'lines',name = ~"Temperature") %>%
  layout(xaxis = list(title='Millennia before present',autorange = 'reversed',range=c(420000,0),showticklabels=T),yaxis=list(title='Temperature (C)'))





fig <- subplot(nrows=2,a1, b1,shareX = T,shareY = F)  %>% layout(title = "Paleoclimate: The Link Between CO2 and Temperature")


fig

#b <- ggplot(datasets$vostok_temperature,aes(x=age_ice,y=temp)) +geom_line(aes(y=rollmean(temp, 8, na.pad=TRUE)), size=1, col='dodgerblue2') +scale_x_reverse(lim=c(420000,0),
#                                                                                                                                           labels = scales::unit_format(unit='',scale = 1e-3)) +labs(x='Millennia before present', 
#                                                                                                                                                                                                     y='Temperature (C)')

#(c <- a / b + plot_annotation(title = expression('Paleoclimate: The Link Between '*CO[2]*' and Temperature'), caption = 'Source: Carbon Dioxide Information Analysis Center (CDIAC)\nhttp://cdiac.ess-dive.lbl.gov/trends/co2/vostok.html',
#                             subtitle='420,000 years from the Vostok ice core, Antarctica.', theme = theme(  plot.title = element_text(size = 20))))



#################LATER#####################################



#remove outliers

datasets$co2<-datasets$co2[datasets$co2$average!=-99.99,]


#aggregate data
agg<-aggregate(x=datasets$co2, by=list(datasets$co2$year,datasets$co2$month),FUN=mean)
agg<-agg[order(agg$year),]

#fig2<-plot_ly(datasets$co2,x=~year,y=~average,type = 'scatter', mode = 'lines')%>% add_trace(y=~trend)


fig2<-plot_ly(agg,x=~date,y=~average,type = 'scatter', mode = 'lines',name="co2")%>% add_trace(y=~trend,name="trend")%>%
  layout(title='Rising Atmospheric CO2 (Keeling Curve)')
  
      
fig2


(d <- ggplot(maunaloa, aes(x=date, y=average)) +geom_line(color='dodgerblue2', alpha=0.7) +
    scale_x_date(name=NULL, date_breaks='10 years', lim=c(ymd('1963-01-01'), ymd('2020-01-01')), date_labels='%Y') +scale_y_continuous(lim=c(300, 410), breaks=seq(300, 400, 20)) +
    geom_line(aes(y=trend), size=1, col='firebrick1') +labs(title=expression('Rising Atmospheric '*CO[2]*' (Keeling Curve)'), subtitle=expression('Mauna Loa '*CO[2]*' monthly mean ppm'),
                                                            y=expression(CO[2]*' concentration in air' ), caption='Source: NOAA/ESRL and Scripps Institution of Oceanography.\nhttps://www.esrl.noaa.gov/gmd/ccgg/trends/data.html'))




###########################################################################

#Data Set #3: Rising Global Temperatures…






(e <- ggplot(gisstemp, aes(x=date, y=annmean)) +geom_line(alpha=0.75, aes(color='Annual mean')) + 
    scale_x_date(name=NULL, lim=c(as.Date('1878-01-01'),as.Date('2020-01-01')), date_breaks='15 years', date_labels='%Y') +
    scale_y_continuous() +geom_smooth(size=1.1, se=F, span=0.2, aes(color='Loess smoothing'),method = 'loess', formula='y ~ x') +
    labs(title='Global Land-Ocean Temperature Index (LOTI)', subtitle='Global surface temperature relative to 1951-1980 average',
         y='Temperature Anomaly (C)', caption='Source: NASA Goddard Institute for Space Studies\nhttps://data.giss.nasa.gov/gistemp/') +
    scale_color_manual(name=NULL, values=c('dodgerblue2','firebrick1')) +theme(legend.position = c(0.15,0.85),legend.background=element_blank()))







(f <- ggplot(gmsl, aes(x=date,color=method,y=gmsl)) +geom_line(alpha=0.7,size=1) +
    scale_x_datetime(name=NULL, breaks='15 years', lim=c(ymd_hms('1878-01-01 00:00:00'), ymd_hms('2020-01-01 00:00:00')), date_labels ='%Y') +
    scale_color_manual(values=c('dodgerblue2','firebrick1'),labels=c('Satellite observations','Coastal tide gauge records')) +theme(legend.position = c(0.20,0.80),legend.background=element_blank(),legend.title = element_blank()) +
    scale_y_continuous(breaks=seq(-200,75,25)) +
    labs(title='Sea Level Change', subtitle='Tide gauges: 1880-2009; Satellite: 1992-2018, calibrated to 1993 tide gauge average.', y='Variation (mm)', caption='Sources: University of Colorado Sea Level Research Group (sat)\nhttp://sealevel.colorado.edu/\nCSIRO (tide gauge)\nhttp://www.cmar.csiro.au/sealevel/sl_data_cmar.html'))










(g <- ggplot(arctic_ice_min,aes(x=year, y=extent)) +geom_line(size=1, color='firebrick1') +
    scale_x_datetime(name=NULL, breaks='5 years', date_labels='%Y', lim=c(ymd_hms('1978-01-01 00:00:00'), ymd_hms('2020-01-01 00:00:00'))) +
    scale_y_continuous(lim=c(3,8)) + geom_smooth(method='lm', se=F, linetype=2, size=0.5) +
    labs(title='Arctic Sea Ice Minimum', subtitle='September average sea ice extent. Linear regression line in blue.', y='million square km', caption='Source: National Snow & Ice Data Center\nhttps://nsidc.org/data/seaice_index\nftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/monthly/data/N_09_extent_v3.0.csv'))



