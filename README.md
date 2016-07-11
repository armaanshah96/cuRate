---
title: "cuRate"
author: "Graham Place, Armaan Shah, & Maggie Lou"
date: "11 July 2016"
output: html_document
---

#Overview
cuRate is a Slack bot that automatically curates your Twitter feed. 

Get the relevant info for your team sent straight to the channel of your choice! cuRate reads the desired users' tweets from the past day, and uses an algorithm to score each tweet based on how many Twitter 


#Current Version
The current version (1.0) requires users of cuRate to download the cuRate.R script, hard-code their own slack team tokens and Twitter API keys, set a list of desired Twitter users to follow, and set up a Cron job to automate the bot on their local machine. 

#Future Releases
Future versions of cuRate will allow user interactivity within slack, starting with slash command implementation and eventually progressing to a full-blown bot user.

#Installation/Set-Up
Follow these steps to set up the current version of cuRate in your slack team:



```{r}
x = seq(-5, 5, 0.1)
```