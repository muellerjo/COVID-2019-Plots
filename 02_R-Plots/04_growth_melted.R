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

#read.csv(file="result1", sep=" ", colClasses=c("NULL", NA, NA))

moddat = DATALOG[,c('date', 'country', 'Confirmed')]; 


data <- moddat[moddat$country == "Germany" 
               #| moddat$country == "Italy"
               ,]

#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union


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
days2capa = log(capa/lastdiff, base = 1+lastpercent)
#----------------------------------------------------------------------
days2plot = round(days2capa,0)+1

#data$ma <- cmav(data$diffpercent, outplot=1)
#print(cma)
mean_growth = mean(data$diffpercent)

#add calulated numbers---------------------------------------------------------------------------------------

newdate <- (last(data$date)+1)
prediction <- (last(data$diff)*(mean_growth+1))
newset <- data.frame(date=newdate, country="Germany", predicted=prediction)
print(newset)
data <- dplyr::union_all(data,newset)

n<-1
while (n<=days2capa) {
  print(n)
  newdate <- (last(data$date)+1)
  #preddates <- data.frame(newdate)
  
  #print(preddates)
  
  prediction <- (last(data$predicted)*(mean_growth+1))
  newset <- data.frame(date=newdate, country="Germany", predicted=prediction)
  print(newset)
  #dplyr::bind_cols(data,preddates)
  #dplyr::union_all(data, data.frame(date=last(data$date)+1, country='Germany', predicted = last(data$Confirmed)*(mean_growth+1)))
  
  #data <- dplyr::full_join(data,newset, by='date','country')
  data <- dplyr::union_all(data,newset)
  print(data)
  n=n+1
}


data_long = data[,c('date', 'country', 'diff','predicted')]; 

data_long2 <- melt(data_long, id=c("date","country"))

#print(data_long)

number<-ggplot(data_long2, aes
               (x=date, 
                 y=value, 
                 group=variable, 
                 color=variable))+
  scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE))+
  geom_line(aes())+
  geom_hline(yintercept=40000, linetype="dashed", color = "red")+
  labs(title= "COVID-2019 | Number of New Confirmed Cases per Day",
                         subtitle = paste("Last dataset: ",lastdate," | Days until limit: ", round(days2capa,digits = 2),sep=""),
                         y="# of New Cases per Day", 
                         x = "Date",
                         caption="@muellertag \n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")


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