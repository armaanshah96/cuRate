#!/usr/local/bin/Rscript

#' @param list_names String of Twitter handles. Each handle starts with '@' symbol and is separated by a space.
#' @return returns a vector of the top tweets of the day from each handle. Each tweet corresponds to the index of the inputted Twitter handles
#' @example 
#' get_tweets("@cnn, @foxnews, @realdonaldtrump, @hillaryclinton")
get_tweets <- function(list_names = "@cnn, @foxnews, @realdonaldtrump, @hillaryclinton") {
  
  #load twitteR package
  library(twitteR)
  library(dplyr)
  library(lubridate)
  library(stringr)
  
  #Set up Twitter REST api access (from Graham's account):
  consumer_key = ""
  consumer_secret = ""
  access_token = ""
  access_secret = ""
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
  return (create_message(best))
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
    no_tweets <- paste(paste("@", handle, sep = ""), "has not posted any tweets in the last day.", sep = " ")
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

#' @param tweets List of accounts' best tweet' objects from twitteR package 
#' @return character vector formatted to be sent to slack channel via bot
create_message <- function(tweets){
  
  #create blank message
  message <- ""
  
  #for all usernames in list:
  for (c in tweets){
    #if username hasn't tweeted in past day, add error message to message 
    if(class(c) == 'character'){
      message <- paste(message, paste("\n", c, sep = ""), sep ="")
    }
    
    #if user has tweeted, add username and text of best tweet to message 
    else{
      username <- paste("\n@", c$screenName, sep = "")
      username <- paste(username, ": ", sep = "")
      message <- paste(message, username, sep = "")
      message <- paste(message, paste("\n", c$text, sep = ""))
    }
    
    #after every type of message, seperate with blank line for readability 
    message <- paste(message, "\n", sep ="")
  }
  
  #return the message string in its entirity
  return(message)
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

#' @param list of twitter handles to use in 'cuRate' functionality 
#' @example 
#' curate("@cnn, @foxnews, @realdonaldtrump, @hillaryclinton")
curate <- function(list){
  #import needed package
  library(slackr)
  
  #set slack api token 
  token <- ''
  
  #set up slack functionality
  slackr_setup(channel = "#curate", username = "cuRate", api_token = token,  icon_emoji = ":mag:")
  
  #send result of get_tweets with desired list to slack channel chosen in call above 
  text_slackr(get_tweets(list))
}

#script to run w/ cron automation
curate("@iXperienceCT, @datawookie, @wuthemasses, @hadleywickham, @elonmusk, @theeconomist, @wired, @cnn, @foxnews, @msnbc, @cspan")


