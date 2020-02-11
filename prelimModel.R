## Function accepts a text string and returns the highest frequency words back.
predictText <- function(text) {
   
   suppressWarnings(suppressMessages(require("dplyr")))
   suppressWarnings(suppressMessages(require("readr")))
   suppressWarnings(suppressMessages(require("quanteda")))
   set.seed(1337)
   
   ## Read in the preprocessed data.
   ## See the preprocessing() function from the "preprocessing.R" file.
   ngrams <- list()
   freqs <- list()
   for (num_ngrams in 2:4){
      ngrams[[num_ngrams]] <- read_lines(paste0("ngrams/",num_ngrams,"gram.txt"))
      freqs[[num_ngrams]] <- read_lines(paste0("ngrams/",num_ngrams,"gram_freq.txt"))
   }
   
   toks <- tokens(char_tolower(text), remove_numbers = TRUE, remove_punct = TRUE, remove_symbols = TRUE)
   length <- ifelse(length(toks[[1]]) < num_ngrams - 1, length(toks[[1]]), num_ngrams - 1)
   prediction <- c()
   probability <- c()
   
   
   for(num_ngram in 2:(length(ngrams))){
      for(num_words in length:1){
         lookup_text <- paste0(paste(toks[[1]][(length(toks[[1]])-num_words+1):(length(toks[[1]]))], collapse="_"),"_")
         results_position <- grep(paste0("^",lookup_text),ngrams[[num_ngram]])
         results <- ngrams[[num_ngram]][results_position]
         results_freq <- freqs[[num_ngram]][results_position]
         final_word <- strsplit(results[1],"_")[[1]][num_ngram]
         final_word_prob <- round(as.numeric(results_freq[1])/sum(as.numeric(results_freq)),2)
         
         if(is.na(final_word)) {
            next
         } else {
            prediction <- c(prediction, final_word)
            probability <- c(probability, final_word_prob)
            break
         }
      }
   }
   
   results <- data.frame(Prediction = prediction, Probability = probability)
   results <- arrange(results, desc(Probability))
   results_less_stop <- tokens(as.character(results$Prediction))
   results_less_stop <- tokens_remove(results_less_stop, pattern = stopwords('en'))
   results_less_stop <- dfm(results_less_stop)
   results_less_stop <- featnames(results_less_stop)[1]
   if(!is.na(results_less_stop)){
      return(results_less_stop)
   } else {
      return(as.character(results[1,1]))
   }
}