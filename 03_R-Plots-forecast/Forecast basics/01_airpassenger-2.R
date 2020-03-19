library(forecast)
library(dygraphs)

AirPassengers %>%
  stlf(lambda = 0, h = 36) %>%
  {cbind(actuals=.$x, forecast_mean=.$mean)} %>%
  dygraph()