
source("utils.R")



#EXERCISE 2
#In the second exercise we will try to change the 11.5 figure to include a loess smooth of the data 

#In order to do it, recall the utils.R file and in particular the plot where the loess smooth is computed
#and the subsequent plot.

#Can you create a variable with the data corresponding to the loess smooth on figure 11.5? Complete the following code?
#What should the values of y_var and x_var be?


y_var<-
x_var<-


loess_data<-loess.smooth(y=y_var,x=x_var,span=0.2)


#Next we must add the loess_data variable to the plot, in order to do it recall once again the plot that uses
#the loess smooth in the utils.R file. Next, complete the following code. What are the values of the x and y axis
#in the add_trace function?




#Buil the plot for the artic sea ice minimum with the respective fitted values

lm_e<-lm(datasets$polar_ice$extent ~datasets$polar_ice$year)

fig5_smooth<-plot_ly(datasets$polar_ice,x=~year,y=~extent,type = 'scatter', mode = 'lines',name="measure")%>%
  add_trace(x=datasets$polar_ice$year,y=lm_e$fitted.values,name="Linear Regression")%>%
  add_trace(x=,y=,name="Loess Smooth")%>%
  layout(title='Arctic Sea Ice Minimum',yaxis = list(title='million square km'),xaxis = list(title='Year'))




fig5_smooth


#Extra Exercise:  Draw a residual plot with respect to the linear fit. What is the data that must be in the
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



#Extra exercise

# residual_x<-datasets$polar_ice$yea
# residual_y<-lm_e$residuals


