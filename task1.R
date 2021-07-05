# ===== LIBRARIES =====

library(data.table)
library(stringr)

# ===== READ FILES ======

#download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", "data.zip")
#unzip("./data.zip",exdir=".") 

con <- file("./final/en_US/en_US.blogs.txt", open = "rb")
blogs <- readLines(con, skipNul = TRUE, encoding = "UTF-8") 
close(con)

con <- file("./final/en_US/en_US.news.txt", open = "rb")
news <- readLines(con, skipNul = TRUE, encoding = "UTF-8") 
close(con)

con <- file("./final/en_US/en_US.twitter.txt", open = "rb")
twitter <- readLines(con, skipNul = TRUE, encoding = "UTF-8") 
close(con)

# ===== FILE STATISTICS =====
char_blogs <- str_count(paste(blogs), ".")
char_news <- str_count(paste(news), ".")
char_twitter <- str_count(paste(twitter), ".")

file_stats <- data.frame(
    file = c("blogs", "news", "twitter"),
    file_size = c(
        format(object.size(blogs), units="MB", standar="SI"),
        format(object.size(news), units="MB", standar="SI"),
        format(object.size(twitter), units="MB", standar="SI")
    ),
    line_count = c(
        format(length(blogs), big.mark=","),
        format(length(news), big.mark=","),
        format(length(twitter), big.mark=",")
    ),
    char_count = c(
        format(sum(char_blogs), big.mark=","),
        format(sum(char_news), big.mark=","),
        format(sum(char_twitter), big.mark=",")
    ),
    char_mean = c(
        format(mean(char_blogs), big.mark=","),
        format(mean(char_news), big.mark=","),
        format(mean(char_twitter), big.mark=",")
    )
)
file_stats
dput(file_stats, "file_stats.csv")
# ===== CLEANING =====
# Combine and sample data
set.seed(2021)
rawData <- data.frame(blogs = sample(blogs, length(blogs) * 0.01), 
                      news = sample(news, length(blogs) * 0.01),
                      twitter = sample(twitter, length(blogs) * 0.01)
            )

# Remove numbers, special characters, trailing white spaces, single characters, and articles
regex <- "[^a-zA-z ']|[ \t]+$|(\\s+)(a|an|the)(\\s+)|^. |(\\S+)?(fuck|shit|pussy|cock|dick|ass|bitch)(\\S+)?"
rawData <- lapply(rawData, str_replace_all, regex, " ")
# Repeat for single characters and trimmed strings
regex <- "\\s\\S\\s|[ \t]+$| ing"
rawData <- lapply(rawData, str_replace_all, regex, " ")

# Turn to lower cases
rawData <- lapply(rawData, tolower)

# Split columns of rawData
blogs <- rawData$blogs
news <- rawData$news
twitter <- rawData$twitter

# Clear memory
rm(con, char_blogs, char_news, char_twitter, blogs, twitter, news, file_stats, regex)


