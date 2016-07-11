#cuRate
####*Graham Place, Armaan Shah, & Maggie Lou*
#####*11 July 2016*

***
####Overview
cuRate is a Slack bot that automatically curates your Twitter feed. 

Get the relevant info for your team sent straight to the channel of your choice! 

cuRate reads the desired users' tweets from the past day, and uses an algorithm to score each tweet based on how many Twitter users favorited and retweeted. Only the best tweet from each account will be sent to the Slack channel. 

***
####Current Version
The current version (1.0) requires users of cuRate to download the cuRate.R script, hard-code their own Slack team tokens and Twitter API keys, set a list of desired Twitter users to follow, and set up a Cron job to automate the bot on their local machine. 

***
####Future Releases
Future versions of cuRate will allow user interactivity within Slack, starting with slash command implementation and eventually progressing to a full-blown bot user.

***
####Installation/Set-Up
Follow these steps to set up the current version of cuRate in your Slack team:

1) Download the [cuRate.R script](https://github.com/armaanshah96/cuRate/blob/master/cuRate.R)

2) Set up the [Slack](https://api.slack.com/tokens) and [Twitter](https://dev.twitter.com/rest/public) tokens/api keys specific to your accounts by entering them into the following fields of the cuRate.R script:
```{r}
# Set up Twitter REST api access:
consumer_key = ""
consumer_secret = ""
access_token = ""
access_secret = ""
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
```
```{r}
 # Set slack api token 
 token <- ''
```
3) Enter the name of the Slack channel you would like cuRate to post in. The channel doesn't have to be public, but the user who owns the api key must have access to it. For example, posting in #curate would look like this:
```{r}
slackr_setup(channel = "#curate", username = "cuRate", api_token = token,  icon_emoji = ":mag:")
```
4) In the last line of the script, enter the Twitter handles you would like cuRate to use as args in the call to the curate() function: 
```{r}
curate("@theeconomist, @wired, @cnn, @foxnews, @msnbc, @cspan")
```
5) Set up a [Cron job](http://www.techradar.com/how-to/computing/apple/terminal-101-creating-cron-jobs-1305651) to automate the running of cuRate:
   
 a. Run 'which Rscript' in the terminal. The result will look like: 

  ```
  /usr/local/bin/Rscript
  ```
  
 b. Copy that result into the **first** line of cuRate.R, and prepend with #!:

  ```
 #!/usr/local/bin/Rscript
  ```
  
c. Navigate within the terminal to the directory where cuRate.R is stored and run:
  ```
 chmod +x cuRate.R
  ```
  
d. In terminal, run the following command: 
  ```
  env EDITOR=nano crontab -e
  ```
e. A new Cron job editor will open. Use [Cron * Syntax](http://www.techradar.com/how-to/computing/apple/terminal-101-creating-cron-jobs-1305651) to set the time cuRate will run. For example, to run cuRate every day at 10 am, use:

```0 10 * * * ```
    
f. Following the * scheduling args, input the full file path to cuRate.R. For example:  

```
/Users/Graham/Desktop/OneDrive/School/iXperience/cuRate/cuRate.R
  ```

g. Done! To exit, use the following series of commands:  ```cmd o, enter, cmd x ```
    