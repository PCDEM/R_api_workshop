library(httr)
library(jsonlite)
library(tidyverse)

start <- seq.Date(as.Date('2016-01-01'),as.Date('2024-12-26'), by = 'day') 
dat <- list()

for (i in seq(1,length(start),5)){
  print(paste('Working on',as.Date(start[i]),'to',as.Date(start[i+5])))
  url <- paste0('https://prodapps.dep.state.fl.us/dear-watershed/result-activities?ActivityStartDateFrom%20%28%3E%3D%29=',as.Date(start[i]),'&ActivityStartDateTo%20%28%3C%3D%29=',as.Date(start[i+5]),'&Organization%20ID=21FLPDEM&page=0&size=500&sort=resultKey%2CASC')
  response <- GET(url, verbose())
  data <- content(response, as = "text", encoding = "UTF-8")
  final <- fromJSON(data)$content 
  dat <- append(dat, list(final))
}

dat2 <- bind_rows(dat) |>
  arrange(monitoringLocId) |>
  select(
    organizationName,
    monitoringLocId,
    activityStartDate,
    activityDepth,
    depAnalytePrimaryName,
    depResultValue,
    depResultUnit
  )
View(dat2)


# url <- 'https://prodapps.dep.state.fl.us/dear-watershed/result-activities?ActivityStartDateFrom%20%28%3E%3D%29=2022-02-01&ActivityStartDateTo%20%28%3C%3D%29=2022-02-28&Organization%20ID=21FLPDEM&page=0&size=500&sort=resultKey%2CASC'
# 
# response <- GET(url, verbose())
# 
# data <- content(response, as = "text", encoding = "UTF-8")
# 
# final <- fromJSON(data)$content 
# 
# unique(final$depAnalytePrimaryName)
# nrow(final)
# final$activityStartDate |>
#   sort()
# 
# View(final)
# 
# dat <- append(list, list(final))

