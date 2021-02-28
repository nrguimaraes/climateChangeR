
############################################################################################################################################

#Activity 11.1:  Exploring the relationship between CO2 level and temperature

############################################################################################################################################


#Try to alter the code on figure 1 to display both y axis overlapped.
source("utils.R") 
#In the first activity we will try to change the first plot so that co2 and temperature overlap in the same axis

# First use the function View to see the both datasets. Here is an example

View(datasets$vostok_co2)
View(datasets$vostok_temperature)


#Using the syntax datasets$dataset_name$column_name assign the columns 
#you will use to the follwing variables x1, x2 , y1 and ,y2.

#In the x variable there should be the age of the vostok_co2 dataset, in the y it should be the co2 of the same dataset
#In the x2 there should be the variable of age but this time in the vostok_temperature dataset and 
#in y2 there should be the temperature from the vostok_temperature dataset. X1 is already filled as example

#SOLUTION###############################
x1<-datasets$vostok_co2$age_ice
x2<-datasets$vostok_temperature$age_ice
y1<-datasets$vostok_co2$co2
y2<-datasets$vostok_temperature$temp
##########################################


#you can see if you assign the correct values by using the print function. For example print(variable_name)

###########SOLUTION###############################
print(x1)
################################################

#if you print the values now
#you can see that the values are the same than the ones when using View and looking at the correct column


#if we build the plot with these variables now, it will not work. Do you have any idea why?
#Hint: use the function length(variable_name) to see how many entries are on the variables

#SOLUTION#############
length(x1)
length(x2)
#######################


#the datasets have different number of entries. thus, we need to adequate the data with more entries.
#we use rolling mean for the effect. the variable y2 is subsitituted by its rolling mean. 

y2<-rollmean(y2, 8, na.pad=TRUE)


#the following code should replicate the intended plot. however some titles and labels are missing. Can you fill 
#the correct spaces on the code so the names match the first plot in the paper?



ay <- list(
 # tickfont = list(color = "red"),
  overlaying = "y",
  side = "right",
  title = "or in this title?"
)
fig <- plot_ly()
fig <- fig %>% add_lines(x =x1, y = y1, name = "what text to put here")
fig <- fig %>% add_lines(x =x2, y = y2, name = "or here", yaxis = "y2")
fig <- fig %>% layout(
  yaxis2 = ay,
  title = "what title to put here?",
  xaxis = list(title='and what label in here?'),
  yaxis=list(title='and here?')
  
)

fig



###################################################################################################################


#Activity 11.2: Exploring the Keeling curve


####################################################################################################################



#We start by replicating some of the data of the main file. However, instead of aggregating the entries by month
# we aggregate them by year

# Remove outliers
datasets$co2 <- datasets$co2[datasets$co2$average != -99.99, ]

# Aggregate data (by year this time)
agg <-aggregate(x = datasets$co2,
                by = list(datasets$co2$year),
                FUN = mean)
agg <- agg[order(agg$year), ]

#we can also simplify the dataset by only selecting the columns that we need (in this case year and average)
agg<-agg[,c("year","average")]


#Then, we proceed to plot the graph
fig2 <- plot_ly(agg, x =  ~ year, y =  ~ average, type = 'scatter',
                mode = 'lines', name = "co2") %>% 
  add_trace(y =  ~ lr, name = "linear regression") %>%
  layout(title = 'Rising Atmospheric CO2 (Keeling Curve)')


fig2


#So far so good! Now it is time to fit a linear regression. For that, we will use the lm function.
#You can begin by running  the following line to see some documentation regarding the function

?lm

#Next, let us try to fit the value in a linear function. For that, we need to define what is our x and y. 
#In the lm function we can define the formula as y~x. therefore, we need to insert the name of the colums that it
#will be our y and our x. Replace those values by the name of the columns in the line of code below. 
#Warning: Do not use "" around the variable name

linear_regression<-lm(y~x,agg)


#if you manage to complete correctly the line above, then wxplore the variable linear_regression and try to 
#assign the fitted values to a new column on the agg dataset named "lr". You can use View(linear_regression) to 
#explore the data

#replace var_name by correct variable in the linear_regression dataset
agg$lr<-linear_regression$var_name



#Finally, we can now  plot the graph
fig2 <- plot_ly(agg, x =  ~ year, y =  ~ average, type = 'scatter',
                mode = 'lines', name = "co2") %>% 
  add_trace(y =  ~ lr, name = "linear regression") %>%
  layout(title = 'Rising Atmospheric CO2 (Keeling Curve)')


fig2


#Next, let us try to predict the values for the next years up to 2030
#Let us first define a data frame with the values that we want to predict

new_df <- data.frame(year = c(2022,2023,2024,2025,2026,2027,2028,2029,2030))

#Next, we need to use the predict function with the new data so we can have the corresponding predictions
#Once again use the following line to see de documentation of the predict function and try to complete
#the arguments below

?predict

predictions<-predict(object=,newdata=)


#Now we can add the predictions to our new dataframe and visualize the plot. 
#For that, we need to add a new trace to our previous plot. Complete the following
#code with the necessary variable on the add_trace (the second one) so we can show the predictions
#Hint: add_trace can accept a completely new dataframe using the x and y arguments. 
new_df$average<-predictions


predict_var_x<-
predict_var_y<-
  
  


