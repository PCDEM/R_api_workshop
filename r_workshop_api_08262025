#'**************FLMS 2025 R WORKSHOP - USING APIs WITH R*****************
#'This script provides code to follow along with the FLMS 2025 R workshop for
#'the section related to using APIs in R. It will be more beneficial to you to 
#'code along with presentation but you can use this file as a guide and to keep
#'for future use.


# Install relevant packages
install.packages(c('httr2','xml2','jsonlite','dplyr','httpuv'))

#----------Advice Slip API-------------

# load packages
library(httr2)
library(jsonlite)
library(httpuv)

# Define the API endpoint
advice_url <- "https://api.adviceslip.com"

# Create a request to the API
req <- request(advice_url)

# Show what will be sent to the server without actually sending it
req |>
  req_dry_run()

# Add the query to the path and send the request
resp <- req |>
  req_url_path_append("advice") |>
  req_perform()
resp

# Inspect the output in more detail
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

# Notice that the response is a list and can be accessed using list notation (double $)
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

# We can get the results for a specific advice string by specifying it in the 
# url path
resp_advice_id5 <- req |>
  req_url_path_append("advice/5") |>
  req_perform()
resp_advice_id5

# Now we can parse the response as usual
advice_id5 <- resp_advice_id5 |>
  resp_body_string() |>
  fromJSON()
advice_id5$slip$advice

#----------USGS NAS API-------------

# define the API endpoint
nasAPI <- 'http://nas.er.usgs.gov/api/v2/occurrence'

# Call the API, set the search query, and define query parameters
nasReq <- request(nasAPI) |>
  req_url_path_append("search") |>
  req_url_query(
    state = "FL",
    county = "Pinellas"
  ) |>
  req_perform()

# Parse the API response and pull the results from the list
nasData <- nasReq$body |>
  rawToChar() |>
  fromJSON() |>
  
# Check the names of the response to see what the name of the data is
names(nasData)

# Inspect the data structure
str(nasData$results)


#---------Your Turn---------

# 1) Install and load the packages httr2 and jsonlite if not done already

# 2) Use the USGS NAS API to request data for your county

# 3) Read the documentation to see the available options for the "group"
#    parameter and set the query to one of those values

# 4) Send the request and inspect the results



#---------FDEP WIN API----------

# load packages
library(httr2)
library(jsonlite)
library(dplyr)

# Define the API endpoint
url <- 'https://prodapps.dep.state.fl.us/dear-watershed'

# Make the request to the API with the specified parameters
resp <- httr2::request(url) |>
  httr2::req_url_path_append('result-activities') |>
  httr2::req_url_query(
    `ActivityStartDateFrom (>=)` = '2024-03-11',
    `ActivityStartDateTo (<=)` = '2024-03-15',
    `Organization ID` = '21FLPDEM',
    page = 0,
    size = 500,
    sort = 'resultKey,ASC'
  ) |>
  httr2::req_perform()
resp

# Parse the response
depResp <- resp$body |>
  rawToChar() |>
  jsonlite::fromJSON() 
names(depResp)

# Reformat the data and select relevant columns
depData <- depResp$content

# Inspect the data more closely
str(depData)

# This WIN API only returns 500 results per page. You can loop over the page numbers
# to get data from each page.

# Initialize an empty list to fill and set the initial page number
allResults <- list()
page <- 0

# Start while loop so the page number will increase until no data is returned 
while (TRUE) {
  # Start the request
  resp <- httr2::request(url) |>
    httr2::req_url_path_append('result-activities') |>
    httr2::req_url_query(
      `ActivityStartDateFrom (>=)` = '2024-03-11',
      `ActivityStartDateTo (<=)` = '2024-03-15',
      `Organization ID` = '21FLPDEM',
      page = page,
      size = 500,
      sort = 'resultKey,ASC'
    ) |>
    httr2::req_perform()
  
  # Parse the response
  depResp <- resp$body |>
    rawToChar() |>
    jsonlite::fromJSON() 
  
  # Check if data is returned from the request and if not, stop the loop,
  # otherwise add the results to the empty list
  if (is.null(nrow(depResp$content))) {
    break
  } else {
    allResults <- append(allResults, list(depResp$content))
  }
  
  # Increase the page number
  page <- page + 1
}

# Combine all the reults
df <- bind_rows(allResults)
str(df)
