---
title       : TwitterApp
subtitle    : Sentiment Analysis of Tweets
author      : Nikolaos Lamprou
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
logo        : twitter.jpg
ext_widgets : {rCharts: libraries/nvd3}
---



## TwitterApp - What is it?

This application allows the user to:

- Search for topics on Twitter
- Perform a sentiment analysis and assign a score to each tweet
- Display graphical output showing sentiment change
- Display geographical distribution of tweets on a map

--- .class #id 

## TwitterApp - Using the App

Using the Application is simple:

1. Enter a term to be analyzed (eg #Coursera)
1. Enter/Change remaining search criteria 
2. Press search
3. Navigate through results using navigation bar

An example tweet:



```
##        screenName
## 2 alberto_rusconi
##                                                         text
## 2 It's time for week 4: #Python #functions- #PR4E  #Coursera
```

--- .class #id

## TwitterApp - How it Works and Output

The App works be performing the following steps:

1. Using the developer Twitter API tweets that match search criteria are returned
2. Data converted from JSON format to a data frame
3. Text from tweets is parsed and passed through a sentiment function
4. Each tweet is scored depending on number of positive or negative words it contains
5. An hourly aggregation is displayed and the location of tweets on a map.

--- .class #id

## TwitterApp - Further Work

There are a number of ideas for improving and enhancing the Apps functionality

- Improve the sentiment function - Perhaps use machine learning algorithms
- Allow flexible reporting - eg aggregation per hour/day etc
- Show tweet text on map
- Allow comparison of searched terms

--- 


