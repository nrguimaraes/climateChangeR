#Problem number 1 
#Try to alter the code on figure 1 to display both y axis overlapped.

source("utils.R")







#EXERCISE 1
#In the first exercise we will try to change the first plot so that co2 and temperature overlap in the same axis



# First use the function View to see the both datasets. Here is an example

View(datasets$vostok_co2)
View(datasets$vostok_temperature)


#Using the sintax datasets$dataset_name$column_name assign the columns 
#you will use to the follwing variables x1, x2 , y1 and ,y2.

#In the x variable there should be the age of the vostok_co2 dataset, in the y it should be the co2 of the same dataset
#In the x2 there should be the variable of age but this time in the vostok_temperature dataset and 
#in y2 there shoud be the temperature from the voskot_temperature dataset. X1 is already filled as example

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
#you can see that the values are the same that the ones when using View and looking at the correct column


#if we build the plot with these variables now, it will not work. Do you have any idea why?
#Hint: use the function length(variable_name) to see how many entries are on the variables

#SOLUTION#############
length(x1)
length(x2)
#######################


#the datasets have different number of entries. thus, we need to adequate the data with more entries.
#we use rolling mean for the effect. the variable y2 is sibsititute by its rolling mean. 

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












