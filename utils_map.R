

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

clim_data %>% 
  select(Year,AverageTemperature,Country) %>%
  group_by(Year,Country) %>%
  summarise(value=mean(AverageTemperature))-> clim_dataf




clim_data_test<-clim_dataf

max_value=max(clim_data_test$value)
min_value=min(clim_data_test$value)

#clim_data_smp=clim_data[sample(nrow(clim_data), 1000), ]


colnames(clim_data_test)<-c("Year","Country","Temperature")

fig <- clim_data_test %>%
  plot_ly(
    locationmode='country names',
    z = ~Temperature,
    locations=~Country,
    frame = ~Year,
    type = 'choropleth',
    showlegend = F,
    colorscale='bluered',
    zmax=max_value,
    zmin=min_value  
    )

fig <- fig %>% layout(
  title="Evolution of the Average Temperature (C) through the years (1743-2013)"
)

fig <- fig %>%
  animation_opts(
    100
  )

fig

