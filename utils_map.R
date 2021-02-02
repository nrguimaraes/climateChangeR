#https://www.kaggle.com/berkeleyearth/climate-change-earth-surface-temperature-data
#http://berkeleyearth.org/about/

list.of.packages <- c("readr", "dplyr","tidyr","plotly")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)!=0) 
  install.packages(new.packages)

library(readr) # CSV file I/O, e.g. the read_csv function
library(dplyr)
library(tidyr)
library(plotly)

#Loads data regarding US state names and abbreviations
load("state_names.RDATA")
load("state_abbs.RDATA")




#CHANGE THESE VARIABLES TO SEE NEW MAPS
#TYPE can be "average" or "max" for average and max temperature respectively
#YEAR can be world or a list of any of the countries available
#YEAR can be all or an interval of time 


#considering a small time interval or all data available
#EXAMPLES:
#YEAR="all"
YEAR=c(1920,2013)

#YEAR="all"

#type of function to use
#EXAMPLES 
#TYPE="max"
#TYPE="average"

TYPE="average"


#examples
#REGION="world"
#REGION=list("Brazil")
#REGION=list("Portugal","Spain")
#REGION="USA"
REGION=list("Morocco",
            "Algeria",
            "Libya",
            "Egypt",
            "Niger",
            "Chad",
            "Tunisia",
            "Sudan",
            "Mauritania", 
            "Kenia", 
            "Mali",
            "Ethiopia",
            "Senegal",
            "Burkina Faso",
            "Somalia",
            "Nigeria",
            "Eritrea"
            )






#Function getCode receives a state name as an input and output its abbreviation.
#In case no abbreviation is found, the output is the state name
getCode<-function(state_name){
  state_name<-as.character(state_name)
  temp<-state.abb[which(state.name==state_name)]
  if(length(temp)>0){return(temp)}
  return(NA)
}


#Conditions regarding the region chosen
if(REGION=="USA"){
    #Data containing the US state temperatures
    clim_data <- read.csv("GlobalLandTemperaturesByState.csv")
    
    #Allow only the complete cases
    clim_data<-clim_data[complete.cases(clim_data),]
    
    #Conversion from date to different columns
    clim_data  %>%separate(col = dt, into = c("Year", "Month", "Day"), convert = TRUE) ->clim_data
    
    #Apply the function getCode to the "States" column in dataset 
    codes<-unlist(lapply(clim_data$State,getCode))
    
    #Create a new column (named variable ) with the codes
    clim_data$variable<-codes
    
    #Set the location type of the map to USA-states (so the function know how to interpret the data we are passing it)
    location_mode<-'USA-states'
  
}else{
  #Data countainng countries temperature 
  clim_data <- read.csv("GlobalLandTemperaturesByCountry.csv")
  
  #Allow only the complete cases
  clim_data<-clim_data[complete.cases(clim_data),]
  
  #Conversion from date to different columns
  clim_data  %>%separate(col = dt, into = c("Year", "Month", "Day"), convert = TRUE) ->clim_data
  
  #Create a new column (named variable) with the country name 
  clim_data$variable<-clim_data$Country
  
  #Set the location type of the map to counry-names (so the function know how to interpret the data we are passing it)
  location_mode<-'country names'
}



#If the type is of the variable YEAR is not a string then we apply conditions to the dataframe so that 
#it only considers entries between the interval defined
if(typeof(YEAR)=="double"){
    clim_data<-clim_data[(clim_data$Year>=YEAR[1]) & (clim_data$Year<=YEAR[2]),]
   
  }



#Conditions regarding the type of function chosen
#select allows the selection of certain columns then, 
#groupby will aggregate entries by Year and Variable (which is states or countries)
#finally summarise applies the desired function (mean or max ) to the data 
# the final -> implies that a new dataframe named clim_dataf is created with the output of this steps
if(TYPE=="average"){

  clim_data %>% 
    select(Year,AverageTemperature,variable) %>%
    group_by(Year,variable) %>%
    summarise(value=mean(AverageTemperature))-> clim_dataf
}else if(TYPE=="max"){
  clim_data %>% 
    select(Year,AverageTemperature,variable) %>%
    group_by(Year,variable) %>%
    summarise(value=max(AverageTemperature))-> clim_dataf
}




#conditions regarding the map layout and data depending on the REGION variable
#the "g" variable refers to geographic configuration parameters on the layout of the final map

if(typeof(REGION)=="list"){
  #only include in the dataframe the list of countries in the variable REGION
  clim_dataf<-clim_dataf[clim_dataf$variable %in% REGION,]
  
  #layout configuration
  #fitbounds refers to the way the bound must be portrayed. When set to "locations" the map will be zoomed in 
  #in the locations of the dataframe
  #visible=True refers to the visibility of countries in the world map
  g <- list(
    fitbounds = "locations",
    visible = TRUE)  
}else if(REGION=="world"){
   
   #if REGION="world" there is no need to define the fitbounds since the default is alreay the world map 
    g <- list(
      visible=TRUE
    )
 
}else{
  #if none of the condition before fits then we are dealing with an individual country or the usa states
  #for both these cases the variable fitbound must be set to "locations"
  g <- list(
    fitbounds = "locations",
    visible = TRUE)  
}












#These variables refer to the maximum and minimum temperatures achieved in the selected data
#It allows to present a constant temeprature scale through the animation
max_value=max(clim_dataf$value)
min_value=min(clim_dataf$value)


#We rename the columns to better names to avoid configure additional layout details (such as the variable label)
colnames(clim_dataf)<-c("Year","variable","Temperature")

#we conver the colum to factor to discard information stored (like discarded countries) that can affect the 
# map configuration
clim_dataf$variable <- factor(clim_dataf$variable)

#We finally perform a last check to garantee that we are working only with complete cases
clim_dataf<-clim_dataf[complete.cases(clim_dataf),]

 




#The fig variable would contain the necessary information to plot the map. First we pass our dataframe to the 
#plotly function using the pipes provided by dplyr.
fig <- clim_dataf %>%
  plot_ly(
    #Type of location we want to show (explained earlier)
    locationmode=location_mode,
    #The column of the dataframe we want to use as value (in this case is Temperature)
    z = ~Temperature,
    #The column of the dataframe where the geospatial information is stored (in this case is variable)
    locations=~variable,
    #The variable for the different "frames" on the animation. In this case we want each frame to represent a year
    frame = ~Year,
    
    #The type of map we want to show. for more information please refer the plotly documentation
    type = 'choropleth',
    #If the legend is to be show on the visualization. In this case is set to True
    showlegend = TRUE,
    #What color schemes to use in the Z variable. Since it is temperature we chose "bluered"
    colorscale='bluered',
    #The limits of the scale we want to use (to avoid different scales in each frame)
    zmax=max_value,
    zmin=min_value  
    )


#We complement the previous information with additional layout configurations such as the title and the geographic
#configuration (explained earlier)
fig <- fig %>% layout(
  title= plot_title<-paste0("Evolution of the Average Temperature (C) through the years (<b>",clim_dataf$Year[1],"-",clim_dataf$Year[nrow(clim_dataf)],"</b>)"),
  geo=g
)

#Additional configuration parameters for the animation.In this case, we  set the time to 100 milisecond per frame
fig <- fig %>%
  animation_opts(
    frame=100
  )


#Finally, we plot the figure 
fig

