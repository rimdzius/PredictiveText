create_ngram_matrix <- function(n, toks, frequency_coverage, min_frequency) {
      
      suppressWarnings(suppressMessages(require("dplyr")))
      suppressWarnings(suppressMessages(require("quanteda")))
      
      ## Split data into smaller chunks to process.
      cat("Splitting tokens.\n")
      pb <- txtProgressBar(min = 0, max = (4*n), initial = 1, style = 3)
      toks1 <- toks[1:(length(toks)*1/(4*n+1))]
      setTxtProgressBar(pb, 1)
      for(toks_inc in 2:(4*n)) {
            assign(paste0("toks",toks_inc),toks[(length(toks)*toks_inc/(4*n+1)+1):(length(toks)*(toks_inc+1)/(4*n+1))])
            setTxtProgressBar(pb, toks_inc)
      }
      close(pb)
      
      flush.console()
      cat(paste0("n=",n," n-gram running.\n"))
      pb <- txtProgressBar(min = 0, max = (4*n), initial = 0, style = 3)
      ngram_tok <- tokens_ngrams(toks1, n)
      ngram_dfm <- dfm(ngram_tok)
      rm(ngram_tok, toks1)
      setTxtProgressBar(pb, 1)
      
      for(toks_inc in 2:(4*n)) {
            ngram_tok <- tokens_ngrams(eval(as.name(paste0("toks",toks_inc))), n)
            ngram_dfm <- rbind(ngram_dfm, dfm(ngram_tok))
            rm(ngram_tok, list = paste0("toks",toks_inc))
            setTxtProgressBar(pb, toks_inc)
      }
      close(pb)
      
      cat("Creating dataframe...\n")
      ngram <- data.frame(names = colnames(ngram_dfm),
                          frequency = colSums(ngram_dfm))
      rm(ngram_dfm)
      rownames(ngram) <- c()
      ngram <- arrange(ngram, desc(frequency))
      ngram <- ngram[ngram$frequency >= min_frequency,]
      
      cat(paste0("Extracting per frequency coverage (",frequency_coverage*100,"%)\n"))
      total_freq <- sum(ngram$frequency)
      freq_test <- 0
      for(row_num in 1:(length(ngram$frequency))) {
            freq_test <- freq_test + ngram$frequency[row_num]
            if(freq_test / total_freq >= frequency_coverage) {
                  break
            }
      }
      
      ngram <- ngram[1:row_num,]
}