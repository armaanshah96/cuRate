#' @param list_names Vector of Twitter handles. Each element of the list is one handle starting with '@' symbol.
#' @return returns a vector of the top tweets of the day from each handle. Each tweet corresponds to the index of the inputted Twitter handles
#' get_tweets(c("@RealDonaldTrump","@CNN","@FoxNews"))
#' 
get_tweets <- function(list_names) {
  
  #load twitteR package
  library(twitteR)
  library(dplyr)
  library(lubridate)
  library(stringr)
  
  #remove @ from handles 
  list_names <- gsub("@", "", list_names)
  
  #turn string list into a list of length 1: chr vector of handles 
  list_names <- str_split(list_names, ", ")
  
  #error check handle names 
  clean_list = c();
  for (i in 1:length(list_names)) {
    if (filter(list_names[i])) 
      clean_list <- c(clean_list, list_names[i])
  }
  
  #create list of best tweets
  best <- lapply(clean_list[[1]], FUN = function(x) {best_tweet(x)})
  
  #return list?
  return (best)
}

#' @param handle Twitter handle provided as a character vector. Handle begins with '@' symbol.
#' @return returns the tweet that was most popular for the day 
best_tweet <- function(handle) {

  #read in timeline for username passed in as handle arg
  tweets <- userTimeline(handle, 300)
  
  #filter tweet history for only "yesterday's" tweets (assumes call in morning)
  tweets <- Filter(function(x) {x$created > as.POSIXct(today() - 1)}, tweets)
  
  #pull RT and Fav data per tweet 
  rtVec <-  sapply(tweets, FUN = function(x) {x$getRetweetCount()})
  favVec <-  sapply(tweets, FUN = function(x) {x$getFavoriteCount()})
  
  #identify 'best' tweet by weighting rt/fav and creating tweetScore
  tweetScore <- ((2 * rtVec) + favVec)
  
  #return the list item with the index corresponding to the max tweet score
  return (tweets[[which.max(tweetScore)]])
}



#' @param handle Twitter handle provided as a character vector. Does not begin with the '@' symbol.
#' @return Returns TRUE if the handle was valid, FALSE if that user does not exist on Twitter.
#' @example 
#' filter("nasa")
filter <- function(handle) {
  tryCatch({
    lookupUsers(handle)
    return(TRUE)
  }, error = function(e) {
    message(paste("Warning:", handle, "is not a valid handle. It was removed from your list of selections."))
    return(FALSE)
  }, finally = {}
  )
}


