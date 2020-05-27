
install.packages("devtools")
library(devtools)
install_github("ropensci/rWBclimate")
library(rWBclimate)
library(ggplot2)


### Grab temp data
gbr.dat.t <- get_ensemble_temp("GBR", "annualavg", 1900, 2100)
## Loading required package: rjson
### Subset to just the median percentile
gbr.dat.t <- subset(gbr.dat.t, gbr.dat.t$percentile == 50)
## Plot and note the past is the same for each scenario
ggplot(gbr.dat.t, aes(x=fromYear,y=data,group=scenario,colour=scenario)) +
  geom_point() +
  geom_path() +
  theme_bw() +
  xlab("Year") +
  ylab("Annual Average Temperature in 20 year increments")



gbr.dat.p <- get_ensemble_precip("GBR", "annualavg", 1900, 2100)
gbr.dat.p <- subset(gbr.dat.p, gbr.dat.p$percentile == 50)
ggplot(gbr.dat.p, aes(x = fromYear, y = data, group = scenario, colour = scenario)) +
  geom_point() + geom_path() + theme_bw() + xlab("Year") + ylab("Annual Average precipitation in mm")




gbr.modelpast <- subset(gbr.dat.t, gbr.dat.t$scenario == "past")
gbr.historical <- get_historical_temp("GBR", "year")
### Plot create historical plot
hist.plot <- ggplot(gbr.historical, aes(x = year, y = data)) + geom_point() +
  geom_path()

### Create a centroid for the past
gbr.modelpast$centroid <- round((gbr.modelpast$fromYear + gbr.modelpast$toYear)/2)

### Create averages based the same windows used in the model output for
### comparison
win_avg <- function(from, to, df) {
  win <- subset(df, df$year >= from & df$year <= to)
  
  return(c(mean(win$data), round(mean(c(from, to)))))
}
hist.avg <- matrix(0, ncol = 2, nrow = 0)
for (i in 1:dim(gbr.modelpast)[1]) {
  hist.avg <- rbind(hist.avg, win_avg(gbr.modelpast$fromYear[i], gbr.modelpast$toYear[i],
                                      gbr.historical))
}
colnames(hist.avg) <- c("data", "centroid")

### Create new dataframe of historical averages and model averages
hist.comp <- rbind(hist.avg, cbind(gbr.modelpast$data, gbr.modelpast$centroid))
hist.comp <- as.data.frame(hist.comp)
hist.comp$Output <- c(rep("Historical", 4), rep("Model", 4))

### overlay the averages with the original raw data plot
hist.plot <- hist.plot + geom_point(data = hist.comp, aes(x = centroid, y = data,
                                                          colour = Output, group = Output, size = 3)) + geom_path(data = hist.comp,
                                                                                                                  aes(x = centroid, y = data, colour = Output, group = Output)) + guides(size = FALSE)

hist.plot + xlab("Year") + ylab("Annual average temperature in deg C") + theme_bw()

# 
# 
# options(kmlpath = "kmltemp")
# 
# 
# 
# # create dataframe with mapping data to plot
# eu_basin <- create_map_df(Eur_basin)
# 
# ### Get some data
# eu_basin_dat <- get_ensemble_temp(Eur_basin, "annualanom", 2080, 2100)
# ## Subset data to just one scenario, and one percentile so we have 1 piece
# ## of information per spatial unit
# eu_basin_dat <- subset(eu_basin_dat, eu_basin_dat$scenario == "a2" & eu_basin_dat$percentile ==
#                          50)
# 
# # link map dataframe to climate data
# 
# eu_map <- climate_map(eu_basin, eu_basin_dat, return_map = T)
# eu_map + scale_fill_continuous("Temperature \n anomaly by 2080", low = "yellow",
#                                high = "red")
