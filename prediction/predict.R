# ===== PREDICTION ALGORITHM =====
predictWord <- function(text, token, ngram, w){
    
    # Set n in n-gram and restrict it to the set [1,5]
    n <- w + 1
    if(n < 1) n <- 1
    
    # Get last w words
    text <- tail(unlist(strsplit(text, " ")), w)
    text <- paste(unlist(text), collapse = " ")
    
    # Add ^ to mark the beginning of string
    pattern <- paste0("^", text) 
    
    # If no predictions returned, get the top features of 1-gram
    if(w<=0){
        filtered <- unlist(ngram[[n]])
        
    # If there are still words remaining
    }else if(w>0){
        
        # Retrieve n-grams containing text
        filtered <- dfm_keep(unlist(ngram[[n]]), pattern, valuetype = c("regex"))
    }
    
    # Get the top 3 n-grams
    result <- unlist(attributes(topfeatures(filtered, 3)))
    
    # Remove the first word for the top 3 results
    top3 <- sapply(result, word, -1)
    
    # Return top3
    top3
}