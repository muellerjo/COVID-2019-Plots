library(forecast)
AirPassengers %>%
  stlf(lambda = 0, h = 100) %>%
  autoplot()

print(AirPassengers)