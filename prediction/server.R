library(shiny)
library(data.table, verbose=FALSE)
library(quanteda, verbose=FALSE)
library(quanteda.textstats, verbose=FALSE)
library(stringr, verbose=FALSE)
source("./predict.R")

shinyServer(function(input, output, session) {
    
    # Read tokens and n-grams
    dfmat_1gram <- readRDS("./dfmat_4char.RDS")
    dfmat_2gram <- readRDS("./dfmat_2gram.RDS")
    dfmat_3gram <- readRDS("./dfmat_3gram.RDS")
    dfmat_4gram <- readRDS("./dfmat_4gram.RDS")
    dfmat_5gram <- readRDS("./dfmat_5gram.RDS")
    dfmat <- c(dfmat_1gram, dfmat_2gram, dfmat_3gram, dfmat_4gram, dfmat_5gram)
    
    # Retrieve English stopwords
    stop <- stopwords("en")
    
    # ===== Predict and return top 3 words =====
    predicted <- reactive({
        # Start timer
        start_time <- Sys.time()
        
        # Remove multiple white spaces and change to lower case
        text <- str_squish(input$text1)
        text <- str_to_lower(text)
        
        # Tokenize input text
        token <- unlist(strsplit(text, " "))
        
        # Remove stopwords from input text
        token <- token[!(unlist(token) %in% stop)]
        
        # Get number of words
        w <- sapply(strsplit(text, " "), length)
        
        # Restrict w <= 4
        if(w > 4) w <- 4
        
        # While there are less than 3 predictions returned
        ret <- FALSE
        first <- TRUE
        while(ret == FALSE){
            # If first prediction
            if(first){
                top3 <- predictWord(text, token, dfmat, w)
                first <- FALSE
            }
            
            # If 3 predictions are returned, exit loop
            if(sum(!is.na(top3)) == 3) break
            
            # Else, decrement w and retrieve more predictions
            else{
                w <- w-1
                addPred <- predictWord(text, token, dfmat, w) # predict again
                top3 <- c(top3, addPred) # combine previous and current results
                top3 <- top3[!is.na(top3)]
                top3 <- top3[1:3]          # retrieve first 3
                top3 <- unlist(top3)
            } 
        }
        
        # End timer
        end_time <- Sys.time()
        time <- end_time - start_time
        
        # Return top3 and time
        list <- c(top3, time)
        return(list)
   })
    
    
    # ==== Set button text =====
    output$uio1 <- renderUI({
        actionButton("btn1", label = predicted()[1], width = "170px",
                     onclick="document.getElementById('text1').value += ' ' +
                     document.getElementById('btn1').innerText")
    })
    output$uio2 <- renderUI({
        actionButton("btn2", label = predicted()[2], width = "170px",
                     onclick="document.getElementById('text1').value += ' ' +
                     document.getElementById('btn2').innerText")
    })
    output$uio3 <- renderUI({
        actionButton("btn3", label = predicted()[3], width = "170px",
                     onclick="document.getElementById('text1').value += ' ' +
                     document.getElementById('btn3').innerText")
    })
    
    
    # Set output time
    output$time <- renderText(
        paste(format(round(as.numeric(predicted()[4]), 4), nsmall = 4), "seconds")
    )

})
