library(shiny)
library(twitteR)
library(ROAuth)
library(plyr)
library(stringr)
library(tm)
library(leaflet)
library(ggplot2)
library(reshape2)

load("twitter authentication.Rdata")
registerTwitterOAuth(Cred)
source("sentiment.R")

uk <- c("54.5","-4","330")
france <- c("47","2","290")
greece <- c("38.8","23.8","192")
usa <- c("41","-96","1480")

shinyServer(function(input, output, session) {
    
    
    tweetSearch<-reactive({
        
        input$searchButton
        
        isolate({
            if(input$search != '' ){
                num<-input$maxtweets
                if(input$coords == "UK" ){coords<-uk}
                if(input$coords == "France" ){coords<-france}
                if(input$coords == "Greece" ){coords<-greece}
                if(input$coords == "USA" ){coords<-usa}
                geo<-paste0(coords[1],",",coords[2],",",coords[3],"mi")
                search <- searchTwitter(input$search,n=num,cainfo="cacert.pem",since=as.character(input$dateRange[1]),until=as.character(input$dateRange[2]),geocode=geo)
                tweets.df <- twListToDF(search) 
                #Score all tweets
                tweets.df$text <- as.factor(tweets.df$text) 
                score <- score.sentiment(tweets.df$text, pos.words,neg.words)
                tweets.df$score <- score$score
                tweets.df$color <- rep("blue",nrow(tweets.df))
                for(i in 1:nrow(tweets.df)){
                    if( tweets.df[i,"score"] > 0){
                        tweets.df[i,"color"] <- "green"
                    }
                    else if (tweets.df[i,"score"] < 0){
                        tweets.df[i,"color"] <- "red"
                    }
                }
                tweets.df 
            }
        })
        
    })
    
    output$outSearch <- renderText(print(paste("Searching Twitter for terms: ", input$search)))
    output$outDate1 <- renderText(print(paste("In the date range: "))) 
    output$outDate2 <- renderText(print(paste( input$dateRange[1], "to" ,input$dateRange[2]  )))
    output$outLocation <- renderText(print(paste("Tweeted from: ", input$coords)))
    output$outMaxtweets <- renderText(print(paste("And returning at most: ", input$maxtweets, "tweets")))
    output$outNum <- renderText({
        input$searchButton
        
        isolate({
        validate(
            need(input$searchButton > 0 & input$search != "", "Enter valid term and press Search!")
        )
        print(paste("Returned ", nrow(tweetSearch()), "tweets"))
        })
        })
    
    output$outSentP <- renderText({
        input$searchButton
        isolate({
            validate(
                need(input$searchButton > 0 & input$search != "", "")
            )
            tweets.df <- tweetSearch()
            print(paste("Positive tweets:", nrow(tweets.df[tweets.df$score > 0,])))
        })
    })
    output$outSentN <- renderText({
        input$searchButton
        isolate({
            validate(
                need(input$searchButton > 0 & input$search != "", "")
            )
            tweets.df <- tweetSearch()
            print(paste("Negative tweets:", nrow(tweets.df[tweets.df$score < 0,])))
        })
    })
    output$outSentNu <- renderText({
        input$searchButton
        isolate({
            validate(
                need(input$searchButton > 0 & input$search != "", "")
            )
            tweets.df <- tweetSearch()
            print(paste("Neutral tweets:", nrow(tweets.df[tweets.df$score == 0,])))
        })
    })
    
    
    output$tweettable <- renderDataTable({
        validate(
            need(input$searchButton > 0, "Please enter a valid search term")
        )
        tweets.df <- tweetSearch()
        tweets.df[,c("screenName","created","text","retweetCount","score","color","latitude","longitude")]
        
    })
    
    
    output$sentHist1 <- renderPlot({
        validate(
            need(input$searchButton > 0, "Please enter a valid search term")
        )
        tweets.df <- tweetSearch()
        hist(tweets.df$score,col="#c0deed", xlab="Score", main="Score Distribution of Tweets")
    })
    output$sentHist2 <- renderPlot({
        validate(
            need(input$searchButton > 0, "Please enter a valid search term")
        )
        tweets.df <- tweetSearch()
        tweets.df$created <- strftime(tweets.df$created, format="%y-%m-%d %H:00")
        
        data_melt<- melt(tweets.df,id=c("created","color"))
        data_cast<-dcast(data_melt, created + color ~ variable)
        data_cast$color <- as.factor(data_cast$color)
        levels(data_cast$color)[levels(data_cast$color)=="green"] <- "Positive"
        levels(data_cast$color)[levels(data_cast$color)=="red"]   <- "Negative"
        levels(data_cast$color)[levels(data_cast$color)=="blue"]   <- "Neutral"
        data_cast$color <- factor(data_cast$color, levels = c("Negative","Positive","Neutral"))
        ggplot(data_cast, aes(created,score)) + geom_bar(aes(fill=color), stat="identity") + facet_grid(color ~ .) +
            xlab("Date-Time") + ylab("Number of Tweets") +
            ggtitle("Hourly Variation of Tweets") + theme(axis.text.x = element_text(angle = 70,vjust = 1, hjust=1)) + theme(axis.text=element_text(size=6))
        #+ geom_point(aes(colour = factor(color)))
       # qplot(created,score,data=data1_cast,color=color,geom = "smooth")
    })
    
    map <- createLeafletMap(session, "map")
    
    
    session$onFlushed(once=TRUE, function() {
        paintObs <- observe({

            validate(
                need(input$searchButton >= 0, "Please enter a valid search term")
            )
            #   sizeBy <- input$size
            
            tweets.df <- tweetSearch()
            colorfilt <- input$color
            
            
            
            # Clear existing circles before drawing
            map$clearShapes()
            
            for (j in 1:nrow(tweets.df)) {
                
                tweetchunk <- tweets.df[j,]
                 
                if(colorfilt=="pos" & tweetchunk$color=="green"){
                    map$addCircle(
                        lat=tweetchunk$latitude, lng=tweetchunk$longitude,
                        radius=1000,eachOptions=list(color="green"))
                }
                else if(colorfilt=="neg" & tweetchunk$color=="red"){
                    map$addCircle(
                        lat=tweetchunk$latitude, lng=tweetchunk$longitude,
                        radius=1000,eachOptions=list(color= "red"))
                }
                else if(colorfilt=="all"){
                    map$addCircle(
                        lat=tweetchunk$latitude, lng=tweetchunk$longitude,
                        radius=1000,eachOptions=list(color=tweets.df[j,"color"]))
                }
            }
        })
        
        session$onSessionEnded(paintObs$suspend)
    })
    
    
    output$mapKey <- renderUI({
        
        tags$table(class = "table",
                   tags$thead(tags$tr(
                       tags$th("Color"),
                       tags$th("Sentiment")
                   )),
                   tags$tbody(
                       tags$tr(
                           tags$td(span(style = sprintf(
                               "width:1.1em; height:1.1em; background-color:%s; display:inline-block;",
                               "blue"
                           ))),
                           tags$td("Neutral")
                       ),
                       tags$tr(
                           tags$td(span(style = sprintf(
                               "width:1.1em; height:1.1em; background-color:%s; display:inline-block;",
                               "green"
                           ))),
                           tags$td("Positive")
                       ),
                       tags$tr(
                           tags$td(span(style = sprintf(
                               "width:1.1em; height:1.1em; background-color:%s; display:inline-block;",
                               "red"
                           ))),
                           tags$td("Negative")
                       )
                      
                   )
        )
    })
    
    
}
)