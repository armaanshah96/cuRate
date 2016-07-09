#' @param list_names String of Twitter handles. Each handle starts with '@' symbol and is separated by a space.
#' @return returns a vector of the top tweets of the day from each handle. Each tweet corresponds to the index of the inputted Twitter handles
#' get_tweets("@realDonaldTrump @CNN @FoxNews")
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
  
  #transform input string into a character vector and strip @ from beginning 
  list_names <- strsplit(list_names, "\\s")[[1]]
  list_names <- gsub("[,@]","", list_names)
  list_names <- list_names[list_names != ""]
  
  #error check handle names 
  clean_list = c();
  for (i in 1:length(list_names)) {
    if (verify_handle(list_names[i])) 
      clean_list <- c(clean_list, list_names[i])
  }
  
  #create list of best tweets
  best <- lapply(clean_list, FUN = function(x) {best_tweet(x)})
  
  #return list?
  return (best)
}

#' @param handle Twitter handle provided as a character vector. 
#' @return returns the tweet that was most popular for the day 
best_tweet <- function(handle) {

  #read in timeline for username passed in as handle arg
  tweets <- userTimeline(handle, 300)
  
  #filter tweet history for only "yesterday's" tweets (assumes call in morning)
  tweets <- Filter(function(x) {x$created > as.POSIXct(today() - 1)}, tweets)
  
  #return a warning message if a handle has no tweets
  if (is.null(tweets[1][[1]])) {
    no_tweets <- paste(handle, "has not posted any tweets.", sep = " ")
    return(no_tweets)
  }
  
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
#' verify_handle("nasa")
verify_handle <- function(handle) {
  tryCatch({
    lookupUsers(handle)
    return(TRUE)
  }, error = function(e) {
    message(paste("Warning:", handle, "is not a valid handle. It was removed from your list of selections."))
    return(FALSE)
  }, finally = {}
  )
}


