create_tokens <- function(sample, rmv_stop = FALSE){
      
      suppressWarnings(suppressMessages(require("readr")))
      suppressWarnings(suppressMessages(require("quanteda")))
      
      cat("Reading blogs... ")
      blog <- read_lines("final/en_US/en_US.blogs.txt",
                         progress = FALSE)
      cat("news... ")
      news <- read_lines("final/en_US/en_US.news.txt",
                         progress = FALSE)
      cat("tweets...\n")
      twitter <- read_lines("final/en_US/en_US.twitter.txt",
                            progress = FALSE)
      
      cat("Please be patient: Creating tokens... ")
      toks <- tokens((corpus(char_tolower(blog)) +
                            corpus(char_tolower(news)) +
                            corpus(char_tolower(twitter))),
                     remove_numbers = TRUE,
                     remove_punct = TRUE,
                     remove_symbols = TRUE)
      
      rm(blog, news, twitter)
      
      if(!(sample==1.0)){ toks <- tokens_sample(toks,sample*length(toks)) }
      if (rmv_stop) { toks <- tokens_remove(toks, pattern = stopwords('en')) }
      
      cat("Tokens complete.\n")
      toks
}