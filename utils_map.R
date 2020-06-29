
library(ggplot2) # Data visualization
library(readr) # CSV file I/O, e.g. the read_csv function
library(dplyr)
library(tidyr)
library(plotly)
library(zoo)
load("state_names.RDATA")
load("state_abbs.RDATA")
#https://www.kaggle.com/berkeleyearth/climate-change-earth-surface-temperature-data
#http://berkeleyearth.org/about/




#CHANGE THESE VARIABLES TO SEE NEW MAPS
#TYPE CAN BE "average" or "max" for average and max temperature respectively
#Region can be world or a list of any of the countries available
#to see the list of possible countries uncomment the next line

#print(unique(clim_data$Country))


#considering a small time interval or all data available
#EXAMPLES:
#YEAR="all"
#YEAR=c(1950,2018)

YEAR="all"

#type of function to use
#EXAMPLES 
#TYPE="max"
#TYPE="average"

TYPE="average"


#examples
#REGION="world"
#REGION=list("Brazil")
#REGION=list("Portugal","Spain")
REGION="USA"






getCode<-function(state_name){
  state_name<-as.character(state_name)
  temp<-state.abb[which(state.name==state_name)]
  if(length(temp)>0){return(temp)}
  return(state_name)
}

if(REGION=="USA"){
    clim_data <- read.csv("GlobalLandTemperaturesByState.csv")
    
    
    clim_data<-clim_data[complete.cases(clim_data),]
    
    clim_data  %>%separate(col = dt, into = c("Year", "Month", "Day"), convert = TRUE) ->clim_data
    
    
    codes<-unlist(lapply(clim_data$State,getCode))
    clim_data$variable<-codes
    
    location_mode<-'USA-states'
  
}else{
  clim_data <- read.csv("GlobalLandTemperaturesByCountry.csv")
  clim_data<-clim_data[complete.cases(clim_data),]
  
  clim_data  %>%separate(col = dt, into = c("Year", "Month", "Day"), convert = TRUE) ->clim_data
  
  clim_data$variable<-clim_data$Country
  location_mode<-'country names'
}




if(typeof(YEAR)=="double"){
    clim_data<-clim_data[(clim_data$Year>=YEAR[1]) & (clim_data$Year<=YEAR[2]),]
   
  }




if(TYPE=="average"){
  clim_data %>% 
    select(Year,AverageTemperature,variable) %>%
    group_by(Year,variable) %>%
    summarise(value=mean(AverageTemperature))-> clim_dataf
}


# if(TYPE=="mov_average"){
#                  
#   
#   clim_data_test %>% mutate(decade = floor(Year/10)*10) %>%
#     group_by(Year,decade,variable) %>%
#     mutate(rM=rollmean(value,10, na.pad=TRUE, align="right"))->test
#   
# }




if(TYPE=="max"){
  clim_data %>% 
    select(Year,AverageTemperature,variable) %>%
    group_by(Year,variable) %>%
    summarise(value=max(AverageTemperature))-> clim_dataf
}




if(typeof(REGION)=="list"){
  clim_dataf<-clim_dataf[clim_dataf$variable %in% REGION,]
  g <- list(
    fitbounds = "locations",
    visible = TRUE)  
}else if(REGION=="world"){

 
    g <- list(
      visible=TRUE
    )
 
}else{
  g <- list(
    fitbounds = "locations",
    visible = TRUE)  
}











# 
# 
# x <- clim_dataf
# s <- split(x, cumsum(c(TRUE, diff(x$value) <= 0.001)))
# 
# max<-0
# 
# for(i in s){
#   if(nrow(i)>max){
#     t<-i
#     max<-nrow(i)
#   }
# }
# print(t)



clim_data_test<-clim_dataf


max_value=max(clim_data_test$value)
min_value=min(clim_data_test$value)

#clim_data_smp=clim_data[sample(nrow(clim_data), 1000), ]


colnames(clim_data_test)<-c("Year","variable","Temperature")
clim_data_test$variable <- factor(clim_data_test$variable)

clim_data_test<-clim_data_test[complete.cases(clim_data_test),]

 
# clim_data_test %>% mutate(decade = floor(Year/10)*10) %>% 
#   group_by(decade,variable) %>% 
#   summarize_all(mean) %>% 
#   select(-Year)





fig <- clim_data_test %>%
  plot_ly(
    locationmode=location_mode,
    z = ~Temperature,
    locations=~variable,
    frame = ~Year,
    type = 'choropleth',
    showlegend = T,
    colorscale='bluered',
    zmax=max_value,
    zmin=min_value  
    )



fig <- fig %>% layout(
  title= plot_title<-paste0("Evolution of the Average Temperature (C) through the years (",clim_data_test$Year[1],"-",clim_data_test$Year[nrow(clim_data_test)],")"),
  geo=g
)

fig <- fig %>%
  animation_opts(
    100
  )



fig

