---
title: 'Reproducible Pitch: Prediction Algorithm'
author: "Ravi M.B"
date: "September 9, 2018"
output: 
  ioslides_presentation: 
    highlight: tango
    incremental: yes
    keep_md: yes
    smaller: yes
    transition: slower
    widescreen: yes
---

## Introduction

- Computers and smart phones are changing the perception of user experience, over the years systems have evolved and still continue the trend of evolving to unimaginable heights 

- Users during this evolution are increasing with each passing day, along with the users so is their data too which is increasing exponentially

- To give the systems ability to analyze the data, Researchers have come up with the concept of Natuarl Language Processing(NLP)

- The web application constructed with a shiny app UI that will predict the next word as the user types a sentence similar to the *Swiftkey technology*

## Application Basis

[HC Corpora Dataset]("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip") is used for the necessary analysis and further to build the app. The build the web application performs below mentioned tasks were executed.

- Understanding the Problem of prediction
- Getting and Cleaning the requisite data 
- Exploratory Data Analysis  
- Modeling
- Constructing a Prediction Model
- Creative Exploration
- Data Product

## Prediction Algorithm

After researching on the world wide web, it is observed the predictive model suitable for the application is [Katz backoff model]("https://en.wikipedia.org/wiki/Katz%27s_back-off_model").

- For prediction of the next word, Quadgram is first used (first three words of Quadgram are the last three words of the user provided sentence).
- If no Quadgram is found, back off to Trigram (first two words of Trigram are the last two words of the sentence).
- If no Trigram is found, back off to Bigram (first word of Bigram is the last word of the sentence)
- If no Bigram is found, back off to the most common word with highest frequency 'the' is returned.

## Next Word Prediction APP

- The prediction algortithm is based on the concepts of Natural Language Processing(NLP). 
- The accuarcy of the prediction will not be ideally 100 percent, but still the algorithm tries efficiently to identify the suitable next word for the input provided by the user. 
- To provide the desired input select any one of the three text files *en_US.blogs.txt*, *en_US.news.txt*, *en_US.twitter.txt* from the [HC Corpora Dataset]("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"). Post provision of the input from the user the algorithm predicts the next suitable word, user can put five phrases drawn from Twitter or news articles in English leaving out the last word, the application will give a prediction for each entry. 
- For instance user could try input as "*the first time i saw the movie i was a little more than a decade ago*"
- The application is available at [shinyapp]("https://ravimohan19.shinyapps.io/ShinyApp-Pred/")
- The relevant R scripts and the data files are avaiable at [Algorithm]("https://github.com/RaviMohan19/PredictionAlgorithm")
  

  



