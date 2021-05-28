#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(patchwork)
library(lubridate)
library(zoo)
library(plotly)
library(tools)
library(shiny)
library(readr) # CSV file I/O, e.g. the read_csv function
library(dplyr)
library(tidyr)
library(plotly)
library(pryr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    
    output$plot <- renderPlotly({
        rm(list = ls()) 
      
        dataset <- read_table2("vostok.txt", col_names = FALSE, skip = 21)
        colnames(dataset) <- c('depth','age_ice','age_air','co2')
        
        
        
        a1 <- plot_ly(dataset,x=~age_ice,y=~co2,type = 'scatter', mode = "lines",name = ~"Co2")%>%
            layout(xaxis = list(autorange = 'reversed',range=c(420000,0),showticklabels=F,title=""),yaxis=list(title='CO2 concentration (ppm)')) 
        
        dataset <- read_table2("paleotemp.txt", col_names = FALSE, skip = 60)
        colnames(dataset) <- c('depth','age_ice','deuterium','temp')
        
        
        #Buid the second plot with respect to temperature
        b1<-plot_ly(dataset,x=~age_ice,y=rollmean(dataset$temp, 8, na.pad=TRUE),type = 'scatter', mode = "lines",name = ~"Temperature") %>%
            layout(xaxis = list(title='Millennia before present',autorange = 'reversed',range=c(420000,0),showticklabels=T),yaxis=list(title='Temperature (C)'))
        
        
        
        #aggregate both with a shared X value (for better visualization interaction)
        fig <- subplot(nrows=2,a1, b1,shareX = T,shareY = F)  %>% 
            layout(title = "Paleoclimate: The Link Between CO2 and Temperature",
                   xaxis = list(title='Millennia before present'),
                   yaxis=list(title='CO2 concentration (ppm)'),yaxis2=list(title="Temperature (C)"),margin=1)
        fig


        

    })
    
    
    output$plot2 <- renderPlotly({
      rm(list = ls()) 
      
      dataset <- read_table2("maunaloa.txt", col_names = FALSE, skip = 72)
      colnames(dataset) <- c('year', 'month', 'date', 'average', "de_seasonalized" ,"days",'st.devofdays', 'unc_of_mon_mean')
      dataset$date <- as.Date(as.yearmon(paste(dataset$year, dataset$month, sep='-')))
      
      dataset<-dataset[dataset$average!=-99.99,]
        
      
      #aggregate data
      agg<-aggregate(x=dataset, by=list(dataset$year,dataset$month),FUN=mean)
      agg<-agg[order(agg$year),]
        
        
        
      #build plot with respect to co2 in atmosphere
      fig2<-plot_ly(agg,x=~date,y=~average,type = 'scatter', mode = 'lines',name="co2")%>% add_trace(y=~de_seasonalized,name="trend")%>% 
          layout(title='Rising Atmospheric CO2 (Keeling Curve)',yaxis=list(title="CO2 (in ppmv)"),margin=1)
      agg<-NULL
      fig2
    })
    
    output$plot3 <- renderPlotly({
      rm(list = ls()) 
      dataset <- read_csv("gisstemp.csv", skip=1, na='***')
      dataset[nrow(dataset), 14] <- mean(as.numeric(dataset[nrow(dataset), 2:13]), na.rm = T)
      dataset <- dataset[ , c('Year', 'J-D')]
      colnames(dataset) <- c('date', 'annmean')
      dataset$date <- as.Date(as.yearmon(dataset$date))
      dataset$annmean <- as.numeric(dataset$annmean)
      
        
        #create smoothing data
        loess_smooth<-loess.smooth(y=dataset$annmean, x=dataset$date,span = 0.2)
        
        #build plot concerning the global land-ocean temperature as well as the smooth line
        fig3<- plot_ly(data=dataset,x=~date,y=~annmean,type = 'scatter', mode = 'lines',name = "Annual mean") %>% 
            add_trace(data=loess_smooth,x=loess_smooth$x,y=loess_smooth$y,name="Loess smoothing") %>%
            layout(title='Global Land-Ocean Temperature Index (LOTI)',yaxis = list(title='Temperature Anomaly (C)'),xaxis = list(title='Date'),margin=1)
        loess_smooth<-NULL
        agg<-NULL
        fig3
        
    })
    
    output$plot4 <- renderPlotly({
      rm(list = ls()) 
      gmsl_sat <- read_table2("gmsl_sat.csv", col_names = FALSE, skip = 1)
      colnames(gmsl_sat) <- c('date','gmsl_sat')
      gmsl_sat$date <- round_date(date_decimal(gmsl_sat$date),'day')
      
      gmsl_tide <- read_csv("CSIRO_Recons_gmsl_mo_2011.csv", col_types = cols(`GMSL uncertainty (mm)` = col_skip()))
      colnames(gmsl_tide) <- c('date', 'gmsl_tide')
      gmsl_tide$date <- round_date(date_decimal(gmsl_tide$date),'day')
      
      dataset <- full_join(gmsl_tide, gmsl_sat); rm(gmsl_sat, gmsl_tide)
      
      diff <- dataset %>% filter(date>as.Date('1993-01-01') & date<as.Date('1994-01-01')) %>% summarize_all(funs(mean=mean), na.rm=T)
      diff <- diff$gmsl_tide_mean-diff$gmsl_sat_mean
      dataset$gmsl_sat <- dataset$gmsl_sat + diff
      
      dataset <- gather(dataset, key=method, value=gmsl, -date, na.rm=T)
      
     
      
      
      
      
        dataset<-dataset %>% 
            mutate(method = replace(method, method == 'gmsl_tide', "Coastal tide gauge records"))%>% 
            mutate(method = replace(method, method == 'gmsl_sat', "Satellite observations"))
        
        #Build the plot for sea_leval data
        fig4<-plot_ly(dataset,x=~date,y=~gmsl,color = ~method, type = 'scatter', mode = 'lines') %>% 
            layout(title="Sea level rise",yaxis=list(title="sea level (mm)"),margin=1)
        
        fig4
        
        
    })
    
    
    output$plot5<-renderPlotly({
      rm(list=ls())
      dataset <- read_csv("arctic_ice_min.csv")
      dataset$year <- round_date(date_decimal(dataset$year), 'year')
      
        
        #Fitting with linear model
        lm_e<-lm(dataset$extent ~dataset$year)
        
        #Buil the plot for the artic sea ice minimum with the respective fitted values
        fig5<-plot_ly(dataset,x=~year,y=~extent,type = 'scatter', mode = 'lines',name="measure")%>%
            add_trace(x=dataset$year,y=lm_e$fitted.values,name="Linear Regression")%>%
            layout(title='Arctic Sea Ice Minimum',yaxis = list(title='million square km'),xaxis = list(title='Year'))
        
        
        fig5
        
        
    })
   
        
    
    output$maps<-renderPlotly({
        input$activeButton
        isolate({
        print(mem_used())
        rm(list=ls())
        #Loads data regarding US state names and abbreviations
        load("state_names.RDATA")
        load("state_abbs.RDATA")  
        #Function getCode receives a state name as an input and output its abbreviation.
        #In case no abbreviation is found, the output is the state name
        getCode<-function(state_name){
            state_name<-as.character(state_name)
            temp<-state.abb[which(state.name==state_name)]
            if(length(temp)>0){return(temp)}
            return(NA)
        }
        
        YEAR=input$slider2
        TYPE=input$select_type
        REGION=input$select_region
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
            
        }
        
        
        else{
            #Data countainng countries temperature 
            clim_data <- read.csv("GlobalLandTemperaturesByCountry.csv",encoding = "UTF-8")
            
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
                summarise(value=mean(AverageTemperature))-> clim_data
        }else if(TYPE=="max"){
            clim_data %>% 
                select(Year,AverageTemperature,variable) %>%
                group_by(Year,variable) %>%
                summarise(value=max(AverageTemperature))-> clim_data
        }
        
        
        
        
        #conditions regarding the map layout and data depending on the REGION variable
        #the "g" variable refers to geographic configuration parameters on the layout of the final map
        
        if(REGION=="custom"){
           
            countries_selected<-input$countries_selected
            #only include in the dataframe the list of countries in the variable REGION
            clim_data<-clim_data[clim_data$variable %in% countries_selected,]
            
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
        max_value=max(clim_data$value)
        min_value=min(clim_data$value)
        
        
        #We rename the columns to better names to avoid configure additional layout details (such as the variable label)
        colnames(clim_data)<-c("Year","variable","Temperature")
        
        #we conver the colum to factor to discard information stored (like discarded countries) that can affect the 
        # map configuration
        clim_data$variable <- factor(clim_data$variable)
        
        #We finally perform a last check to garantee that we are working only with complete cases
        clim_data<-clim_data[complete.cases(clim_data),]
        
        
        
        
        
        
        #The fig variable would contain the necessary information to plot the map. First we pass our dataframe to the 
        #plotly function using the pipes provided by dplyr.
        fig <- clim_data %>%
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
            title= plot_title<-paste0("Evolution of the Average Temperature (C) through the years (<b>",input$slider2[1],"-",input$slider2[2],"</b>)"),
            geo=g
        )
        
        #Additional configuration parameters for the animation.In this case, we  set the time to 100 milisecond per frame
        fig <- fig %>%
            animation_opts(
                frame=100
            )
        
        
        #Finally, we plot the figure 
        fig
        
        })
        
    })
  
})
