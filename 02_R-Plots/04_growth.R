#require(data.table)

#library(tibble)
library(dplyr)
library(ggplot2)
#library(forecast)
#library('TStools')
library("reshape2") #for shaping long table e.g.

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

DATALOG <- read.csv("../01_ETLOutput-CSV/03_complete-data-pop-days100.CSV")

moddat = DATALOG[,c('date', 'country', 'Confirmed')]; 


data <- moddat[moddat$country == "Germany" 
               #| moddat$country == "Italy"
               ,]


#data$date <- as.POSIXct(data$date)

data<-data %>%
  group_by(country) %>%
  arrange(date) %>%
  mutate(diff = Confirmed - lag(Confirmed, default = first(Confirmed))) %>%
  mutate(diffpercent = Confirmed / lag(Confirmed, default = first(Confirmed)) -1 )  

#data<-data %>%
#  group_by(country) %>%
#  arrange(date) %>%
#  mutate(diffpercent = Confirmed / lag(Confirmed, default = first(Confirmed)) -1 )



data$date<-as.Date(data$date)

#Berechnung der Tage bis Kapzität ereicht------------------------------
lastdiff <- last(data$diff)
lastpercent <- last(data$diffpercent)
capa = 40000

last_growth = last(data$diffpercent)


mean_growth = mean(data$diffpercent)

days2capa = log(capa/lastdiff, base = 1+mean_growth)
days2capa_last = log(capa/lastdiff, base = 1+last_growth)
#----------------------------------------------------------------------
days2plot = round(days2capa,0)+1

#data$ma <- cmav(data$diffpercent, outplot=1)
#print(cma)

#add calulated numbers---------------------------------------------------------------------------------------

startdate <- (last(data$date))# For plotting intersection

#### Prediction average ------------------------------------------------------------------------------------
newdate <- (last(data$date))
prediction <- (last(data$diff))

prediction_last <- (last(data$diff))

newset <- data.frame(date=newdate, country="Germany", predicted=prediction, predicted_last=prediction_last)
print(newset)
data <- dplyr::union_all(data,newset)

n<-1
while (n<=days2capa+1) {
  print(n)
  newdate <- (last(data$date)+1)

  prediction <- (last(data$predicted)*(mean_growth+1))
  prediction_last <- (last(data$predicted_last)*(last_growth+1))
  newset <- data.frame(date=newdate, country="Germany", predicted=prediction, predicted_last=prediction_last)
  print(newset)
 
  data <- dplyr::union_all(data,newset)
  print(data)
  n=n+1
}

#### Prediction last growth rate----------------------------------------------------------------





# Design Plot ------------------------------------------------------------------------------

number<-ggplot(data, aes(date)) + 
  geom_line(aes(y = diff, colour = "Obvserved")) + 
  geom_line(aes(y = predicted, colour = "Predicted (Mean)"))+
  geom_line(aes(y = predicted_last, colour = "Predicted (Last)"))+
  scale_colour_discrete("Data")+
  scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE))+
  geom_hline(yintercept=capa, linetype="dashed", color = "red")+
  geom_vline(xintercept=(startdate+days2capa), linetype="dashed", color = "red")+
  labs(title= "COVID-2019 | GERMANY | Number of New Confirmed Cases per Day",
       subtitle = paste("Last dataset: ",lastdate," | Mean (last) Days until Limit: "
                        , round(days2capa,digits = 2)
                        ," (",round(days2capa_last,digits = 2),")","\nMean (last) Growth per Day: ",(round(mean_growth*100,1))," %"," (",(round(last_growth*100,1))," %)",sep=""),
       y="# of New Cases per Day", 
       x = "Date",
       caption=paste("@muellertag | Created at ",format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
                     "\n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data"))



plot(number)

#Plot exportieren--------------------------------------------------------------

plot_path <- 'plot-export/number_of_new_cases/'
plot_title <- '_number_of_new_cases.pdf'

ggsave(
  #paste( "plot-export/",Sys.Date(),"-03_mortality.pdf", sep=""),
  paste(plot_path,lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),plot_title,sep=""),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 1,
  width = 297, height = 210, units = "mm",
  dpi = 300,
  limitsize = TRUE
)

#Plot exportieren--------------------------------------------------------------
ggsave(
  #paste( "plot-export/",Sys.Date(),"-03_mortality.pdf", sep=""),
  paste(plot_path,'100x50_',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),plot_title,sep=""),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 2,
  width = 100, height = 50, units = "mm",
  dpi = 300,
  limitsize = TRUE
)