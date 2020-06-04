

library(ggplot2) # Data visualization
library(readr) # CSV file I/O, e.g. the read_csv function
library(dplyr)
library(tidyr)
library(plotly)

#https://www.kaggle.com/berkeleyearth/climate-change-earth-surface-temperature-data
#http://berkeleyearth.org/about/


clim_data <- read.csv("GlobalLandTemperaturesByCountry.csv")


clim_data<-clim_data[complete.cases(clim_data),]

clim_data  %>%separate(col = dt, into = c("Year", "Month", "Day"), convert = TRUE) ->clim_data



#CHANGE THESE VARIABLES TO SEE NEW MAPS
#TYPE CAN BE "average" or "max" for average and max temperature respectively
#Region can be world or a list of any of the countries available
#to see the list of possible countries uncomment the next line

#print(unique(clim_data$Country))

TYPE="max"
region="world"
#examples
#region=c("Portugal")
#region=c("Portugal","Spain")
if(TYPE=="average"){
  clim_data %>% 
    select(Year,AverageTemperature,Country) %>%
    group_by(Year,Country) %>%
    summarise(value=mean(AverageTemperature))-> clim_dataf
}



if(TYPE=="max"){
  clim_data %>% 
    select(Year,AverageTemperature,Country) %>%
    group_by(Year,Country) %>%
    summarise(value=max(AverageTemperature))-> clim_dataf
}

if(region!="world"){
  clim_dataf<-clim_dataf[clim_dataf$Country %in% region,]
 
  g <- list(
    fitbounds = "locations",
    visible = TRUE
  )
  }else{
    g <- list(
      visible=TRUE
    )
 
}





clim_data_test<-clim_dataf


max_value=max(clim_data_test$value)
min_value=min(clim_data_test$value)

#clim_data_smp=clim_data[sample(nrow(clim_data), 1000), ]


colnames(clim_data_test)<-c("Year","Country","Temperature")
clim_data_test$Country <- factor(clim_data_test$Country)

clim_data_test<-clim_data_test[complete.cases(clim_data_test),]

"""
clim_data_test %>% mutate(decade = floor(Year/10)*10) %>% 
  group_by(decade,Country) %>% 
  summarize_all(mean) %>% 
  select(-Year)
"""

fig <- clim_data_test %>%
  plot_ly(
    locationmode='country names',
    z = ~Temperature,
    locations=~Country,
    frame = ~Year,
    type = 'choropleth',
    showlegend = T,
    colorscale='bluered',
    zmax=max_value,
    zmin=min_value  
    )



fig <- fig %>% layout(
  title="Evolution of the Average Temperature (C) through the years (1743-2013)",
  geo=g
)

fig <- fig %>%
  animation_opts(
    100
  )



fig

