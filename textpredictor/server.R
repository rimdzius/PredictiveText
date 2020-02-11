#'
#' This app allows a user to input a character string, and a predicted next word
#' is shown on the button below the text box.
#' The user can click on the button to add that word to the end of the string.
#'

library("shiny")
library("dplyr")
library("quanteda")
library("readr")

## Read in the preprocessed data. The data are sorted by highest frequency.
## See the preprocessing() function from the "preprocessing.R" file.
ngrams <- list()
freqs <- list()
for (num_ngrams in 2:4){
    ngrams[[num_ngrams]] <- read_lines(paste0(num_ngrams,"gram.txt"))
    freqs[[num_ngrams]] <- read_lines(paste0(num_ngrams,"gram_freq.txt"))
}
## Read in top 100 words from WIipedia: https://en.wikipedia.org/wiki/Most_common_words_in_English
top100 <- read_lines("top100.txt")



shinyServer(function(input, output, session) {
    
    ## Main function for this app.
    prediction <- reactive({
        text <- input$inputtext
        
        ## If there is no text in the input box, then the program will sample 1 word
        ## from the top100 words database.
        if(text=="") {
            sample(top100, 1)
        
        ## If the user inputs text, the prediction algorithm will run and return
        ## the top 1 word from the database.
        } else {
            # Tokenize the input
            toks <- tokens(char_tolower(text), remove_numbers = TRUE, remove_punct = TRUE, remove_symbols = TRUE)
            # Set the number of words to use (max = number of ngrams minus 1.)
            length <- ifelse(length(toks[[1]]) < num_ngrams - 1, length(toks[[1]]), num_ngrams - 1)
            # Create blank prediction and probability vectors.
            prediction <- c()
            probability <- c()
            # Loop over the ngram datasets
            for(num_ngram in 2:(length(ngrams))){
                # Within each ngram, loop over the number of words (2 words in a 3-gram, 1 word in a 3-gram)
                for(num_words in length:1){
                    # Lookup_text concatenates the text with "_"
                    lookup_text <- paste0(paste(toks[[1]][(length(toks[[1]])-num_words+1):(length(toks[[1]]))], collapse="_"),"_")
                    # Find any positions with the lookup text within the ngram.
                    results_position <- grep(paste0("^",lookup_text),ngrams[[num_ngram]])
                    # Get the words and the frequencies for those positions found.
                    results <- ngrams[[num_ngram]][results_position]
                    results_freq <- freqs[[num_ngram]][results_position]
                    # Extract the final word from the ngrams found
                    final_word <- strsplit(results[1],"_")[[1]][num_ngram]
                    # Get the probability of the given word.
                    final_word_prob <- round(as.numeric(results_freq[1])/sum(as.numeric(results_freq)),2)
                    
                    # If no matches were found, move on to the next word combination.
                    if(is.na(final_word)) {
                        next
                    # If matches were found, add the highest frequency word, and probability to the vectors
                    } else {
                        prediction <- c(prediction, final_word)
                        probability <- c(probability, final_word_prob)
                        break
                    }
                }
            }
            
            # Create a dataframe with all of the results found.
            results <- data.frame(Prediction = prediction, Probability = probability)
            # Arrange the dataframe in decreasing probability.
            results <- arrange(results, desc(Probability))
            
            if (length(results) == 0) {
                return(sample(top100, 1))
            } else {
            return(as.character(results[1,1]))
            }
            }
    })
    
    ## This is the clickable button. The label is shown as the predicted word from above.
    output$button <- renderUI({
        actionButton(inputId = "button", label = prediction())
    })
    
    ## This is the button action. If clicked, it will add the predicted word to
    ## the end of the input. (if statement simply checks if there is already a
    ## space at the end of the input)
    observeEvent(input$button, {
        isolate(if(substr(input$inputtext, nchar(input$inputtext), nchar(input$inputtext))==" "){
            updateTextAreaInput(session, inputId = "inputtext", value = paste0(input$inputtext, prediction()))
        } else {
            updateTextAreaInput(session, inputId = "inputtext", value = paste(input$inputtext, prediction()))
        })
    })

})