fig2_predictions <- plot_ly(agg, x =  ~ year, y =  ~ average, type = 'scatter',
                mode = 'lines', name = "co2") %>% 
  add_trace(y =  ~ lr, name = "lienar regression") %>%
  add_trace(x=predict_var_x,y =  predict_var_y, name = "predictions") %>%
  layout(title = 'Rising Atmospheric CO2 (Keeling Curve)')

fig2_predictions




#  Draw a residual plot with respect to the linear fit. What is the data that must be in the
#residual_x and residual_y variables?

#Hint use View(linear_regression) to inspect what data is stored in the variable that stores the linear regression data.


residual_x<-
residual_y<-

  
fig2_residuals<-plot_ly(x=residual_x,y=residual_y,name="Residuals",type = 'scatter', mode = 'lines')%>%
                layout(title = 'Rising Atmospheric CO2 (Keeling Curve) - residuals',xaxis = list(title='Year'))


fig2_residuals




#Solution##############
#linear_regression<-lm(average~year,agg)


#agg$lr<-linear_regression$fitted.values


#predictions<-predict(object=linear_regression,newdata=new_df)


#predict_var_x<-new_df$year
#predict_var_y<-new_df$average



#residual_x<-agg$year
#residual_y<-linear_regression$residuals

################################



##############################################################################################################################


# Activity 11.3: Simulation
# Extreme Value Statistics: Number of Records in a random sample


########################################################################################################################


# k length of a randomly ordered list ; here k=40
# define a function "records" which calculates the number of records in a randomly ordered list of length k


records <- function(k){
  n<-1 # record counter
  x<-sample(c(1:k),k)  # random order
  max_value<-x[1] #we set the first value as the record
  for (i in x[-1]) #iterate through all values of x
  {if (i>max_value){ #if it is a new record then
      n<-n+1 #increment the counter
      max_value<-i #update the record value
    }
  }  
  return(n)    
}


# now simulate 
nsim<-100000  # number of simulations
Records<-replicate(nsim,records(40))  # list with number of records
# histogram for the number of records
plot_ly(x=Records, type="histogram",histnorm='probability density')%>% layout(title="Histogram",xaxis=list(title="Records"),yaxis=list(title="density"))

#Here the final answer
k<-11 # number of observed records

sum(Records>=k)/nsim    # Probabilty of k or more records



#########################################################################################################################


#Activity 11.4: 

#########################################################################################################################
 
#In this activity we will try to change the 11.5 figure to include a loess smooth of the data 

#In order to do it, recall the utils.R file and in particular the plot where the loess smooth is computed
#and the subsequent plot.

source("utils.R")

#Can you create a variable with the data corresponding to the loess smooth on figure 11.5? Complete the following code?
#What should the values of y_var and x_var be?


y_var<-
x_var<-
  
  
loess_data<-loess.smooth(y=y_var,x=x_var,span=0.3)


#Next we must add the loess_data variable to the plot, in order to do it recall once again the plot that uses
#the loess smooth in the utils.R file. Next, complete the following code. What are the values of the x and y axis
#in the add_trace function?




#Built the plot for the artic sea ice minimum with the respective fitted values

lm_e<-lm(datasets$polar_ice$extent ~datasets$polar_ice$year)

fig5_smooth<-plot_ly(datasets$polar_ice,x=~year,y=~extent,type = 'scatter', mode = 'lines',name="measure")%>%
  add_trace(x=datasets$polar_ice$year,y=lm_e$fitted.values,name="Linear Regression")%>%
  add_trace(x=loess_data$x,y=loess_data$y,name="Loess Smooth")%>%
  layout(title='Arctic Sea Ice Minimum',yaxis = list(title='million square km'),xaxis = list(title='Year'))




fig5_smooth


#  Draw a residual plot with respect to the linear fit. What is the data that must be in the
#residual_x and residual_y variables?

#Hint use View(lm_e) to inspect what data is stored in the variable that stores the linear regression data.


residual_x<-
residual_y<-
  
fig5_residuals<-plot_ly(x=residual_x,y=residual_y,name="Residuals",type = 'scatter', mode = 'lines')%>%
  layout(title='Arctic Sea Ice Minimum (residuals)',yaxis = list(title='million square km'),xaxis = list(title='Year'))


fig5_residuals











#Solution

# y_var<-datasets$polar_ice$extent
# x_var<-datasets$polar_ice$year

# fig5<-plot_ly(datasets$polar_ice,x=~year,y=~extent,type = 'scatter', mode = 'lines',name="measure")%>%
#   add_trace(x=datasets$polar_ice$year,y=lm_e$fitted.values,name="Linear Regression")%>%
#   add_trace(x=loess_data$x,y=loess_data$y,name="Loess Smooth")%>%
#   layout(title='Arctic Sea Ice Minimum',yaxis = list(title='million square km'),xaxis = list(title='Year'))

# Reidual plot

# residual_x<-datasets$polar_ice$year
# residual_y<-lm_e$residuals




#################################################################################################################################

# Activity 11.5: choropleth maps  


#################################################################################################################################


# Duplicate the code from utils_map.R
 

# to find out about the available countries or regions in the data frame and their the correct spelling, write
distinct(clim_data,Country)

# then replace countries in
REGION=list("Portugal","Spain")

# Choose the years you are intrested in, from 1743 on

# Choose the function
#type of function to use
#EXAMPLES 
#TYPE="max"
#TYPE="average"

####################################################################################################################################
