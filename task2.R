library(quanteda)
library(quanteda.textstats)
#library(quanteda.textplots)
#library(ggplot2)

# ===== FUNCTIONS =====
freqPlot <- function(dfmat, plot_title, top_n = 20){
    dfmat %>% 
        textstat_frequency(n = top_n) %>% 
        ggplot(aes(x = reorder(feature, frequency), y = frequency, 
                   label = frequency, fill = "#FF6666")) +
        geom_bar(stat='identity', show.legend=FALSE) +
        coord_flip() +
        labs(x = NULL, y = "Frequency") +
        geom_text(size = 3, position = position_stack(vjust = 0.5)) +
        ggtitle(plot_title) +
        theme_minimal()
}

# ===== CORPUS =====

corp <- c(
    as.character(rawData$blogs),
    as.character(rawData$news),
    as.character(rawData$twitter)
)

#bcorp <- corpus(blogs)
#ncorp <- corpus(news)
#tcorp <- corpus(twitter)
corp <- corpus(corp, unique_docnames = FALSE)
docnames(corp) <- c("blogs", "news", "twitter")


# ===== TOKENIZATION =====

tok <- tokens(corp, remove_punct = TRUE, remove_symbols = TRUE, include_docvars = TRUE,
              remove_url = TRUE)

tok_2gram <- tokens_ngrams(tok, n = 2, concatenator = " ")
tok_3gram <- tokens_ngrams(tok, n = 3, concatenator = " ")
tok_4gram <- tokens_ngrams(tok, n = 4, concatenator = " ")
tok_5gram <- tokens_ngrams(tok, n = 5, concatenator = " ")

# ===== DOCUMENT-FEATURE MATRIX =====
dfmat <- dfm(tok)
#ndoc(dfmat)
#nfeat(dfmat)

#featnames(dfmat)
#sort(colSums(dfmat), decreasing = TRUE)
#topfeatures(dfmat, 50)

# Min 4 char
dfmat_4char <- dfm_keep(dfmat, min_nchar = 4)
#topfeatures(dfmat_4char, 50)

# 2 and 3-grams
dfmat_2gram <- dfm(tok_2gram)
dfmat_3gram <- dfm(tok_3gram)
dfmat_4gram <- dfm(tok_4gram)
dfmat_5gram <- dfm(tok_5gram)

saveRDS(dfmat_4char, "./prediction/dfmat_4char.RDS")
saveRDS(dfmat_2gram, "./prediction/dfmat_2gram.RDS")
saveRDS(dfmat_3gram, "./prediction/dfmat_3gram.RDS")
saveRDS(dfmat_4gram, "./prediction/dfmat_4gram.RDS")
saveRDS(dfmat_5gram, "./prediction/dfmat_5gram.RDS")

# ===== STAT ANALYSIS =====
#tstat_freq <- textstat_frequency(dfmat_4char, n = 20)
#print(tstat_freq)

# ===== PLOTS =====
#freqPlot(dfmat_4char, 'Frequency of words with at least 4 characters')
#freqPlot(dfmat_2gram, 'Frequency of 2-grams')
#freqPlot(dfmat_3gram, 'Frequency of 3-grams')

#set.seed(132)
#textplot_wordcloud(dfmat_4char, max_words = 50)

# ===== PER DATA SET =====
#btok <- tokens(bcorp, remove_punct = TRUE, remove_symbols = TRUE, include_docvars = TRUE,
#              remove_url = TRUE)
#ntok <- tokens(ncorp, remove_punct = TRUE, remove_symbols = TRUE, include_docvars = TRUE,
#              remove_url = TRUE)
#ttok <- tokens(tcorp, remove_punct = TRUE, remove_symbols = TRUE, include_docvars = TRUE,
#              remove_url = TRUE)

#bdfmat <- dfm(btok)
#bdfmat <- dfm_keep(bdfmat, min_nchar = 4)
#freqPlot(bdfmat, 'Word Frequency from Blogs dataset')

#ndfmat <- dfm(ntok)
#ndfmat <- dfm_keep(ndfmat, min_nchar = 4)
#freqPlot(ndfmat, 'Word Frequency from News dataset')

#tdfmat <- dfm(ttok)
#tdfmat <- dfm_keep(tdfmat, min_nchar = 4)
#freqPlot(tdfmat, 'Word Frequency from Twitter dataset')
