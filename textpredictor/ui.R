#'
#' This app allows a user to input a character string, and a predicted next word
#' is shown on the button below the text box.
#' The user can click on the button to add that word to the end of the string.
#'

library("shiny")
library("quanteda")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    fluidRow(
        column(12,
               h1("Text Predictor"),
               p("The app will run interactively as you type. Please be patient for results!"),
               p("Click the button below to add the predicted word to the end of the input."))
    ),

    ## Input text box
    fluidRow(
        column(12,
               textAreaInput(inputId = "inputtext", label = NULL, value = "", width = "500px", height = "200px", resize = "both"))
    ),
    
    ## Prediction button (see server.R for details)
    fluidRow(
        column(12,
               uiOutput("button"))
    ),
    
    hr(),
    
    ## Byline information
    fluidRow(
        column(12,
               p("Author: Daniel Rimdzius"),
               p("Date: 2020-02-10"),
               p("Course: Johns Hopkins University, Data Science Capstone through Coursera"),
               tagList("For further details, see:", a("github.com/rimdzius/PredictiveText", href = "https://github.com/rimdzius/PredictiveText")))
    )
    
))