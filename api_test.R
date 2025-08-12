library(httr2)
library(jsonlite)
library(tidyverse)

# Define the API endpoint
advice_url <- "https://api.adviceslip.com"

# Create a request to the API
req <- request(advice_url)
req

# Show what will be sent to the server without actually sending it
req |> 
  req_dry_run()

# Complete the full path to the API endpoint
req |>
  req_url_path_append("advice")

# Add the query to the path and send the request
resp <- req |>
  req_url_path_append("advice") |>
  req_perform()
resp

# Inspect the api response more closely
class(resp)
names(resp)
resp$body
class(resp$body)

# Convert the raw characters into 
body_json <- rawToChar(resp$body)
body_json

# Convert the raw vector into text
slip_advice <- fromJSON(body_json)
slip_advice

class(slip_advice)

# Extract the advice string from the list
slip_advice$slip$advice

# We can also extract the response as a string, which is a more straightforward
# way of getting the data
resp |>
  resp_body_string()

# Now parse the JSON text from the string
resp |>
  resp_body_string() |>
  fromJSON()

# If we want specific data to be returned from the API then we need to define
# some parameters in the endpoint so the server knows what we are looking for
# and what to return
resp_advice_id5 <- req |>
  req_url_path_append("advice/5") |>
  req_perform()
resp_advice_id5

# Extract the response from the body
advice_id5 <- resp_advice_id5 |>
  resp_body_string() |>
  fromJSON()
advice_id5

#-------------------------------USGS NAS API------------------------------------

# Now lets look at some real data. We'll use the USGS Nonindigenous Aquatic Species
# API to extract data related to invasive aquatic speices.

# First we should inspect the USGS API page so we can see the endpoint and the
# parameters that we can define to extract data https://nas.er.usgs.gov/api/documentation.aspx

# Now we can define the USGS NAS endpoint
nasAPI <- 'http://nas.er.usgs.gov/api/v2/occurrence'

nasReq <- request(nasAPI) |>
  req_url_path_append("search") |>
  req_url_query(
    state = "FL",
    county = "Pinellas"
  ) |>
  req_perform()
nasReq

nasData <- nasReq$body |>
  rawToChar() |>
  fromJSON()
nasData

n



