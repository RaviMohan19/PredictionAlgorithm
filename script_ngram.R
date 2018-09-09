# Author : Ravi. M.B
# Title: Prediction Algorithm 
# Date: 09-01-2018

# Load the necessary packages 
library(tm)
library(stringi)
library(stringr)
library(data.table)
library(ggplot2)
library(RWeka)
library(R.utils)
library(dplyr)
library(doParallel)
library(magrittr)
library(wordcloud)

# The requisite HC Corpora Dataset from below mentioned URL
# ("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip") 
# was extracted for analysis.
# Post extracting HC Corpora Dataset 
# relevant files were read from the requisite folder

read_file1 <- file("./Coursera-Swiftkey/final/en_US/en_US.twitter.txt", open = "rb")
twitter <- readLines(read_file1, skipNul = TRUE, encoding="UTF-8")
close(read_file1)

read_file2 <- file("./Coursera-Swiftkey/final/en_US/en_US.news.txt", open = "rb")
news <- readLines(read_file2, skipNul = TRUE, encoding="UTF-8")
close(read_file2)

read_file3 <- file("./Coursera-Swiftkey/final/en_US/en_US.blogs.txt", open = "rb")
blogs <- readLines(read_file3, skipNul = TRUE, encoding="UTF-8")
close(read_file3)



# sampling text files 
set.seed(123)

SampleTwitter <- sample(twitter, size = 5000, replace = TRUE)
SampleBlog <- sample(blogs, size = 5000, replace = TRUE)
SampleNews <- sample(news, size = 5000, replace = TRUE)

# combining sampled texts into one variable
SampleAll <- c(SampleBlog, SampleNews, SampleTwitter)

# write sampled texts into text files for further analysis
writeLines(SampleAll, "./sampleall/SampleAll.txt")


# Data Cleaning
# TM package is used to clean the sample text
# The sampled text data is converted to lowercase
# The sampled text data is utilized with no empty spaces
# Punctuation and numbers are removed from the sampled text data

cleansing <- function (textcp) {
  textcp <- tm_map(textcp, content_transformer(tolower))
  textcp <- tm_map(textcp, stripWhitespace)
  textcp <- tm_map(textcp, removePunctuation)
  textcp <- tm_map(textcp, removeNumbers)
  textcp
}

SampleAll <- VCorpus(DirSource("./sampleall", encoding = "UTF-8"))

# tokenizing the sampled text data
SampleAll <- cleansing(SampleAll)

# Defining the function to create N grams
tdm_Ngram <- function (textcp, n) {
  NgramTokenizer <- function(x) {RWeka::NGramTokenizer(x, RWeka::Weka_control(min = n, max = n))}
  tdm_ngram <- TermDocumentMatrix(textcp, control = list(tokenizer = NgramTokenizer))
  tdm_ngram
}

# Defining the function to extract the N grams and sort the N grams
ngram_sorted_df <- function (tdm_ngram) {
  tdm_ngram_m <- as.matrix(tdm_ngram)
  tdm_ngram_df <- as.data.frame(tdm_ngram_m)
  colnames(tdm_ngram_df) <- "Count"
  tdm_ngram_df <- tdm_ngram_df[order(-tdm_ngram_df$Count), , drop = FALSE]
  tdm_ngram_df
}

# Calculate N-Grams
tdm_1gram <- tdm_Ngram(SampleAll, 1)
tdm_2gram <- tdm_Ngram(SampleAll, 2)
tdm_3gram <- tdm_Ngram(SampleAll, 3)
tdm_4gram <- tdm_Ngram(SampleAll, 4)


# Extract term-count tables from N-Grams and sort 
tdm_1gram_df <- ngram_sorted_df(tdm_1gram)
tdm_2gram_df <- ngram_sorted_df(tdm_2gram)
tdm_3gram_df <- ngram_sorted_df(tdm_3gram)
tdm_4gram_df <- ngram_sorted_df(tdm_4gram)

# Save data frames into r-compressed files

# Quadgram data frame
quadgram <- data.frame(rows=rownames(tdm_4gram_df),count=tdm_4gram_df$Count)
quadgram$rows <- as.character(quadgram$rows)
quadgram_split <- strsplit(as.character(quadgram$rows),split=" ")
quadgram <- transform(quadgram,first = sapply(quadgram_split,"[[",1),second = sapply(quadgram_split,"[[",2),third = sapply(quadgram_split,"[[",3), fourth = sapply(quadgram_split,"[[",4))
quadgram <- data.frame(unigram = quadgram$first,bigram = quadgram$second, trigram = quadgram$third, quadgram = quadgram$fourth, freq = quadgram$count,stringsAsFactors=FALSE)
write.csv(quadgram[quadgram$freq > 1,],"./ShinyApp/quadgram.csv",row.names=F)
quadgram <- read.csv("./ShinyApp/quadgram.csv",stringsAsFactors = F)
saveRDS(quadgram,"./ShinyApp/quadgram.RData")

# Trigram data frame
trigram <- data.frame(rows=rownames(tdm_3gram_df),count=tdm_3gram_df$Count)
trigram$rows <- as.character(trigram$rows)
trigram_split <- strsplit(as.character(trigram$rows),split=" ")
trigram <- transform(trigram,first = sapply(trigram_split,"[[",1),second = sapply(trigram_split,"[[",2),third = sapply(trigram_split,"[[",3))
trigram <- data.frame(unigram = trigram$first,bigram = trigram$second, trigram = trigram$third, freq = trigram$count,stringsAsFactors=FALSE)
write.csv(trigram[trigram$freq > 1,],"./ShinyApp/trigram.csv",row.names=F)
trigram <- read.csv("./ShinyApp/trigram.csv",stringsAsFactors = F)
saveRDS(trigram,"./ShinyApp/trigram.RData")

# Bigram data frame
bigram <- data.frame(rows=rownames(tdm_2gram_df),count=tdm_2gram_df$Count)
bigram$rows <- as.character(bigram$rows)
bigram_split <- strsplit(as.character(bigram$rows),split=" ")
bigram <- transform(bigram,first = sapply(bigram_split,"[[",1),second = sapply(bigram_split,"[[",2))
bigram <- data.frame(unigram = bigram$first,bigram = bigram$second,freq = bigram$count,stringsAsFactors=FALSE)
write.csv(bigram[bigram$freq > 1,],"./ShinyApp/bigram.csv",row.names=F)
bigram <- read.csv("./ShinyApp/bigram.csv",stringsAsFactors = F)
saveRDS(bigram,"./ShinyApp/bigram.RData")

