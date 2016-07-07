#' @param list_names Vector of Twitter handles. Each element of the list is one handle starting with '@' symbol.
#' @return returns a vector of the top tweets of the day from each handle. Each tweet corresponds to the index of the inputted Twitter handles
#' get_tweets(c("@DonaldTrump","@CNN","@FoxNews"))
#' 
get_tweets <- function(list_names) {
  
  #load twitteR package
  library(twitteR)
  library(dplyr)
  library(lubridate)
  
  #Set up Twitter REST api access (from Graham's account):
  consumer_key = "key"
  consumer_secret = "secret"
  access_token = "token"
  access_secret = "secret"
  setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
  
  #create list of best tweets
  best <- lapply(list_names, FUN = function(x) {best_tweet(x)})
  
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



