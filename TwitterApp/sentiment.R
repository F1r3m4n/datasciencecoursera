

score.sentiment <- function(text,pos.words,neg.words,.progress='none')
{require(plyr)
 require(stringr)
 #Split list, apply function, and return results in an array.
 scores <- laply(text, function(text,pos.words,neg.words){
     text <- gsub('[[:punct:]]','',text)
     text <- gsub('[[:cntrl:]]','',text)
     text <- gsub('\\d+:','',text)
     text <-tolower(text)
     
     word.list <- str_split(text, '\\s+')
     words <- unlist(word.list)
     
     #Compare to positive or negative words
     
     pos.matches <- match(words, pos.words)
     neg.matches <- match(words, neg.words)
     
     pos.matches <- !is.na(pos.matches)
     neg.matches <- !is.na(neg.matches)
     
     score <- sum(pos.matches) - sum(neg.matches)
     return(score)
 }, pos.words, neg.words, .progress=.progress
 )
 scores.df <- data.frame(score=scores,text=text)
 return(scores.df)
}



pos <- scan("positive-words.txt", what='character')
neg <- scan("negative-words.txt", what='character')


#Add words to list
pos.words <- c(pos, 'upgrade')
neg.words <- c(neg, 'wtf', 'wait','waiting', 'epicfail', 'mechanical')
