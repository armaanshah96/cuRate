#' @param list_names Vector of Twitter handles. Each element of the list is one handle starting with '@' symbol.
#' @return returns a vector of the top tweets of the day from each handle. Each tweet corresponds to the index of the inputted Twitter handles
#' get_tweets(c("@DonaldTrump","@CNN","@FoxNews"))
#' 
get_tweets <- function(list_names) {
  # call best_tweet on each handle
}

#' @param handle Twitter handle provided as a character vector. Handle begins with '@' symbol.
#' @return returns the tweet that was most popular for the day 
best_tweet <- functions(handle) {
  # max sure to parse through only tweets of the current day (Sys.Date maybe)
}
