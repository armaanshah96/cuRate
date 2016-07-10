library(slackr)
token <- 'token here'
slackr_setup(channel = "#bot-test", username = "testbot", api_token = token)
slackr_bot(message = "test")
library(RCurl)
library(jsonlite)

message <- get_tweets("@cnn, @realdonaldtrump, @wired, ")

text_slackr(message)


test1 <- toJSON()

payload={"text": "This is a line of text in a channel.\nAnd this is another line of text."}

slackr_bot(test1,
            channel = "#bot-test",
            username = "hypeBot",
            incoming_webhook_url = "https://hooks.slack.com/services/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")



ggslackr(ggplot(iris, aes(x = iris$Sepal.Width, y = iris$Sepal.Length))) + geom_point()

library(ggplot2)

graph <- ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length)) + geom_point(color = as.integer(as.factor(iris$Species)))
graph

ggslackr(graph, channels = "#bot-test", copy = TRUE)
