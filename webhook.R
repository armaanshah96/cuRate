library(slackr)
token <- "xoxb-57717822598-VZlNktXv8KM5qxXT9VY3GxzF"
slackr_setup(channel = "#bot", username = "testbot", api_token = token)
slackr_bot(message = "test")
library(RCurl)

slackr_bot( "message here",
            channel = "#bot",
            username = "hypeBot",
            incoming_webhook_url = "https://hooks.slack.com/services/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")

