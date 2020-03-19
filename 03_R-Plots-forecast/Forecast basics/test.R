library(forecast)


this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)


DATALOG <- read.csv("../../01_ETLOutput-CSV/03_complete-data-pop-days100.CSV"
                    , c("date", "country", "Confirmed")
                    )

#read.csv(file="result1", sep=" ", colClasses=c("NULL", NA, NA))

moddat = DATALOG[,c('date', 'country', 'Confirmed')]; 

germany <- moddat[moddat$country == "Germany",]


#stlf(lambda = 0, h = 100) %>%
#autoplot()

#print(germany)
