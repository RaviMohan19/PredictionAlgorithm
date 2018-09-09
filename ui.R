#
# This is the user-interface definition of a Shiny web application. 
# The script is in reference with Datascience Capstone Project
# App Name: Prediction Algorithm App
# Author: Ravi. M.B
# Date: 09-01-2018
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
# 




suppressWarnings(library(shiny))
suppressWarnings(library(markdown))
shinyUI(navbarPage(("Prediction Algorithm"),
                   
                   tabPanel("Welcome",
                     h2("Welcome to Prediction Algorithm App"),
                     includeMarkdown("Instructions.Rmd")
                     
                     ),
                   
                   tabPanel("Next Word Prediction",
                            
                            # Sidebar
                            sidebarLayout(
                              sidebarPanel(
                                h4("Enter your input below to begin the process of next word prediction"),
                                textInput("inputString", "User Input",value = ""),
                                br(),
                                br(),
                                br(),
                                br()
                              ),
                              mainPanel(
                                h4("The Next Word Prediction for the user input"),
                                verbatimTextOutput("prediction"),
                                h4("Sentence Input:"),
                                tags$style(type='text/css', "body {padding-top: 70px;}",'#text1 {background-color: rgba(255,255,0,0.40); color: black;}'), 
                                verbatimTextOutput('text1'),
                                br(),
                                h4("Ngram being used:"),
                                tags$style(type='text/css', "body {padding-top: 70px;}",'#text2 {background-color: rgba(255,255,0,0.40); color: black;}'),
                                verbatimTextOutput('text2')
                              )
                            )
                            
                   ),
                   tabPanel("About",
                            mainPanel(
                              includeMarkdown("AboutApp.Rmd")
                            )
                   ),
                   
                   includeCSS("styles.css")
                   
)
)